class Alert
  include Virtus.model

  attribute :id
  attribute :type
  attribute :started_at
  attribute :user, Pagerduty::User
  attribute :address

end
