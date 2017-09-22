class NotificationRule < Pagerduty
    include Virtus.model
    include Pagerduty::Helpers::Common

    attribute :id, String
    attribute :type, String, :default => 'assignment_notification_rule'
    attribute :summary, String
    attribute :self, String
    attribute :html_url, String

    attribute :contact_method, ContactMethod
    attribute :urgency, String
    attribute :start_delay_in_minutes, Integer

    attribute :user_id, String

    def contact_method=(method)
        @contact_method = contact_method_from_string(method['type'] || method[:type]).new method
    end

    def prepare
        remove_keys = [
            :user_id, :id, :summary, :self, :html_url,
        ]

        post_attributes = truncate_keys(remove_keys, self.attributes)
        post_attributes = truncate_nil_keys(post_attributes)
    end

    def save
        return unless @id.nil?

        post_attributes = prepare

        #user_id = post_attributes[:self].match(/\/users\/([A-Z|0-9]+)/).captures.first

        response = client.post do |request|
            request.url "/users/#@user_id/notification_rules"
            request.headers['Content-Type'] = 'application/json'
            request.body = {'notification_rule' => post_attributes}.to_json
        end

        handle_bad_response(response) unless response.status.eql? 200

        response
    end

    def update
        return unless @id

        post_attributes = prepare
        user_id = @self.match(/\/users\/([A-Z|0-9]+)/).captures.first

        response = client.put do |request|
            request.url "/users/#{user_id}/notification_rules/#@id"
            request.headers['Content-Type'] = 'application/json'
            request.body = {'notification_rule' => post_attributes}.to_json
        end

        handle_bad_response(response) unless response.status.eql? 200

        response
    end

    def delete
        return unless @self

        user_id = @self.match(/\/users\/([A-Z|0-9]+)/).captures.first

        response = client.delete do |request|
            request.url "/users/#{user_id}/notification_rules/#@id"
            request.headers['Content-Type'] = 'application/json'
        end

        handle_bad_response(response) unless response.status.eql? 204

        response
    end
end
