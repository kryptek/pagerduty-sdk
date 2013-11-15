class Pagerduty
  class LogEntry
    include Virtus.model

    attribute :id
    attribute :type
    attribute :created_at
    attribute :note
    attribute :agent, Pagerduty::Users::User
    attribute :user, Pagerduty::Users::User
    attribute :channel
  end
end

class LogEntries
  include Virtus.model

  attribute :log_entries, Array[Pagerduty::LogEntry]
  attribute :limit
  attribute :offset
  attribute :total
end
