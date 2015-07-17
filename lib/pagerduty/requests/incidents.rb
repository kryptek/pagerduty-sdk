class Pagerduty

  # Retrieve all incidents
  #
  # ==== Parameters
  # * params<~Hash>
  #   * 'since'<~String>: The start of the date range over which you want to search. The time element is optional.
  #   * 'until'<~String>: The end of the date range over which you want to search. This should be in the same format as since. The size of the date range must be less than 3 months.
  #   * 'date_range'<~String>: When set to 'all' the 'since' and 'until' params are ignored. Use this to get all incidents since the account was created
  #   * 'fields'<~String>: Used to restrict the properties of each incident returned to a set of pre-defined fields. If omitted, returned incidents have all fields present. See below for a list of possible fields.
  #   * 'status'<~String>: Returns only the incidents currently in the passed status(es). Valid status options are triggered, acknowledged, and resolved. More status codes may be introduced in the future.
  #   * 'incident_key'<~String>: Returns only the incidents with the passed de-duplication key. See the PagerDuty Integration API docs for further details.
  #   * 'service'<~String>: Returns only the incidents associated with the passed service(s). This expects one or more service IDs. Separate multiple IDs by commas.
  #   * 'assigned_to_user'<~String>: Returns only the incidents currently assigned to the passed user(s). This expects one or more user IDs. Please see below for more info on how to find your users' IDs. When using the assigned_to_user filter, you will only receive incidents with statuses of triggered or acknowledged. This is because resolved incidents are not assigned to any user.
  #   * 'time_zone'<~String>: Time zone in which dates in the result will be rendered. Defaults to UTC.
  #   * 'sort_by'<~String>: Used to specify both the field you wish to sort the results on, as well as the direction  See API doc for examples.
  #
  # ==== Returns
  # * response<~Array>:
  #   * <~Pagerduty::Incident>:
  #     * 'id'<~String> - Id of request
  #     * 'incident_number'<~String>:
  #     * 'created_on'<~String>:
  #     * 'status'<~String>:
  #     * 'html_url'<~String>:
  #     * 'incident_key'<~String>:
  #     * 'service'<~Pagerduty::Service>
  #       * 'id'<~String>:
  #       * 'name'<~String>:
  #       * 'html_url'<~String>:
  #       * 'deleted_at'<~String>:
  #     * 'escalation_policy'<~String>:
  #     * 'assigned_to_user'<~String>:
  #     * 'trigger_summary_data'<~String>:
  #     * 'trigger_details_html_url'<~String>:
  #     * 'trigger_type'<~String>:
  #     * 'last_status_change_on'<~String>:
  #     * 'last_status_change_by'<~Pagerduty::User>:
  #       * 'id'<~String>:
  #       * 'name'<~String>:
  #       * 'email'<~String>:
  #       * 'html_url'<~String>:
  #     * 'number_of_escalations'<~Integer>:
  #     * 'resolved_by_user'<~Pagerduty::ResolvedByUser>:
  #       * 'id'<~String>:
  #       * 'name'<~String>:
  #       * 'email'<~String>:
  #       * 'html_url'<~String>:
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/incidents/list]
  def incidents(options={})
    Pagerduty::Incidents.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/incidents",
      params: {
        since: options[:since] || (Time.now - 1.day).strftime("%Y-%m-%d"),
        :until => options[:until] || (Time.now + 1.day).strftime("%Y-%m-%d"),
      },
      method: 'GET'
    }))
  end

  # Use this query if you are simply looking for the count of incidents that match a given query. This should be used if you don't need access to the actual incident details.
  #
  # ==== Parameters
  # * options<~Hash>:
  #   * 'since'<~String> - The start of the date range over which you want to search. The time element is optional.
  #   * 'until'<~String> - The end of the date range over which you want to search. This should be in the same format as since. The size of the date range must be less than 3 months.
  #   * 'date_range'<~String> - When set to all, the since and until parameters and defaults are ignored. Use this to get all counts since the account was created.
  #   * 'status'<~String> - Only counts the incidents currently in the passed status(es). Valid status options are triggered, acknowledged, and resolved. More status codes may be introduced in the future.
  #   * 'incident_key'<~String> - Only counts the incidents with the passed de-duplication key. See the PagerDuty Integration API docs for further details.
  #   * 'service'<~String> - Only counts the incidents associated with the passed service(s). This is expecting one or more service IDs. Separate multiple ids by a comma.
  #   * 'assigned_to_user'<~String> - Only counts the incidents currently assigned to the passed user(s). This is expecting one or more user IDs. Note: When using the assigned_to_user filter, you will only count incidents with statuses of triggered or acknowledged. This is because resolved incidents are not assigned to any user. Separate multiple ids by a comma.
  #
  # ==== Returns
  # <~Hash>
  #   * 'total'<~Integer>
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/incidents/count]
  def get_incident_counts(options={})
    curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/incidents/count",
      params: options,
      method: 'GET',
    })
  end


  # Show detailed information about an incident. Accepts either an incident id, or an incident number
  #
  # ==== Parameters
  # options<~Hash>
  #   * 'id'<~String> - The incident id or incident number to look for
  #
  # ==== Returns
  # * <~Pagerduty::Incident>:
  #   * 'id'<~String> - Id of request
  #   * 'incident_number'<~String>:
  #   * 'created_on'<~String>:
  #   * 'status'<~String>:
  #   * 'html_url'<~String>:
  #   * 'incident_key'<~String>:
  #   * 'service'<~Pagerduty::Service>
  #     * 'id'<~String>:
  #     * 'name'<~String>:
  #     * 'html_url'<~String>:
  #     * 'deleted_at'<~String>:
  #   * 'escalation_policy'<~String>:
  #   * 'assigned_to_user'<~String>:
  #   * 'trigger_summary_data'<~String>:
  #   * 'trigger_details_html_url'<~String>:
  #   * 'trigger_type'<~String>:
  #   * 'last_status_change_on'<~String>:
  #   * 'last_status_change_by'<~Pagerduty::User>:
  #     * 'id'<~String>:
  #     * 'name'<~String>:
  #     * 'email'<~String>:
  #     * 'html_url'<~String>:
  #   * 'number_of_escalations'<~Integer>:
  #   * 'resolved_by_user'<~Pagerduty::ResolvedByUser>:
  #     * 'id'<~String>:
  #     * 'name'<~String>:
  #     * 'email'<~String>:
  #     * 'html_url'<~String>:
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/incidents/show]
  def get_incident(options={})
    incidents.incidents.detect { |incident|
      incident.id == options[:id] || incident.incident_number == options[:id]
    } || 'No results'
  end

end
