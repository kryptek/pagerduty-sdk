class Note
  include Virtus.model

  attribute :id
  attribute :user, Pagerduty::Users::User
  attribute :content
  attribute :created_at
end

