class Pagerduty

  # Your monitoring tools should send PagerDuty a trigger event to report a new or ongoing problem. When PagerDuty receives a trigger event, it will either open a new incident, or add a new trigger log entry to an existing incident, depending on the provided incident_key
  #
  # ==== Parameters
  # * options<~Hash>:
  #   * 'service_key'<~String> - The GUID of one of your "Generic API" services. This is the "service key" listed on a Generic API's service detail page
  #   * 'description'<~String> - A short description of the problem that led to this trigger. This field (or a truncated version) will be used when generating phone calls, SMS messages and alert emails. It will also appear on the incidents tables in the PagerDuty UI. The maximum length is 1024 characters
  #   * 'incident_key'<~String> - Identifies the incident to which this trigger event should be applied. If there's no open (i.e. unresolved) incident with this key, a new one will be created. If there's already an open incident with a matching key, this event will be appended to that incident's log. The event key provides an easy way to "de-dup" problem reports. If this field isn't provided, PagerDuty will automatically open a new incident with a unique key
  #   * 'details'<~Hash> - Any data you'd like included in the incident log
  #
  # ==== Returns
  # * <~Pagerduty::Integration>
  #   * 'status'<~String>
  #   * 'incident_key'<~String>
  #   * 'message'<~String>
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/integration/events/trigger]
  def trigger(options={})
    Pagerduty::Integration.new(curl({
      uri: 'https://events.pagerduty.com/generic/2010-04-15/create_event.json',
      data: options.merge({event_type: 'trigger'}),
      method: 'POST'
    }))
  end

  # Acknowledge events cause the referenced incident to enter the acknowledged state
  #
  # ==== Parameters
  # * options<~Hash>:
  #   * 'service_key'<~String> - The GUID of one of your "Generic API" services. This is the "service key" listed on a Generic API's service detail page
  #   * 'description'<~String> - Text that will appear in the incident's log associated with this event.
  #   * 'incident_key'<~String> - Identifies the incident to acknowledge. This should be the incident_key you received back when the incident was first opened by a trigger event. Acknowledge events referencing resolved or nonexistent incidents will be discarded
  #   * 'details'<~Hash> - Any data you'd like included in the incident log
  #
  # ==== Returns
  # * <~Pagerduty::Integration>
  #   * 'status'<~String>
  #   * 'incident_key'<~String>
  #   * 'message'<~String>
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/integration/events/trigger]
  def acknowledge(options={})
    Pagerduty::Integration.new(curl({
      uri: 'https://events.pagerduty.com/generic/2010-04-15/create_event.json',
      data: options.merge({event_type: 'acknowledge'}),
      method: 'POST'
    }))
  end

  # Resolve events cause the referenced incident to enter the resolved state
  #
  # ==== Parameters
  # * options<~Hash>:
  #   * 'service_key'<~String> - The GUID of one of your "Generic API" services. This is the "service key" listed on a Generic API's service detail page
  #   * 'description'<~String> - Text that will appear in the incident's log associated with this event.
  #   * 'incident_key'<~String> - Identifies the incident to acknowledge. This should be the incident_key you received back when the incident was first opened by a trigger event. Acknowledge events referencing resolved or nonexistent incidents will be discarded
  #   * 'details'<~Hash> - Any data you'd like included in the incident log
  #
  # ==== Returns
  # * <~Pagerduty::Integration>
  #   * 'status'<~String>
  #   * 'incident_key'<~String>
  #   * 'message'<~String>
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/integration/events/trigger]
  def resolve(options={})
    Pagerduty::Integration.new(curl({
      uri: 'https://events.pagerduty.com/generic/2010-04-15/create_event.json',
      data: options.merge({event_type: 'resolve'}),
      method: 'POST'
    }))
  end
end
