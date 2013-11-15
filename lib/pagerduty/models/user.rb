class Pagerduty
  class Users
    class User
      include Pagerduty::Core
      include Virtus.model

      attribute :id
      attribute :name
      attribute :email
      attribute :time_zone
      attribute :color
      attribute :role
      attribute :avatar_url
      attribute :user_url
      attribute :invitation_sent
      attribute :marketing
      attribute :marketing_opt_out
      attribute :type, String, default: 'user'

      #def inspect
      #puts "<Pagerduty::#{self.class}"
      #self.attributes.each { |attr,val| 
      #puts "\t#{attr}=#{val.inspect}"
      #}
      #puts ">"

      #self.attributes
      #end

      # List all incident log entries that describe interactions with the specific user
      #
      # ==== Parameters
      #
      # ==== Returns
      # * 'log_entries'<~Array>:
      #   * <~Pagerduty::LogEntry>:
      #     * 'id'<~String> -
      #     * 'type'<~String> -
      #     * 'created_at'<~String> -
      #     * 'note'<~String> -
      #     * 'agent'<~Pagerduty::User>
      #       * 'id'<~String>
      #       * 'name'<~String>
      #       * 'email'<~String>
      #       * 'time_zone'<~String>
      #       * 'color'<~String>
      #       * 'role'<~String>
      #       * 'avatar_url'<~String>
      #       * 'user_url'<~String>
      #       * 'invitation_sent'<~Boolean>
      #       * 'marketing'<~String>
      #       * 'marketing_opt_out'<~String>
      #       * 'type'<~String>
      #     * 'user'<~Pagerduty::User>
      #       * 'id'<~String>
      #       * 'name'<~String>
      #       * 'email'<~String>
      #       * 'time_zone'<~String>
      #       * 'color'<~String>
      #       * 'role'<~String>
      #       * 'avatar_url'<~String>
      #       * 'user_url'<~String>
      #       * 'invitation_sent'<~Boolean>
      #       * 'marketing'<~String>
      #       * 'marketing_opt_out'<~String>
      #       * 'type'<~String>
      #     * 'channel'<~Hash>
      #       * 'type'
      # * 'limit'<~Integer> -
      # * 'offset'<~Integer> -
      # * 'total'<~Integer> -
      #
      # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/log_entries/user_log_entries]
      def log_entries(options={})
        LogEntries.new(curl({
          uri: "https://#@@subdomain.pagerduty.com/api/v1/users/#{self.id}/log_entries",
          params: options,
            method: 'GET'
        }))
      end

      # Delete the user from your Pagerduty acount
      #
      # ==== Parameters
      #
      # ==== Return
      #
      # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/users/delete]
      def delete
        res = curl({
          uri: "https://#@@subdomain.pagerduty.com/api/v1/users/#{self.id}",
          method: 'DELETE',
            raw_response: true
        })

        res.code == '204' ? "Successfully deleted User #{self.id}" : JSON.parse(response.body)
      end

      # Save updated user attributes
      #
      # ==== Parameters
      #
      # ==== Returns
      # * 'user'<~User>:
      #   * 'time_zone'<~String>
      #   * 'color'<~String>
      #   * 'email'<~String>
      #   * 'avatar_url'<~String>
      #   * 'user_url'<~String>
      #   * 'invitation_sent'<~Boolean>
      #   * 'role'<~String>
      #   * 'name'<~String>
      #   * 'id'<~String>
      #
      # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/users/show]
      def save
        saved_user = User.new(curl({
          uri: "https://#@@subdomain.pagerduty.com/api/v1/users/#{self.id}",
          data: {
            role: self.role,
            name: self.name,
            email: self.email,
            time_zone: self.time_zone
          },
          method: 'PUT'
        })['user'])

        self.role = saved_user.role
        self.name = saved_user.name
        self.email = saved_user.email
        self.time_zone = saved_user.time_zone
        self
      end
    end

  end
end
