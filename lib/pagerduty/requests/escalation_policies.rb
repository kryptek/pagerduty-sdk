class Pagerduty
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

end
