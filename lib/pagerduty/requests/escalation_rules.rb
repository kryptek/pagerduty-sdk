class Pagerduty
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

end
