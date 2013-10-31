class Incident < Pagerduty
  include Virtus.model

  attribute :id
  attribute :incident_number
  attribute :created_on
  attribute :status
  attribute :html_url
  attribute :incident_key
  attribute :service, Service
  attribute :escalation_policy, EscalationPolicy
  attribute :assigned_to_user, AssignedUser
  attribute :trigger_summary_data, TriggerSummaryData
  attribute :trigger_details_html_url
  attribute :trigger_type
  attribute :last_status_change_on
  attribute :last_status_change_by, LastStatusChangeBy
  attribute :number_of_escalations
  attribute :resolved_by_user, ResolvedByUser

  def inspect
    puts "<Pagerduty::#{self.class}"
    self.attributes.each { |attr,val| 
      puts "\t#{attr}=#{val.class == Class ? "BLOCK" : val.inspect}"
    }
    puts ">"

    self.attributes
  end

  def notes
    super(self.id)
  end

  def acknowledge
    JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/incidents/#{self.id}/acknowledge",
      params: { 'requester_id' => self.assigned_to_user.id },
      method: 'PUT'
    }).body)
  end

  def resolve
    JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/incidents/#{self.id}/resolve",
      params: { 'requester_id' => self.assigned_to_user.id },
      method: 'PUT'
    }).body)
  end

  def reassign(options={})

    unless has_requirements?([:escalation_level, :assigned_to_user], options)
      puts "#> This function requires arguments :escalation_level, :assigned_to_user"
      puts "Please see: http://developer.pagerduty.com/documentation/rest/incidents/reassign"
      return
    end

    JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/incidents/#{self.id}/resolve",
      params: { 'requester_id' => self.assigned_to_user.id, }.merge(options),
      method: 'PUT'
    }).body)
  end

  def log_entries(options={})
    LogEntries.new(JSON.parse(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/incidents/#{self.id}/log_entries",
      params: options,
      method: 'GET'
    }).body))
  end
end

