
class Pagerduty

  attr_reader :token
  attr_reader :subdomain

  def initialize(options)
    @@token = options[:token]
    @@subdomain = options[:subdomain]
  end

  ###################################################################################
  # def curl
  #
  # Purpose: Performs a CURL request
  #
  # Params: options<~Hash> - The options Hash to send
  #           uri<~String> - The URI to curl
  #           ssl<~Boolean><Optional> - Whether or not to use SSL
  #           port<~Integer><Optional> - The port number to connect to
  #           params<~Hash><Optional> - The params to send in the curl request
  #           headers<~Hash><Optional> - The headers to send in the curl request
  #           method<~String> - The HTTP method to perform
  #           basic_auth<~Hash><Optional>
  #             user<~String> - Basic auth user
  #             password<~String> - Basic auth password
  #
  # Returns: <String>
  ###################################################################################
  def curl(options)

    curl_request = {
      ssl: true,
      port: 443,
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => "Token token=#@@token",
      },
    }

    options.merge! curl_request

    url = URI.parse(options[:uri])

    if options[:params]
      parameters = options[:params].map { |k,v| "#{k}=#{v}" }.join("&")
      url += "?#{parameters}"
    end

    http = Net::HTTP.new(url.host, 443)
    http.use_ssl = true

    request = case options[:method]
              when 'DELETE'
                Net::HTTP::Delete.new(url)
              when 'GET'
                Net::HTTP::Get.new(url)
              when 'POST'
                Net::HTTP::Post.new(url)
              when 'PUT'
                Net::HTTP::Put.new(url)
              end

    if options.has_key?(:data)
      request.set_form_data(options[:data])
    end

    if options.has_key?(:basic_auth)
      request.basic_auth options[:basic_auth][:user], options[:basic_auth][:password]
    end

    request.body = options[:body]

    options[:headers].each { |key,val| request.add_field(key,val) }

    if options[:method] == 'POST'
      http.post(url.path,options[:data].to_json,options[:headers])
    elsif options[:method] == 'PUT'
      http.put(url.path,options[:data].to_json,options[:headers])
    else
      http.request(request)
    end
  end

  def has_requirements?(keys,options)
    (keys - options.keys).empty?
  end

  def alerts(options={})

    unless has_requirements? [:since, :until], options
      puts "#> This function requires arguments :since, :until"
      puts "Please see: http://developer.pagerduty.com/documentation/rest/alerts/list"
      return
    end

    JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/alerts",
      params: options,
      method: 'GET'
    }).body)['alerts'].inject([]) { |alerts, alert|
      alerts << Alert.new(alert)
    }

  end

  def escalation_policies(options={})
    JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/escalation_policies",
      params: { 'query' => options[:query] },
      method: 'GET'
    }).body)['escalation_policies'].inject([]) { |policies, policy|
      policies << EscalationPolicy.new(policy)
    }
  end

  def create_escalation_policy(options={})

    if options[:escalation_rules]
      options[:escalation_rules] = options[:escalation_rules].map { |rule| 
        rule.class == EscalationRule ? rule.hashify : rule
      }
    end

    EscalationPolicy.new(JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/escalation_policies",
      data: options,
      method: 'POST'
    }).body)['escalation_policy'])

  end

  def get_escalation_policy(options={})
    EscalationPolicy.new(JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/escalation_policies/#{options[:id]}",
      method: 'GET'
    }).body)['escalation_policy'])
  end

  def escalation_rules(options)
    JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/escalation_policies/#{options[:escalation_policy_id]}/escalation_rules",
      params: { 'query' => options[:query] },
      method: 'GET'
    }).body)['escalation_rules'].inject([]) { |rules, rule|
      rules << EscalationRule.new(rule)
    }
  end

  def get_escalation_rule(options={})
    JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/escalation_policies/#{options[:escalation_policy_id]}/escalation_rules/#{options[:rule_id]}",
      method: 'GET'
    }).body)
  end

  # Retrieve all incidents
  #
  # ==== Parameters
  #
  # * params<~Hash>
  #   * 'since'<~String>: The start of the date range over which to search
  #   * 'until'<~String>: The end of the date range over which to search
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
    JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/incidents",
      params: {
        since: options[:since] || (Time.now - 1.day).strftime("%Y-%m-%d"),
        :until => options[:until] || (Time.now + 1.day).strftime("%Y-%m-%d"),
      },
      method: 'GET'
    }).body)['incidents'].inject([]) { |incidents, incident|
      incidents << Incident.new(incident)
    }
  end

  def get_incident(options={})
    incidents.detect { |incident| incident.id == options[:id] } || 'No results'
  end

  def get_incident_counts(options={})
    JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/incidents/count",
      params: options,
      method: 'GET',
    }).body)
  end

  def get_users(options={})
    Users.new(JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/users",
      params: { query: options[:query] },
      method: 'GET'
    }).body))
  end

  def get_user(options={})
    get_users.users.detect { |user| user.id == options[:id] }
  end

  def create_user(options={})
    User.new(JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/users",
      data: options,
      method: 'POST'
    }).body)['user'])
  end

  def notes(id)
    JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/incidents/#{id}/notes",
      method: 'GET'
    }).body)['notes'].inject([]) { |notes, note|
      notes << Note.new(note)
    }
  end

  def get_log_entries(options={})
    LogEntries.new(JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/log_entries",
      params: options,
      method: 'GET'
    }).body))
  end

  def get_log_entry(options={})
    LogEntry.new(JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/log_entries/#{options[:id]}",
      params: options,
      method: 'GET'
    }).body)['log_entry'])
  end

  def alerts_per_time(options={})
    Pagerduty::Reports::Alerts.new(JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/reports/alerts_per_time",
      params: options,
      method: 'GET'
    }).body))
  end

  def incidents_per_time(options={})
    Pagerduty::Reports::Incidents.new(JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/reports/incidents_per_time/",
      params: options,
      method: 'GET'
    }).body))
  end

  def get_maintenance_windows(options={})
    Pagerduty::MaintenanceWindows.new(JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/maintenance_windows",
      params: options,
      method: 'GET'
    }).body))
  end

  def get_maintenance_window(options={})
    Pagerduty::MaintenanceWindow.new(JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/maintenance_windows/#{options[:id]}",
      params: options,
      method: 'GET'
    }).body)['maintenance_window'])
  end

  def create_maintenance_window(options={})
    Pagerduty::MaintenanceWindow.new(JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/maintenance_windows",
      data: options,
      method: 'POST'
    }).body)['maintenance_window'])
  end

  def get_schedules(options={})
    Pagerduty::Schedules.new(JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/schedules",
      params: options,
      method: 'GET'
    }).body))
  end

  def get_schedule(options={})
    Pagerduty::ScheduleInfo.new(JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/schedules/#{options[:id]}",
      params: options,
      method: 'GET'
     }).body)['schedule'])
  end

  def get_schedule_users(options={})
    JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/schedules/#{options[:id]}/users",
      params: options,
      method: 'GET'
    }).body)['users'].inject([]) { |users, user|
      users << Pagerduty::User.new(user)
    }
  end

  def get_services(options={})
    Pagerduty::Services.new(JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/services",
      params: options,
      method: 'GET'
    }).body))
  end

  def get_service(options={})
    Pagerduty::Services::Objects::Service.new(JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/services/#{options[:id]}",
      params: options,
      method: 'GET'
    }).body)['service'])
  end

  def create_service(options={})
    Pagerduty::Services::Objects::Service.new(JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/services",
      data: { service: options },
      method: 'POST'
    }).body)['service'])
  end

end
