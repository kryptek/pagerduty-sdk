class Pagerduty
  class Incidents
    include Virtus.model

    attribute :incidents, Array[Pagerduty::Incidents::Incident]

    self.instance_eval do
      %w(triggered open acknowledged resolved).each do |status|
        define_method(status) {
          self.incidents.select { |incident|
            incident.status == "#{status}"
          }
        }
      end
    end

  end
end
