class Pagerduty
  class Users
    class ResolvedByUser
      include Virtus.model

      attribute :id
      attribute :name
      attribute :email
      attribute :html_url
    end
  end
end
