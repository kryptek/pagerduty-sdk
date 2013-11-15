class Pagerduty

  # List all incident log entries across the entire account
  #
  # ==== Parameters
  # * options<~Hash>:
  #   * 'time_zone'<~String> -
  #   * 'since'<~String> - The start of the date range over which you want to search. The time element is optional.
  #   * 'until'<~String> - The end of the date range over which you want to search. This should be in the same format as since. The size of the date range must be less than 3 months.
  #   * 'is_overview'<~Boolean> -
  #   * 'until'<~Array> - The end of the date range over which you want to search. This should be in the same format as since. The size of the date range must be less than 3 months.
  #   * 'include'<~Array> - The end of the date range over which you want to search. This should be in the same format as since. The size of the date range must be less than 3 months.
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
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/log_entries/list]
  def get_log_entries(options={})
    LogEntries.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/log_entries",
      params: options,
      method: 'GET'
    }))
  end

  # Get details for a specific incident log entry. This method provides additional information you can use to get at raw event data
  #
  # ==== Parameters
  # * options<~Hash>
  #   * 'time_zone'<~TimeZone> -
  #   * 'include'<~Array> -
  #
  # ==== Returns
  # * 'log_entry'<~LogEntry>
  #  * 'id'<~String>
  #  * 'type'<~String>
  #  * 'created_at'<~String>
  #    * 'agent'<~Pagerduty::User>
  #      * 'id'<~String>
  #      * 'name'<~String>
  #      * 'email'<~String>
  #      * 'time_zone'<~String>
  #      * 'color'<~String>
  #      * 'role'<~String>
  #      * 'avatar_url'<~String>
  #      * 'user_url'<~String>
  #      * 'invitation_sent'<~Boolean>
  #      * 'marketing'<~String>
  #      * 'marketing_opt_out'<~String>
  #      * 'type'<~String>
  #    * 'user'<~Pagerduty::User>
  #      * 'id'<~String>
  #      * 'name'<~String>
  #      * 'email'<~String>
  #      * 'time_zone'<~String>
  #      * 'color'<~String>
  #      * 'role'<~String>
  #      * 'avatar_url'<~String>
  #      * 'user_url'<~String>
  #      * 'invitation_sent'<~Boolean>
  #      * 'marketing'<~String>
  #      * 'marketing_opt_out'<~String>
  #      * 'type'<~String>
  #    * 'channel'<~Hash>
  #      * 'summary'<~String>
  #      * 'type'<~String>
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/log_entries/show]
  def get_log_entry(options={})
    LogEntry.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/log_entries/#{options[:id]}",
      params: options,
      method: 'GET'
    })['log_entry'])
  end


end
