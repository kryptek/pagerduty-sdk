class Pagerduty
  class Services
    class Objects
      include Virtus.model

      class IncidentCount < Pagerduty::Services::Objects
        attribute :triggered
        attribute :acknowledged
        attribute :resolved
        attribute :total
      end

      class EmailFilter < Pagerduty::Services::Objects
        attribute :subject_mode
        attribute :subject_regex
        attribute :body_mode
        attribute :body_regex
        attribute :from_email_mode
        attribute :from_email_regex
        attribute :id
      end

      class Service < Pagerduty::Services::Objects
        attribute :id
        attribute :name
        attribute :description
        attribute :service_url
        attribute :service_key
        attribute :auto_resolve_timeout
        attribute :acknowledgement_timeout
        attribute :created_at
        attribute :status
        attribute :last_incident_timestamp
        attribute :email_incident_creation
        attribute :incident_counts
        attribute :email_filter_mode
        attribute :type
        attribute :escalation_policy, 'EscalationPolicy'
        attribute :email_filters, Pagerduty::Services::Objects::EmailFilter
        attribute :severity_filter
      end

    end
  end
end

class Pagerduty
  class Services
    include Virtus.model

    attribute :services, Array[Pagerduty::Services::Objects::Service]
  end
end
