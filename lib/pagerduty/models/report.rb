class Pagerduty
  class Reports
    class Alert
      include Virtus.model

      attribute :number_of_alerts
      attribute :number_of_phone_alerts
      attribute :number_of_sms_alerts
      attribute :number_of_email_alerts
      attribute :start
      attribute :end
    end
  end
end

class Pagerduty
  class Reports
    class Incident
      include Virtus.model

      attribute :start
      attribute :number_of_incidents
      attribute :end
    end
  end
end

class Pagerduty
  class Reports
    class Incidents
      include Virtus.model

      attribute :incidents, Array[Pagerduty::Reports::Incident]
    end
  end
end

class Pagerduty
  class Reports
    class Alerts

      include Virtus.model

      attribute :alerts, Array[Pagerduty::Reports::Alert]
      attribute :total_number_of_alerts
      attribute :total_number_of_phone_alerts
      attribute :total_number_of_sms_alerts
      attribute :total_number_of_email_alerts
      attribute :total_number_of_billable_alerts
    end
  end

end

