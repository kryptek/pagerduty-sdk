class Pagerduty
  class Users
    include Virtus.model

    attribute :active_account_users
    attribute :limit
    attribute :offset
    attribute :total
    attribute :users, Array[Pagerduty::Users::User]
  end
end
