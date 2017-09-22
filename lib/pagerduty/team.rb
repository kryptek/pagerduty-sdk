class Teams
    include Virtus.model(:finalize => false)
    attribute :teams, Array['Team']

    attribute :limit, Integer
    attribute :offset, Integer
    attribute :total, Integer
    attribute :more, Boolean
end

class Team
    include Virtus.model

    attribute :id, String
    attribute :type, String, :default => 'team'
    attribute :summary, String
    attribute :self, String
    attribute :html_url, String
    attribute :name, String
    attribute :description, String
end

Virtus.finalize

