class RuleObject
  include Virtus.model

  attribute :id
  attribute :name
  attribute :type
  attribute :email
  attribute :time_zone
  attribute :color

end

class EscalationService
  include Virtus.model

  attribute :id
  attribute :name
  attribute :service_url
  attribute :service_key
  attribute :auto_resolve_timeout
  attribute :acknowledgement_timeout
  attribute :created_at
  attribute :deleted_at
  attribute :status
  attribute :last_incident_timestamp
  attribute :email_incident_creation
  attribute :incident_counts
  attribute :email_filter_mode
  attribute :type
end

class EscalationRule < Pagerduty
  include Virtus.model

  attribute :id
  attribute :escalation_delay_in_minutes
  attribute :rule_object, RuleObject

  def hashify
    self.attributes.inject({}) { |attrs, (k,v)|
      v.class == RuleObject ?  attrs[k] = v.to_hash : attrs[k] = v
      attrs
    }
  end

  def parent_policy
    escalation_policies.detect { |policy| 
      policy.escalation_rules.detect { |p| p.id == self.id }
    }
  end

  def delete
    res = curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/escalation_policies/#{parent_policy.id}/escalation_rules/#{self.id}",
      method: 'DELETE',
      raw_response: true
    })

    res.code == '200' ? 'Successfully deleted' : JSON.parse(res.body)
  end

  def save
    self.attributes = curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/escalation_policies/#{parent_policy.id}/escalation_rules/#{self.id}",
      data: self.hashify,
      method: 'PUT'
    })['escalation_rule']
  end

end

class EscalationPolicy < Pagerduty
  include Virtus.model

  attribute :id
  attribute :name
  attribute :description
  attribute :escalation_rules, Array[EscalationRule]
  attribute :services, Set[EscalationService]
  attribute :num_loops

  def save
    self.escalation_rules = self.escalation_rules.map { |rule|
      rule.class == EscalationRule ? rule.hashify : rule
    }

    saved_policy = EscalationPolicy.new(JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/escalation_policies/#{self.id}",
      data: { escalation_policy: self.attributes },
      method: 'PUT'
    }).body)['escalation_policy'])

    self.attributes = saved_policy.attributes
  end

  def delete
    res = curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/escalation_policies/#{self.id}",
      method: 'DELETE',
      raw_response: true
    })

    res.code == '204' ? 'Successfully deleted policy' : JSON.parse(res.body)

  end

  def add_escalation_rule(options={})
    EscalationRule.new(JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/escalation_policies/#{self.id}/escalation_rules",
      data: { escalation_rule: options.hashify },
      method: 'POST'
    }).body)['escalation_rule'])
  end

  def update_escalation_rules(options={})
    options[:rules] = options[:rules].map { |rule| rule.class == EscalationRule ? rule.hashify : rule }

    JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/escalation_policies/#{self.id}/escalation_rules",
      data: { escalation_rules: options[:rules] },
      method: 'PUT'
    }).body)
  end

  def refresh
    self.attributes = get_escalation_policy(id: self.id)
  end

end
