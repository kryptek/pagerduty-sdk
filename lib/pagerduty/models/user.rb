class Pagerduty
  class User < Pagerduty
    include Virtus.model

    attribute :id
    attribute :name
    attribute :email
    attribute :time_zone
    attribute :color
    attribute :role
    attribute :avatar_url
    attribute :user_url
    attribute :invitation_sent
    attribute :marketing
    attribute :marketing_opt_out
    attribute :type, String, default: 'user'

    #def inspect
    #puts "<Pagerduty::#{self.class}"
    #self.attributes.each { |attr,val| 
    #puts "\t#{attr}=#{val.inspect}"
    #}
    #puts ">"

    #self.attributes
    #end

    def log_entries(options={})
      LogEntries.new(curl({
        uri: "https://#@@subdomain.pagerduty.com/api/v1/users/#{self.id}/log_entries",
        params: options,
          method: 'GET'
      }))
    end

    def delete
      res = curl({
        uri: "https://#@@subdomain.pagerduty.com/api/v1/users/#{self.id}",
        method: 'DELETE',
        raw_response: true
      })

      res.code == '204' ? "Successfully deleted User #{self.id}" : JSON.parse(response.body)
    end

    def save
      saved_user = User.new(curl({
        uri: "https://#@@subdomain.pagerduty.com/api/v1/users/#{self.id}",
        data: {
          role: self.role,
          name: self.name,
          email: self.email,
          time_zone: self.time_zone
        },
        method: 'PUT'
      })['user'])

      self.role = saved_user.role
      self.name = saved_user.name
      self.email = saved_user.email
      self.time_zone = saved_user.time_zone
      self
    end
  end
end

class Users
  include Virtus.model

  attribute :active_account_users
  attribute :limit
  attribute :offset
  attribute :total
  attribute :users, Array[Pagerduty::User]
end
