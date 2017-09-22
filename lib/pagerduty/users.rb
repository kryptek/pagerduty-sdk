require 'pagerduty/contact_methods'
require 'pagerduty/coordinated_incidents'
require 'pagerduty/notification_rules'
require 'pagerduty/team'
require 'pagerduty'

class User < Pagerduty
    include Virtus.model
    include Pagerduty::Helpers::Common

    attribute :id, String
    attribute :name, String
    attribute :email, String
    attribute :time_zone, String
    attribute :color, String
    attribute :avatar_url, String
    attribute :billed, Boolean
    attribute :role, String
    attribute :description, String
    attribute :invitation_sent, Boolean
    attribute :contact_methods, Array[ContactMethod]
    attribute :notification_rules, Array[NotificationRule]
    attribute :job_title, String
    attribute :teams, Array[Team]
    attribute :coordinated_incidents, Array[CoordinatedIncident]
    attribute :type, String
    attribute :summary, String
    attribute :self, String
    attribute :html_url, String

    # This private attribute is needed for creating a new user
    attribute :password, String, :reader => :private

    def inspect
        # Created to avoid spewing out the password attribute

        address = (self.object_id << 1).to_s(16)

        "#<User:0x00#{address} " + self.attributes.collect do |k, v|
                v.nil? ? "@#{k}=nil" : "@#{k}=#{v}"
        end.join(" ") + ">"
    end

    def prepare
        # These keys should be removed from the POST request
        remove_keys = [
            :billed, :coordinated_incidents, :invitation_sent
        ]

        optional_keys = [
            # Optional (read only)
            :avatar_url, :contact_methods, :html_url, :id, :invitation_sent,
            :notification_rules, :self, :summary, :teams,

            # Optional
            :color, :description, :job_title, :role, :time_zone
        ]

        post_attributes = truncate_keys(remove_keys, self.attributes)
        post_attributes = truncate_nil_keys(post_attributes)
    end

    def required_post_keys
        [:type, :name, :email]
    end

    def required_put_keys
        [:type, :name, :email]
    end


	def id=(user_id)
		@contact_methods.each { |contact_method| contact_method.user_id = user_id }
		@id = user_id
	end

    def delete
        return false if self.id.nil?

        response = client.delete do |request|
            request.url "/users/#@id"
            request.headers['Content-Type'] = 'application/json'
        end

        handle_bad_response(response) unless response.status.eql? 204

        response
    end

    def update
        put_attributes = prepare
        validate_attributes(required_put_keys)

        put_attributes[:password] = @password unless @password.nil?

        response = client.put do |request|
            request.url "/users/#{self.id}"
            request.headers['Content-Type'] = 'application/json'
            request.body = put_attributes.to_json
        end

        handle_bad_response(response) unless response.status.eql? 200

        response
    end

    def save
        return update unless self.id.nil?

        # This gets around missing the key from required_post_keys due to
        # :password being a private attribute
        raise Pagerduty::Exceptions::MissingAttributes.new([:password]) if @password.nil?

        post_attributes = prepare
        validate_attributes(required_post_keys)

        response = client.post do |request|
            request.url '/users'
            request.headers['Content-Type'] = 'application/json'
            request.body = post_attributes.to_json
        end

        handle_bad_response(response) unless response.status.eql? 201
        response
    end
end


class Users
    include Virtus.model
    attribute :users, Array[User]

    def has_user?(user_name)
        self.users.collect { |user| user.name }.include?(user_name)
    end
end

