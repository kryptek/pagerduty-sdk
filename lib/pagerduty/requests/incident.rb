class Pagerduty
  class Incidents
    class Incident
      include Pagerduty::Core

      def initialize(options={})
        super
        @@subdomain = Pagerduty.class_variable_get(:@@subdomain)
      end

      def inspect
        puts "<Pagerduty::#{self.class}"
        self.attributes.each { |attr,val| 
          puts "\t#{attr}=#{val.class == Class ? "BLOCK" : val.inspect}"
        }
        puts ">"

        self.attributes
      end

      def notes
        Notes.new(curl({
          uri: "https://#@@subdomain.pagerduty.com/api/v1/incidents/#{self.id}/notes",
          method: 'GET'
        }))
      end

      def acknowledge
        curl({
          uri: "https://#@@subdomain.pagerduty.com/api/v1/incidents/#{self.id}/acknowledge",
          data: { 'requester_id' => self.assigned_to_user.id },
          method: 'PUT'
        })
      end

      def resolve
        curl({
          uri: "https://#@@subdomain.pagerduty.com/api/v1/incidents/#{self.id}/resolve",
          data: { 'requester_id' => self.assigned_to_user.id },
          method: 'PUT'
        })
      end

      def reassign(options={})
        curl({
          uri: "https://#@@subdomain.pagerduty.com/api/v1/incidents/#{self.id}/resolve",
          data: { 'requester_id' => self.assigned_to_user.id, }.merge(options),
          method: 'PUT'
        })
      end
      
      self.instance_eval do
        %w(triggered open acknowledged resolved).each do |status|
          define_method("#{status}?") { self.status == "#{status}" }
        end
      end


      def log_entries(options={})
        LogEntries.new(curl({
          uri: "https://#@@subdomain.pagerduty.com/api/v1/incidents/#{self.id}/log_entries",
          params: options,
          method: 'GET'
        }))
      end

    end
  end
end
