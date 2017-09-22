require 'vcr'
require 'pagerduty'
require 'pagerduty/contact_methods'
require 'pagerduty/exceptions'

require 'pry'

include Pagerduty::Helpers::Common

puts "I'm running from #{File.dirname(__FILE__)}"
VCR.configure do |config|
    config.cassette_library_dir = "#{File.dirname(__FILE__)}/vcr_cassettes"
    config.hook_into :faraday
    config.filter_sensitive_data('<REDACTED>') { ENV['PAGERDUTY_TOKEN'] }
end

describe Pagerduty do
    let(:pagerduty) { Pagerduty.new(token: ENV['PAGERDUTY_TOKEN']) }

    let(:user)  {
        VCR.use_cassette('users#create_user', :record => :new_episodes) do
            pagerduty.create_user(
                type: 'user',
                name: 'Pagerduty SDK User',
                email: 'pagerduty-sdk@pagerduty-sdk.com',

                # "That's the stupidest combination I've ever heard of in my life!
                # That's the kinda thing an idiot would have on his luggage!"
                password: '12345'
           )
        end
    }

    describe User do
        context '#list_users' do
            it 'returns a Users object' do
                VCR.use_cassette('users#list_users') do
                    expect(pagerduty.list_users).to be_an_instance_of(Users)
                end
            end

            it 'has an Array attribute with each User' do
                VCR.use_cassette('users#list_users') do
                    expect(pagerduty.list_users.users).to be_an_instance_of(Array)
                end
            end
        end

        context '#get_user' do
            it 'returns a single user' do
                VCR.use_cassette('users#get_user') do
                    expect(pagerduty.get_user(user.id).id).to eq(user.id)
                end
            end

            it 'returns a User object' do
                VCR.use_cassette('users#get_user') do
                    expect(pagerduty.get_user(user.id).instance_of? User).to be true
                end
            end
        end

        context '#update_user' do
            it 'updates user attributes' do
                user.description = 'HNIC'
                VCR.use_cassette('users#update') do
                    update = User.new JSON.parse(user.update.body)['user']
                    expect(update.description).to eq(user.description)
                end
            end
        end

    end

    describe ContactMethod do
        subject(:contact_methods) {
            VCR.use_cassette('users#list_user_contact_methods') do
                pagerduty.list_user_contact_methods(user.id)
            end
        }

        context '#list_user_contact_methods' do

            before {
            }

            it 'returns all of a users contact methods' do
                expect(contact_methods.empty?).to be false
            end

            it 'returns a list of appropriately typed ContactMethod objects' do
                contact_methods.each do |contact_method|
                    expect(contact_method).to be_an_instance_of(contact_method_from_string(contact_method.type))
                end
            end
        end

        context '#get_user_contact_method' do
            it 'returns a single contact method for a user' do
                VCR.use_cassette('users#get_user_contact_method') do
                    contact_method = pagerduty.get_user_contact_method(user.id, contact_methods.first.id)
                    expect(contact_method.class < ContactMethod).to be true
                end
            end

            it 'returns the appropriate ContactMethod object' do
                VCR.use_cassette('users#get_user_contact_method') do
                    contact_method = pagerduty.get_user_contact_method(user.id, contact_methods.first.id)
                    type = contact_method_from_string(contact_method.type)
                    expect(contact_method.instance_of? type).to be true
                end
            end

            it 'raises an exception if the contact method is not found' do
                VCR.use_cassette('users#get_bad_user_contact_method') do
                    contact_method_id = 'XXXXXXX'
                    expect {pagerduty.get_user_contact_method(user.id, contact_method_id)}.to raise_error Pagerduty::Exceptions::NotFound
                end
            end
        end

        context '#create_user_contact_method' do
            it 'creates a single contact method for a user' do
                VCR.use_cassette('users#create_contact_method') do
                    attribs = {type: 'email_contact_method', label: 'pagerduty-sdk', address: 'pagerduty-sdk@pagerduty.com'}

                    contact_method = JSON.parse(pagerduty.create_user_contact_method(
                                                user.id, attribs).body)['contact_method']

                    type = contact_method_from_string(contact_method['type'])
                    contact_method = type.new contact_method

                    expect(contact_method.instance_of? type).to be true
                end
            end

            it 'raises an exception unless all attributes are present' do
                expect { pagerduty.create_user_contact_method('XXXXXX', {}) }.to raise_error Pagerduty::Exceptions::InvalidContactMethodType
            end

            it 'raises an exception if attributes are missing from the Contact Method class when saving' do
                cm = EmailContactMethod.new(user_id: 'XXXXXX', label: 'Some Label')
                expect { cm.save }.to raise_error Pagerduty::Exceptions::MissingAttributes
            end

            it 'raises an exception if the wrong type is set on the Contact Method class' do
                cm = EmailContactMethod.new(user_id: 'XXXXXX', label: 'Some Label', address: 'foo@bar.com', type: 'invalid_type')
                expect { cm.save }.to raise_error Pagerduty::Exceptions::InvalidContactMethodType
            end

        end

        context '#delete_user_contact_method' do
            before {
                VCR.use_cassette('contact_methods#refresh_user_after_creating_contact_method') do
                    @user = pagerduty.get_user(user.id)
                end

                VCR.use_cassette('contact_methods#delete') do
                    @user.contact_methods.last.delete
                end
            }

            it 'deletes a user contact method' do
                VCR.use_cassette('contact_methods#attempt_get_after_delete') do
                    expect { pagerduty.get_user_contact_method(user.id, @user.contact_methods.last.id) }.to raise_error Pagerduty::Exceptions::NotFound
                end
            end

        end

        context '#update' do
            it 'updates contact method properties' do
                contact_method = contact_methods.first

                contact_method.label = 'Pagerduty-SDK'
                VCR.use_cassette('contact_methods#update') do
                    updated = contact_method.class.new JSON.parse(contact_method.update.body)['contact_method']
                    expect(updated.label).to eq(contact_method.label)
                end
            end
        end
    end

    describe NotificationRule do
        context '#list_user_notification_rules' do
            it "an Array" do
                VCR.use_cassette('users#list_user_notification_rules') do
                    notification_rules = pagerduty.list_user_notification_rules(user.id)
                    expect(notification_rules).to be_an_instance_of Array
                end
            end

            it "the returned Array should only have NotificationRule objects" do
                VCR.use_cassette('users#list_user_notification_rules') do
                    notification_rules = pagerduty.list_user_notification_rules(user.id)
                    expect(notification_rules.reject { |n| !n.instance_of? NotificationRule}.one?).to be true
                end
            end
        end

        context 'notification_rule#save' do
            it 'creates a user notification rule' do
                VCR.use_cassette('users#create_user_notification_rule') do
                    cm = user.contact_methods.first
                    cm.type.gsub!(/_reference/, '')
                    rule = pagerduty.create_user_notification_rule(user.id, start_delay_in_minutes: 5, contact_method: {:id => cm.id, :type => cm.type.gsub('_reference', '')}, urgency: 'high')
                    expect(rule.instance_of? NotificationRule).to be true
                end
            end
        end

        context '#get_user_notification_rule' do
            it 'returns a notification rule' do
                VCR.use_cassette('users#get_user_notification_rule') do
                    rule = pagerduty.get_user_notification_rule(user.id, user.notification_rules.first.id)
                    expect(rule.id).to eq(user.notification_rules.first.id)
                end
            end
        end

        context 'notification_rule#update' do
            it 'updates attributes for a notification rule' do
                VCR.use_cassette('users#get_user_notification_rule') do
                    VCR.use_cassette('notification_rules#update') do
                        rule = pagerduty.get_user_notification_rule(user.id, user.notification_rules.first.id)
                        rule.start_delay_in_minutes += 22
                        new_rule = NotificationRule.new JSON.parse(rule.update.body)['notification_rule']
                        expect(new_rule.start_delay_in_minutes).to eq(22)
                    end
                end
            end
        end

        context 'notification_rule#delete' do
            it "deletes a user's notification rule" do
                VCR.use_cassette('users#delete_user_notification_rule') do
                    user.notification_rules.first.delete
                end

                VCR.use_cassette('notification_rules#get_deleted_rule') do
                    expect {pagerduty.get_user_notification_rule(user.id, user.notification_rules.first.id)}.to raise_error Pagerduty::Exceptions::NotFound
                end
            end
        end
    end

    # Tear down the test user that was created
    describe '#delete_user' do
        it 'removes a user' do
            VCR.use_cassette('users#delete_user') do
                pagerduty.delete_user(user.id)
            end
        end
    end
end

