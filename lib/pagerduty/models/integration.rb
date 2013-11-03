class Pagerduty
  class Integration
    include Virtus.model

    attribute :status
    attribute :message
    attribute :incident_key
  end
end
