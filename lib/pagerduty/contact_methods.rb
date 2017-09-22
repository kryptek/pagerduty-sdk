require 'pry'
require 'pagerduty/exceptions'

class ContactMethod < Pagerduty
    include Virtus.model
    include Pagerduty::Helpers::Common

	# Optional - Read only
    attribute :id, String
    attribute :type, String, :default => nil
    attribute :summary, String
    attribute :self, String
	attribute :html_url, String

    # Each method has these
    attribute :label, String
    attribute :address, String

    # Added for convenience
	attribute :user_id, String

    def prepare
        remove_keys = [
            :user_id, :id, :summary, :self, :html_url
        ]

        attributes = truncate_keys(remove_keys, self.attributes)
        attributes = truncate_nil_keys(attributes)
    end

    def required_post_keys
        []
    end

    def valid_contact_method_types
        ['email_contact_method', 'phone_contact_method', 'sms_contact_method', 'push_notification_contact_method']
    end

	def save
		return unless self.id.nil?

        raise Pagerduty::Exceptions::InvalidContactMethodType.new(@type) unless valid_contact_method_types.include?(@type)

        attributes = prepare
        validate_attributes(required_post_keys)

		response = client.post do |request|
			request.url "/users/#@user_id/contact_methods"
            request.headers['Content-Type'] = 'application/json'
			request.body = {'contact_method': attributes}.to_json
		end

        handle_bad_response(response) unless response.status.eql? 200

        response
	end

    def update
        # Nothing to be updated here
        return if self.class == ContactMethod

		attributes = truncate_keys([:user_id], self.attributes)

        response = client.put do |request|
            request.url "/users/#@user_id/contact_methods/#@id"
            request.headers['Content-Type'] = 'application/json'
            request.body = {'contact_method': attributes}.to_json
        end

        handle_bad_response(response) unless response.status.eql? 200

        response
    end

    def delete
        user_id = @self.match(/\/users\/([A-Z|0-9]+)/).captures.first

        response = client.delete do |request|
            request.url "/users/#{user_id}/contact_methods/#@id"
            request.headers['Content-Type'] = 'application/json'
        end

        handle_bad_response(response) unless response.status.eql? 204

        response
    end
end

class EmailContactMethod < ContactMethod
	attribute :type, String, :default => 'email_contact_method'

    # Type can be email_contact_method
    attribute :send_short_email, Boolean

    def required_post_keys
        required_keys = [:type, :label, :address]
    end

end

class PhoneContactMethod < ContactMethod
	attribute :type, String, :default => 'phone_contact_method'

	# Read only
    attribute :enabled, Boolean
    attribute :blacklisted, Boolean

    # Type can be phone_contact_method or sms_contact_method
    attribute :country_code, Integer

end

class PushContactMethodSound
    include Virtus.model

    # Type can be alert_high_urgency or alert_low_urgency
    attribute :type, String
    attribute :file, String
end

class PushContactMethod < ContactMethod
	attribute :type, String, :default => 'push_notification_contact_method'

	# Read only
    attribute :device_type, String
    attribute :blacklisted, Boolean

    # Type can be push_notification_contact_method
    attribute :sounds, Array[PushContactMethodSound]
    attribute :created_at, String

end
