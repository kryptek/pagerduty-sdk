class Pagerduty
  class MaintenanceWindow < Pagerduty
    include Virtus.model

    attribute :id
    attribute :sequence_number
    attribute :start_time
    attribute :end_time
    attribute :description
    attribute :created_by, Pagerduty::User
    attribute :services, Array[Service]
    attribute :service_ids

    class Count
      include Virtus.model

      attribute :ongoing
      attribute :future
      attribute :past
      attribute :all
    end

    def initialize(attributes)
      self.attributes = attributes
      self.service_ids = self.services.map(&:id)
    end

    def save(options={})
      Pagerduty::MaintenanceWindow.new(JSON.parse(curl({
        uri: "https://#@@subdomain.pagerduty.com/api/v1/maintenance_windows/#{self.id}",
        data: {
          start_time: self.start_time,
          end_time: self.end_time,
          description: self.description,
          service_ids: self.service_ids
        },
        method: 'PUT'
      }).body)['maintenance_window'])
    end

    def delete
      res = curl({
        uri: "https://#@@subdomain.pagerduty.com/api/v1/maintenance_windows/#{self.id}",
        method: 'DELETE'
      })

      res['code'] == '204' ? "Successfully deleted Maintenance Window #{self.id}" : res

    end

  end
end

class Pagerduty
  class MaintenanceWindows
    include Virtus.model

    attribute :maintenance_windows, Array[Pagerduty::MaintenanceWindow]
    attribute :limit
    attribute :offset
    attribute :total
    attribute :query
    attribute :counts, Pagerduty::MaintenanceWindow::Count

  end
end
