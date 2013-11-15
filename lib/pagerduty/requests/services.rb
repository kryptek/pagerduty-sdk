class Pagerduty

  # List existing services
  #
  # ==== Parameters
  # * options<~Hash>:
  #   * 'include'<~Array> - Include extra information in the response. Possible values are escalation_policy (for inline Escalation Policy) and email_filters (for inline Email Filters)
  #   * 'time_zone'<~TimeZone> - Time zone in which dates in the result will be rendered. Defaults to account default time zone
  #
  # ==== Returns
  # * services<~Array>:
  #   * <~Pagerduty::Services::Objects::Service>:
  #     * 'id'<~String>
  #     * 'name'<~String>
  #     * 'description'<~String>
  #     * 'service_url'<~String>
  #     * 'service_key'<~String>
  #     * 'auto_resolve_timeout'<~Integer>
  #     * 'acknowledgement_timeout'<~Integer>
  #     * 'created_at'<~String>
  #     * 'status'<~String>
  #     * 'last_incident_timestamp'<~String>
  #     * 'email_incident_creation'<~String>
  #     * 'incident_counts'<~Hash>
  #       * 'triggered'<~Integer>
  #       * 'acknowledged'<~Integer>
  #       * 'resolved'<~Integer>
  #       * 'total'<~Integer>
  #     * 'email_filter_mode'<~String>
  #     * 'type'<~String>
  #     * 'escalation_policy'<~String>
  #     * 'email_filters'<~String> - An object containing inline Email Filters. Only present if email_filters is passed as an argument. Note that only generic_email services have Email Filters
  #     * 'severity_filter'<~String> - Specifies what severity levels will create a new open incident
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/services/list]
  def get_services(options={})
    Pagerduty::Services.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/services",
      params: options,
      method: 'GET'
    }))
  end

  # Get details about an existing service
  #
  # ==== Parameters
  # * options<~Hash>:
  #   * 'include'<~Array> - Include extra information in the response. Possible values are escalation_policy (for inline Escalation Policy) and email_filters (for inline Email Filters)
  #
  # ==== Returns
  # * <~Pagerduty::Services::Objects::Service>:
  #   * 'id'<~String>
  #   * 'name'<~String>
  #   * 'description'<~String>
  #   * 'service_url'<~String>
  #   * 'service_key'<~String>
  #   * 'auto_resolve_timeout'<~Integer>
  #   * 'acknowledgement_timeout'<~Integer>
  #   * 'created_at'<~String>
  #   * 'status'<~String>
  #   * 'last_incident_timestamp'<~String>
  #   * 'email_incident_creation'<~String>
  #   * 'incident_counts'<~Hash>
  #     * 'triggered'<~Integer>
  #     * 'acknowledged'<~Integer>
  #     * 'resolved'<~Integer>
  #     * 'total'<~Integer>
  #   * 'email_filter_mode'<~String>
  #   * 'type'<~String>
  #   * 'escalation_policy'<~String>
  #   * 'email_filters'<~String> - An object containing inline Email Filters. Only present if email_filters is passed as an argument. Note that only generic_email services have Email Filters
  #   * 'severity_filter'<~String> - Specifies what severity levels will create a new open incident
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/services/show]
  def get_service(options={})
    Pagerduty::Services::Objects::Service.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/services/#{options[:id]}",
      params: options,
      method: 'GET'
    })['service'])
  end

  # Create a new service
  #
  # ==== Parameters
  # * options<~Hash>:
  #   * 'name'<~String> - The name of the service
  #   * 'escalation_policy_id'<~String> - The id of the escalation policy to be used by this service
  #   * 'type'<~String> - The type of service to create. Can be one of generic_email, generic_events_api, keynote, nagios, pingdom, server_density or sql_monitor
  #   * 'description'<~String> - A description for your service. 1024 character maximum
  #   * 'acknowledgement_timeout'<~Integer> - The duration in seconds before an incidents acknowledged in this service become triggered again. (Defaults to 30 minutes)
  #   * 'auto_resolve_timeout'<~Integer> - The duration in seconds before a triggered incident auto-resolves itself. (Defaults to 4 hours)
  #   * 'severity_filter'<~String> - Specifies what severity levels will create a new open incident
  #
  # ==== Returns
  # * <~Pagerduty::Services::Objects::Service>:
  #   * 'id'<~String>
  #   * 'name'<~String>
  #   * 'description'<~String>
  #   * 'service_url'<~String>
  #   * 'service_key'<~String>
  #   * 'auto_resolve_timeout'<~Integer>
  #   * 'acknowledgement_timeout'<~Integer>
  #   * 'created_at'<~String>
  #   * 'status'<~String>
  #   * 'last_incident_timestamp'<~String>
  #   * 'email_incident_creation'<~String>
  #   * 'incident_counts'<~Hash>
  #     * 'triggered'<~Integer>
  #     * 'acknowledged'<~Integer>
  #     * 'resolved'<~Integer>
  #     * 'total'<~Integer>
  #   * 'email_filter_mode'<~String>
  #   * 'type'<~String>
  #   * 'escalation_policy'<~String>
  #   * 'email_filters'<~String> - An object containing inline Email Filters. Only present if email_filters is passed as an argument. Note that only generic_email services have Email Filters
  #   * 'severity_filter'<~String> - Specifies what severity levels will create a new open incident
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/services/create]
  def create_service(options={})
    Pagerduty::Services::Objects::Service.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/services",
      data: { service: options },
      method: 'POST'
    })['service'])
  end

end
