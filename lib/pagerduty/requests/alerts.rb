class Pagerduty
  module Requests
    module Alerts

      extend Pagerduty::Core

      # List existing alerts for a given time range, optionally filtered by type (SMS, Email, Phone, or Push)
      #
      # ==== Parameters
      # * params<~Hash>
      #   * 'since'<~String>: The start of the date range over which you want to search. The time element is optional.
      #   * 'until'<~String>: The end of the date range over which you want to search. This should be in the same format as since. The size of the date range must be less than 3 months.
      #   * 'filter'<~String>: Returns only the alerts of the said types. Can be one of SMS, Email, Phone, or Push.
      #   * 'time_zone'<~TimeZone>: Time zone in which dates in the result will be rendered. Defaults to account time zone.
      #
      # ==== Returns
      # * 'alerts'<~Array><~Alerts>
      #   * 'id'<~String>
      #   * 'type'<~String>
      #   * 'started_at'<~String>
      #   * 'user'<~Pagerduty::User>
      #     * 'id'<~String>
      #     * 'name'<~String>
      #     * 'email'<~String>
      #     * 'time_zone'<~String>
      #     * 'color'<~String>
      #     * 'avatar_url'<~String>
      #     * 'user_url'<~String>
      #     * 'invitation_sent'<~Boolean>
      #     * 'marketing'<~String>
      #     * 'marketing_opt_out'<~String>
      #     * 'type'<~String>
      #
      # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/alerts/list]
      def self.alerts(options={})

        unless has_requirements? [:since, :until], options
          puts "#> This function requires arguments :since, :until"
          puts "Please see: http://developer.pagerduty.com/documentation/rest/alerts/list"
          return
        end

        Pagerduty::Alerts.new(curl({
          uri: "https://#{Pagerduty.class_variable_get(:@@subdomain)}.pagerduty.com/api/v1/alerts",
          params: options,
            method: 'GET'
        }))
      end


    end
  end
end
