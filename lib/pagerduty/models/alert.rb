class Alert
  include Virtus.model

  attribute :id
  attribute :type
  attribute :started_at
  attribute :user, Pagerduty::Users::User
  attribute :address

end
