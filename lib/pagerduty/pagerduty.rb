require 'faraday'
require 'faraday_middleware'
require 'json'
require 'virtus'
require 'pagerduty/users'
require 'pagerduty/contact_methods'
require 'pagerduty/exceptions'

class Pagerduty

    include Pagerduty::Helpers::Common

    def initialize(params={})
        @@token = params[:token] || ENV['PAGERDUTY_TOKEN']
        @@client = Faraday.new(url: 'https://api.pagerduty.com') do |conn|
            conn.headers['Authorization'] = "Token token=#@@token"
            conn.headers['Accept'] = "application/vnd.pagerduty+json;version=2"
            conn.response :json, :content_type => /bjson$/
            conn.adapter :net_http
        end
    end

    def client
        return @@client
    end

    def list_users
        response = client.get('/users')

        handle_bad_response(response) unless response.status.eql? 200
        Users.new(JSON.parse(response.body))
    end

    def create_user(params)
        # Create the base object with our desired params
        user = User.new(params)

        # Instantiate a new User object using the API response
        user = User.new JSON.parse(user.save.body)['user']
    end

    def get_user(id)
        response = client.get("/users/#{id}")

        handle_bad_response(response) unless response.status.eql? 200

        User.new(JSON.parse(response.body)['user'])
    end

    def delete_user(id)
        user = get_user(id)
        user.delete
    end

    def list_user_contact_methods(id)
        response = client.get("/users/#{id}/contact_methods")
        handle_bad_response(response) unless response.status.eql? 200
        methods = JSON.parse(response.body)

        methods['contact_methods'].inject([]) { |methods, method|
            type = contact_method_from_string(method['type']) || ContactMethod
            method[:user_id] = id
            methods << type.new(method)
        }
    end

    def create_user_contact_method(user_id, params)
        contact_method = contact_method_from_string(params[:type])

        raise Pagerduty::Exceptions::InvalidContactMethodType.new(params[:type]) if contact_method.nil?

        contact_method = contact_method.new(params)
        contact_method.user_id = user_id
        contact_method.save
    end

    def delete_user_contact_method(user_id, contact_method_id)
        response = get_user_contact_method(user_id, contact_method_id).delete
    end

    def get_user_contact_method(user_id, contact_method_id)
        uri = "/users/#{user_id}/contact_methods/#{contact_method_id}"
        response = client.get(uri)
        handle_bad_response(response) unless response.status.eql? 200
        contact_method = JSON.parse(response.body)['contact_method']

        contact_method_type = contact_method_from_string(contact_method['type'])
        contact_method_type.new contact_method
    end

    def list_user_notification_rules(user_id)
        response = client.get("/users/#{user_id}/notification_rules")

        handle_bad_response(response) unless response.status.eql? 200

        rules = JSON.parse(response.body)

        rules['notification_rules'].collect { |rule| NotificationRule.new rule }
    end

    def create_user_notification_rule(user_id, params)
        response = NotificationRule.new(
            user_id: user_id,
            start_delay_in_minutes: params[:start_delay_in_minutes],
            contact_method: params[:contact_method],
            urgency: params[:urgency]
        ).save

        NotificationRule.new JSON.parse(response.body)['notification_rule']
    end

    def delete_user_notification_rule(user_id, notification_rule_id)
        get_user_notification_rule(user_id, notification_rule_id).delete
    end

    def get_user_notification_rule(user_id, notification_rule_id)
        response = client.get("/users/#{user_id}/notification_rules/#{notification_rule_id}")
        handle_bad_response(response) unless response.status.eql? 200
        NotificationRule.new(JSON.parse(response.body)['notification_rule'])
    end
end

Virtus.finalize
