
class Pagerduty

  include Pagerduty::Core

  attr_reader :token
  attr_reader :subdomain

  def initialize(options)
    @@token = options[:token]
    @@subdomain = options[:subdomain]
  end


  # Check a Hash object for expected keys
  #
  # ==== Parameters
  # * 'keys'<~Array><~Object> - An array of objects expected to be found as keys in the supplied Hash
  # * 'options'<~Hash> - The Hash to perform the check on
  #
  # ==== Returns
  # * Boolean
  #
  def has_requirements?(keys,options)
    (keys - options.keys).empty?
  end


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
  def alerts(options={})

    unless has_requirements? [:since, :until], options
      puts "#> This function requires arguments :since, :until"
      puts "Please see: http://developer.pagerduty.com/documentation/rest/alerts/list"
      return
    end

    Alerts.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/alerts",
      params: options,
      method: 'GET'
    }))
  end

  # List all the existing escalation policies.
  #
  # ==== Parameters
  # * params<~Hash>
  #   * 'query'<~String> - Filters the result, showing only the escalation policies whose names match the query.
  #   * 'include'<~Array> - An array of extra data to include with the escalation policies.
  #
  # ==== Returns
  # * <~Array>
  #   * <~EscalationPolicy>
  #     * 'id'<~String> - Id of request
  #     * 'name'<~String> - The policy name
  #     * 'escalation_rules'<~Array><~EscalationRule>
  #       * 'escalation_delay_in_minutes'<~Integer> - The escalation delay in minutes
  #       * 'rule_object'<~RuleObject>:
  #         * 'id'<~String> - The id of the rule object
  #         * 'name'<~String> - The name of the rule
  #         * 'type'<~String> - The type of rule
  #         * 'email'<~String> - The email address associated with the rule
  #         * 'time_zone'<~String> - The time zone for the rule
  #         * 'color'<~String> - The display color of the rule
  #     * 'services'<~Array><~EscalationService>:
  #       * 'id'<~String> -
  #       * 'name'<~String> -
  #       * 'service_url'<~String> -
  #       * 'service_key'<~String> -
  #       * 'auto_resolve_timeout'<~String> -
  #       * 'acknowledgement_timeout'<~String> -
  #       * 'created_at'<~String> -
  #       * 'deleted_at'<~String> -
  #       * 'status'<~String> -
  #       * 'last_incident_timestamp'<~String> -
  #       * 'email_incident_creation'<~String> -
  #       * 'incident_counts'<~String> -
  #       * 'email_filter_mode'<~String> -
  #       * 'type'<~String> -
  #     * 'num_loops'<~Integer> - The number of times to loop the incident
  #   * 'limit'<~Integer>
  #   * 'offset'<~Integer>
  #   * 'total'<~Integer>
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/escalation_policies/list]
  def escalation_policies(options={})
    curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/escalation_policies",
      params: { 'query' => options[:query] },
      method: 'GET'
    })['escalation_policies'].inject([]) { |policies, policy|
      policies << EscalationPolicy.new(policy)
    }
  end

  # Creates a new escalation policy. There must be at least one existing
  # escalation rule added to create a new escalation policy
  #
  # ==== Parameters
  # * params<~Hash>
  #   * 'name'<~String> - The desired name for the escalation policy
  #   * 'repeat_enabled'<~Boolean> - Whether or not to allow this policy to repeat its escalation rules after the last rule is finished. Defaults to false.
  #   * 'num_loops'<~Integer> - The number of times to loop over the set of rules in this escalation policy.
  #   * 'escalation_rules'<~Array> - The escalation rules for this policy. The ordering and available parameters are found under the Escalation Rules API. There must be at least one rule to create a new escalation policy.
  #
  # ==== Returns
  # * response<~EscalationPolicy>:
  #   * 'id'<~String> - Id of request
  #   * 'name'<~String> - The policy name
  #   * 'escalation_rules'<~Array><~EscalationRule>
  #     * 'escalation_delay_in_minutes'<~Integer> - The escalation delay in minutes
  #     * 'rule_object'<~RuleObject>:
  #       * 'id'<~String> - The id of the rule object
  #       * 'name'<~String> - The name of the rule
  #       * 'type'<~String> - The type of rule
  #       * 'email'<~String> - The email address associated with the rule
  #       * 'time_zone'<~String> - The time zone for the rule
  #       * 'color'<~String> - The display color of the rule
  #   * 'services'<~Array><~EscalationService>:
  #     * 'id'<~String> -
  #     * 'name'<~String> -
  #     * 'service_url'<~String> -
  #     * 'service_key'<~String> -
  #     * 'auto_resolve_timeout'<~String> -
  #     * 'acknowledgement_timeout'<~String> -
  #     * 'created_at'<~String> -
  #     * 'deleted_at'<~String> -
  #     * 'status'<~String> -
  #     * 'last_incident_timestamp'<~String> -
  #     * 'email_incident_creation'<~String> -
  #     * 'incident_counts'<~String> -
  #     * 'email_filter_mode'<~String> -
  #     * 'type'<~String> -
  #   * 'num_loops'<~Integer> - The number of times to loop the incident
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/escalation_policies/create]
  def create_escalation_policy(options={})

    if options[:escalation_rules]
      options[:escalation_rules] = options[:escalation_rules].map { |rule|
        rule.class == EscalationRule ? rule.hashify : rule
      }
    end

    EscalationPolicy.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/escalation_policies",
      data: options,
      method: 'POST'
    })['escalation_policy'])

  end

  # Get information about an existing escalation policy and its rules
  #
  # ==== Parameters
  #
  # * params<~Hash>
  #   * 'id'<~String>: The id of the escalation policy
  #
  # ==== Returns
  # * response<Array><~Pagerduty::EscalationPolicy>:
  #   * 'id'<~String> - Id of request
  #   * 'name'<~String> - The name of the policy
  #   * 'description'<~String> - Policy description
  #   * 'escalation_rules'<~Array><~RuleObject>:
  #     * 'id'<~String> - The id of the rule object
  #     * 'name'<~String> - The name of the rule
  #     * 'type'<~String> - The type of rule
  #     * 'email'<~String> - The email address associated with the rule
  #     * 'time_zone'<~String> - The time zone for the rule
  #     * 'color'<~String> - The display color of the rule
  #   * 'services'<~Array><~EscalationService>:
  #     * 'id'<~String> -
  #     * 'name'<~String> -
  #     * 'service_url'<~String> -
  #     * 'service_key'<~String> -
  #     * 'auto_resolve_timeout'<~String> -
  #     * 'acknowledgement_timeout'<~String> -
  #     * 'created_at'<~String> -
  #     * 'deleted_at'<~String> -
  #     * 'status'<~String> -
  #     * 'last_incident_timestamp'<~String> -
  #     * 'email_incident_creation'<~String> -
  #     * 'incident_counts'<~String> -
  #     * 'email_filter_mode'<~String> -
  #     * 'type'<~String> -
  #   * 'num_loops'<~Integer> - The number of times to loop the incident
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/escalation_policies/show]
  def get_escalation_policy(options={})
    EscalationPolicy.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/escalation_policies/#{options[:id]}",
      method: 'GET'
    })['escalation_policy'])
  end

  # List all the escalation rules for an existing escalation policy
  #
  # ==== Parameters
  #
  # * params<~Hash>
  #   * 'escalation_policy_id'<~String>: The id of the escalation policy
  #
  # ==== Returns
  # * response<Array><~Pagerduty::EscalationRule>:
  #   * 'id'<~String> - Id of request
  #   * 'escalation_delay_in_minutes'<~Integer> - The escalation delay in minutes
  #   * <~RuleObject>:
  #     * 'id'<~String> - The id of the rule object
  #     * 'name'<~String> - The name of the rule
  #     * 'type'<~String> - The type of rule
  #     * 'email'<~String> - The email address associated with the rule
  #     * 'time_zone'<~String> - The time zone for the rule
  #     * 'color'<~String> - The display color of the rule
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/escalation_policies/escalation_rules/list]
  def escalation_rules(options)
    curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/escalation_policies/#{options[:escalation_policy_id]}/escalation_rules",
      params: { 'query' => options[:query] },
      method: 'GET'
    })['escalation_rules'].inject([]) { |rules, rule|
      rules << EscalationRule.new(rule)
    }
  end

  # Show the escalation rule for an existing escalation policy
  #
  # ==== Parameters
  # * params<~Hash>
  #   * 'escalation_policy_id'<~String>: The id of the escalation policy the rule resides in
  #   * 'rule_id'<~String>: The id of the rule to retrieve
  #
  # ==== Returns
  # * response<~Pagerduty::EscalationRule>:
  #   * 'id'<~String> - Id of request
  #   * 'escalation_delay_in_minutes'<~Integer> - The escalation delay in minutes
  #   * <~RuleObject>:
  #     * 'id'<~String> - The id of the rule object
  #     * 'name'<~String> - The name of the rule
  #     * 'type'<~String> - The type of rule
  #     * 'email'<~String> - The email address associated with the rule
  #     * 'time_zone'<~String> - The time zone for the rule
  #     * 'color'<~String> - The display color of the rule
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/escalation_policies/escalation_rules/show]
  def get_escalation_rule(options={})
    EscalationRule.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/escalation_policies/#{options[:escalation_policy_id]}/escalation_rules/#{options[:rule_id]}",
      method: 'GET'
    })['escalation_rule'])
  end

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

  # List users of your PagerDuty account, optionally filtered by a search query.
  #
  # ==== Parameters
  # * options<~Hash>:
  #   * 'query'<~String> - Filters the result, showing only the users whose names or email addresses match the query
  #   * 'include'<~Array> - Array of additional details to include. This API accepts contact_methods, and notification_rules
  #
  # ==== Returns
  # * <~Users>
  #   * 'users'<~Array>:
  #     * 'user'<~Pagerduty::User>:
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
  # * 'active_account_users'<~Integer>
  # * 'limit'<~Integer>
  # * 'offset'<~Integer>
  # * 'total'<~Integer>
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/users/list]
  def get_users(options={})
    Users.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/users",
      params: options,
      method: 'GET'
    }))
  end

  # Get information about an existing user.
  #
  # ==== Parameters
  # * options<~Hash>:
  #   * 'id'<~String> - The ID of the user to retrieve
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
  def get_user(options={})
    get_users.users.detect { |user| user.id == options[:id] }
  end

  # Create a new user for your account. An invite email will be sent asking the user to choose a password
  #
  # ==== Parameters
  # * options<~Hash>:
  #   * 'role'<~String> - The user's role. This can either be admin or user and defaults to user if not specificed
  #   * 'name'<~String> - The name of the user
  #   * 'email'<~String> - The email of the user. The newly created user will receive an email asking to confirm the subscription
  #   * 'time_zone'<~String> - The time zone the user is in. If not specified, the time zone of the account making the API call will be used
  #   * 'requester_id'<~String> - The user id of the user creating the user. This is only needed if you are using token based authentication
  #
  # ==== Returns
  # * 'user'<~User>
  #   * 'time_zone'<~String>
  #   * 'color'<~String>
  #   * 'email'<~String>
  #   * 'avatar_url'<~String>
  #   * 'user_url'<~String>
  #   * 'invitation_sent'<~String>
  #   * 'role'<~String>
  #   * 'name'<~String>
  #   * 'id'<~String>
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/users/create]
  def create_user(options={})
    User.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/users",
      data: options,
      method: 'POST'
    })['user'])
  end

  # List existing notes for the specified incident.
  #
  # ==== Parameters
  # * options<~Hash>:
  #   * 'id' - The id of the incident to retrieve notes from
  #
  # ==== Returns
  # * <~Notes>:
  #   * 'notes'<~Array>:
  #     * ~<Note>:
  #       * 'id' -
  #       * 'user'<~Pagerduty::User>:
  #         * 'id'<~String>
  #         * 'name'<~String>
  #         * 'email'<~String>
  #         * 'time_zone'<~String>
  #         * 'color'<~String>
  #         * 'role'<~String>
  #         * 'avatar_url'<~String>
  #         * 'user_url'<~String>
  #         * 'invitation_sent'<~Boolean>
  #         * 'marketing'<~String>
  #         * 'marketing_opt_out'<~String>
  #         * 'type'<~String>
  #       * 'content'<~String> -
  #       * 'created_at'<~String> -
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/incidents/notes/list]
  def notes(id)
    Notes.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/incidents/#{id}/notes",
      method: 'GET'
    }))
  end

  # Create an note for a specific incident.
  #
  # ==== Parameters
  # * 'options'<~Hash>
  #   * 'id' - the id of the incident
  #   * 'requester_id'<~String>
  #   * 'note' - <~Hash>
  #      * 'content' - <~ String>
  # ==== Returns
  # * <~Pagerduty::Note::Note>
  #   * 'id'<~String>
  #   * 'user'<~Pagerduty::User>
  #   * 'id'<~String>
  #   * 'content'<~String>
  #   * 'created_at'<~String>
  # {Pagerduty API Reference}[https://developer.pagerduty.com/documentation/rest/incidents/notes/create]
  def create_note(options={})
    Pagerduty::Note.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/incidents/#{options[:id]}/notes",
      data: options.except(:id),
      method: 'POST'
    })['override'])
  end

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

  # Get high level statistics about the number of alerts (SMSes, phone calls and emails) sent for the desired time period, summed daily, weekly or monthly.
  #
  # ==== Parameters
  # * options<~Hash>:
  #   * 'since'<~String> - The start of the date range over which you want to search. The time element is optional.
  #   * 'until'<~String> - The end of the date range over which you want to search. This should be in the same format as since. The size of the date range must be less than 3 months.
  #   * 'rollup'<~String> - Possible values are daily,  weekly or monthly. Specifies the bucket duration for each summation. Defaults to monthly. (Example: A time window of two years (based on since and until) with a rollup of monthly will result in 24 sets of data points being returned (one for each month in the span))
  #
  # ==== Returns
  # * 'alerts'<~Array>
  #   * <~Pagerduty::Reports::Alert>:
  #     * 'number_of_alerts'<~Integer>
  #     * 'number_of_phone_alerts'<~Integer>
  #     * 'number_of_sms_alerts'<~Integer>
  #     * 'number_of_email_alerts'<~Integer>
  #     * 'start'<~String>
  #     * 'end'<~String>
  #   * 'total_number_of_alerts'<~Integer> -
  #   * 'total_number_of_phone_alerts'<~Integer> -
  #   * 'total_number_of_sms_alerts'<~Integer> -
  #   * 'total_number_of_email_alerts'<~Integer> -
  #   * 'total_number_of_billable_alerts'<~Integer> -
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/reports/alerts_per_time]
  def alerts_per_time(options={})
    Pagerduty::Reports::Alerts.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/reports/alerts_per_time",
      params: options,
      method: 'GET'
    }))
  end

  # Get high level statistics about the number of incidents created for the desired time period, summed daily, weekly or monthly
  #
  # ==== Parameters
  # * options<~Hash>:
  #   * 'since'<~String>: The start of the date range over which you want to search. The time element is optional.
  #   * 'until'<~String>: The end of the date range over which you want to search. This should be in the same format as since. The size of the date range must be less than 3 months.
  #   * 'rollup'<~String>: Possible values are daily,  weekly or monthly. Specifies the bucket duration for each summation. Defaults to monthly. (Example: A time window of two years (based on since and until) with a rollup of monthly will result in 24 sets of data points being returned (one for each month in the span))
  #
  # ==== Returns
  # * <~Pagerduty::Reports::Incidents>
  #   * 'incidents'<~Array>
  #     * <~Pagerduty::Reports::Incident>
  #       * 'number_of_incidents'<~Integer> -
  #       * 'start'<~String> -
  #       * 'end'<~String> -
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/reports/incidents_per_time]
  def incidents_per_time(options={})
    Pagerduty::Reports::Incidents.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/reports/incidents_per_time/",
      params: options,
      method: 'GET'
    }))
  end

  # List existing maintenance windows, optionally filtered by service, or whether they are from the past, present or future
  #
  # ==== Parameters
  # * options<~Hash>
  #   * 'query'<~String> - Filters the results, showing only the maintenance windows whose descriptions contain the query
  #   * 'service_ids'<~Array> - An array of service IDs, specifying services whose maintenance windows shall be returned
  #   * 'filter'<~String> - Only return maintenance windows that are of this type. Possible values are past, future, ongoing. If this parameter is omitted, all maintenance windows will be returned
  #
  # ==== Returns
  # * <~Pagerduty::MaintenanceWindows>
  #   * 'maintenance_windows'<~Array>
  #     * <~Pagerduty::MaintenanceWindow>
  #       * 'id'<~String>
  #       * 'sequence_number'<~Integer>
  #       * 'start_time'<~String>
  #       * 'end_time'<~String>
  #       * 'description'<~String>
  #       * 'created_by'<~Pagerduty::User>
  #         * 'id'<~String>
  #         * 'name'<~String>
  #         * 'email'<~String>
  #         * 'time_zone'<~String>
  #         * 'color'<~String>
  #         * 'role'<~String>
  #         * 'avatar_url'<~String>
  #         * 'user_url'<~String>
  #         * 'invitation_sent'<~Boolean>
  #         * 'marketing'<~String>
  #         * 'marketing_opt_out'<~String>
  #         * 'type'<~String>
  #       * 'services'<~Array>
  #         * <~Service>
  #           * 'id'<~String>
  #           * 'name'<~String>
  #           * 'html_url'<~String>
  #           * 'delete_at'<~String>
  #       * 'service_ids'<~Array> - An array of strings of all the service IDs associated with the maintenance window
  # * 'limit'<~Integer>
  # * 'offset'<~Integer>
  # * 'total'<~Integer>
  # * 'query'<~Integer>
  # * 'query'<~String>
  # * 'counts'<~Pagerduty::MaintenanceWindow::Count>
  #   * 'ongoing'<~Integer>
  #   * 'future'<~Integer>
  #   * 'past'<~Integer>
  #   * 'all'<~Integer>
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/maintenance_windows/list]
  def get_maintenance_windows(options={})
    Pagerduty::MaintenanceWindows.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/maintenance_windows",
      params: options,
      method: 'GET'
    }))
  end

  # Get details about an existing maintenance window
  #
  # ==== Parameters
  # * 'options'<~Hash>:
  #   * 'id'<~String> - The id of the maintenance window to retrieve
  #
  # ==== Returns
  # * <~Pagerduty::MaintenanceWindow>
  #   * 'id'<~String>
  #   * 'sequence_number'<~Integer>
  #   * 'start_time'<~String>
  #   * 'end_time'<~String>
  #   * 'description'<~String>
  #   * 'created_by'<~Pagerduty::User>
  #     * 'id'<~String>
  #     * 'name'<~String>
  #     * 'email'<~String>
  #     * 'time_zone'<~String>
  #     * 'color'<~String>
  #     * 'role'<~String>
  #     * 'avatar_url'<~String>
  #     * 'user_url'<~String>
  #     * 'invitation_sent'<~Boolean>
  #     * 'marketing'<~String>
  #     * 'marketing_opt_out'<~String>
  #     * 'type'<~String>
  #   * 'services'<~Array>
  #     * <~Service>
  #       * 'id'<~String>
  #       * 'name'<~String>
  #       * 'html_url'<~String>
  #       * 'delete_at'<~String>
  #   * 'service_ids'<~Array> - An array of strings of all the service IDs associated with the maintenance window
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/maintenance_windows/show]
  def get_maintenance_window(options={})
    Pagerduty::MaintenanceWindow.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/maintenance_windows/#{options[:id]}",
      params: options,
      method: 'GET'
    })['maintenance_window'])
  end

  # Create a new maintenance window for the specified services. No new incidents will be created for a service that is currently in maintenance
  #
  # ==== Parameters
  # * 'options'<~Hash>
  #   * 'requester_id'<~String>
  #   * 'maintenance_window'<~Hash>
  #     * 'start_time'<~String>
  #     * 'end_time'<~String>
  #     * 'description'<~String>
  #     * 'service_ids'<~Array>
  #
  # ==== Returns
  # * <~Pagerduty::MaintenanceWindow>
  #   * 'id'<~String>
  #   * 'sequence_number'<~Integer>
  #   * 'start_time'<~String>
  #   * 'end_time'<~String>
  #   * 'description'<~String>
  #   * 'created_by'<~Pagerduty::User>
  #     * 'id'<~String>
  #     * 'name'<~String>
  #     * 'email'<~String>
  #     * 'time_zone'<~String>
  #     * 'color'<~String>
  #     * 'role'<~String>
  #     * 'avatar_url'<~String>
  #     * 'user_url'<~String>
  #     * 'invitation_sent'<~Boolean>
  #     * 'marketing'<~String>
  #     * 'marketing_opt_out'<~String>
  #     * 'type'<~String>
  #   * 'services'<~Array>
  #     * <~Service>
  #       * 'id'<~String>
  #       * 'name'<~String>
  #       * 'html_url'<~String>
  #       * 'delete_at'<~String>
  #   * 'service_ids'<~Array> - An array of strings of all the service IDs associated with the maintenance window
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/maintenance_windows/create]
  def create_maintenance_window(options={})
    Pagerduty::MaintenanceWindow.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/maintenance_windows",
      data: options,
      method: 'POST'
    })['maintenance_window'])
  end

  # List existing on-call schedules
  #
  # ==== Parameters
  # * options<~Hash>:
  #   * 'query'<~String> - Filters the result, showing only the schedules whose name matches the query
  #   * 'requester_id'<~String> - The user id of the user making the request. This will be used to generate the calendar private urls. This is only needed if you are using token based authentication
  #
  # ==== Returns
  # * <~Pagerduty::Schedules>
  #   * 'schedules'<~Array>
  #     * <~Pagerduty::Schedules::Schedule>
  #       * 'id'<~String>
  #       * 'name'<~String>
  #       * 'time_zone'<~String>
  #       * 'today'<~String>
  #       * 'escalation_policies'<~Array>
  #         * <~EscalationPolicy>
  #           * 'id'<~String>
  #           * 'name'<~String>
  #           * 'description'<~String>
  #           * 'escalation_rules'<~Array>
  #           * 'services'<~Set>
  #           * 'num_loops'<~Integer>
  # * 'limit'<~Integer>
  # * 'offset'<~Integer>
  # * 'total'<~Integer>
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/schedules/list]
  def get_schedules(options={})
    Pagerduty::Schedules.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/schedules",
      params: options,
      method: 'GET'
    }))
  end

  # Show detailed information about a schedule, including entries for each layer and sub-schedule
  #
  # ==== Parameters
  # * options<~Hash>:
  #   * 'since'<~String> - The start of the date range over which you want to return on-call schedule entries and on-call schedule layers
  #   * 'until'<~String> - The end of the date range over which you want to return schedule entries and on-call schedule layers
  #   * 'time_zone'<~TimeZone> - Time zone in which dates in the result will be rendered. Defaults to account time zone
  #
  # ==== Returns
  # * response<~ScheduleInfo>:
  #   * 'id'<~String>
  #   * 'name'<~String>
  #   * 'time_zone'<~String>
  #   * 'today'<~String>
  #   * 'escalation_policies'<~Array>:
  #     * <~EscalationPolicy>:
  #       * 'id'<~String>
  #       * 'name'<~String>
  #       * 'description'<~String>
  #       * 'escalation_rules'<~Array>
  #       * 'services'<~Set>
  #       * 'num_loops'<~Integer>
  #   * 'schedule_layers'<~Array>:
  #     * <~Pagerduty::Schedules::ScheduleLayer>:
  #       * 'name'<~String>
  #       * 'rendered_schedule_entries'<~Array>
  #       * 'id'<~String>
  #       * 'priority'<~Integer>
  #       * 'start'<~String>
  #       * 'end'<~String>
  #       * 'restriction_type'<~String>
  #       * 'rotation_virtual_start'<~String>
  #       * 'rotation_turn_length_seconds'<~Integer>
  #       * 'users'<~Array>
  #         * <~Pagerduty::Schedules::ScheduleLayer::User>:
  #           * 'member_order'<~Integer>
  #           * 'user'<~Pagerduty::User>:
  #             * 'id'<~String>
  #             * 'name'<~String>
  #             * 'email'<~String>
  #             * 'time_zone'<~String>
  #             * 'color'<~String>
  #             * 'role'<~String>
  #             * 'avatar_url'<~String>
  #             * 'user_url'<~String>
  #             * 'invitation_sent'<~Boolean>
  #             * 'marketing'<~String>
  #             * 'marketing_opt_out'<~String>
  #             * 'type'<~String>
  #       * 'restrictions'<~Array>
  #       * 'rendered_coverage_percentage'<~Float>
  #   * 'overrides_schedule'<~Pagerduty::Schedules::Override>:
  #     * 'name'<~String>
  #     * 'rendered_schedule_entries'<~Array>
  #   * 'final_schedule'<~Pagerduty::Schedules::FinalSchedule>:
  #     * 'name'<~String>
  #     * 'rendered_schedule_entries'<~Array>
  #     * 'rendered_coverage_percentage'<~Float>
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/schedules/show]
  def get_schedule(options={})
    Pagerduty::ScheduleInfo.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/schedules/#{options[:id]}",
      params: options,
      method: 'GET'
     })['schedule'])
  end

  # List all the users on-call in a given schedule for a given time range.
  #
  # ==== Parameters
  # * options<~Hash>:
  #   * 'since'<~String> - The start of the date range over which you want to return on-call users
  #   * 'until'<~String> - The end time of the date range over which you want to return on-call users
  #
  # ==== Returns
  # * <~Array>:
  #   * <~Pagerduty::User>
  #     * 'id'<~String>
  #     * 'name'<~String>
  #     * 'email'<~String>
  #     * 'time_zone'<~String>
  #     * 'color'<~String>
  #     * 'role'<~String>
  #     * 'avatar_url'<~String>
  #     * 'user_url'<~String>
  #     * 'invitation_sent'<~Boolean>
  #     * 'marketing'<~String>
  #     * 'marketing_opt_out'<~String>
  #     * 'type'<~String>
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/schedules/users]
  def get_schedule_users(options={})
    Users.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/schedules/#{options[:id]}/users",
      params: options,
      method: 'GET'
    })).users
  end

  # Create an override for a specific user covering the specified time range. If you create an override on top of an existing one, the last created override will have priority.
  #
  # ==== Parameters
  # * 'options'<~Hash>
  #   * 'id' - the id of the schedule to be overridden
  #   * 'override'<~Hash>
  #     * 'start'<~String>
  #     * 'end'<~String>
  #     * 'user_id'<~String>
  #
  # ==== Returns
  # * <~Pagerduty::Schedules::Overrides::Override>
  #   * 'id'<~String>
  #   * 'start'<~String>
  #   * 'end'<~String>
  #   * 'user'<~Pagerduty::User>
  #     * 'id'<~String>
  #     * 'name'<~String>
  #     * 'email'<~String>
  #     * 'color'<~String>
  #
  # {Pagerduty API Reference}[https://developer.pagerduty.com/documentation/rest/schedules/overrides/create]
  def create_schedule_override(options={})
    Pagerduty::Schedules::Overrides::Override.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/schedules/#{options[:id]}/overrides",
      data: options.except(:id),
      method: 'POST'
    })['override'])
  end

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
