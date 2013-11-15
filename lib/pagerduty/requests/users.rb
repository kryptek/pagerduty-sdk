class Pagerduty

  # List users of your PagerDuty account, optionally filtered by a search query.
  #
  # ==== Parameters
  # * options<~Hash>:
  #   * 'query'<~String> - Filters the result, showing only the users whose names or email addresses match the query
  #   * 'include'<~Array> - Array of additional details to include. This API accepts contact_methods, and notification_rules
  #
  # ==== Returns
  # * <~Users>
  #   * 'users'<~Array>:
  #     * 'user'<~Pagerduty::User>:
  #       * 'id'<~String>
  #       * 'name'<~String>
  #       * 'email'<~String>
  #       * 'time_zone'<~String>
  #       * 'color'<~String>
  #       * 'role'<~String>
  #       * 'avatar_url'<~String>
  #       * 'user_url'<~String>
  #       * 'invitation_sent'<~Boolean>
  #       * 'marketing'<~String>
  #       * 'marketing_opt_out'<~String>
  #       * 'type'<~String>
  # * 'active_account_users'<~Integer>
  # * 'limit'<~Integer>
  # * 'offset'<~Integer>
  # * 'total'<~Integer>
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/users/list]
  def get_users(options={})
    Users.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/users",
      params: options,
      method: 'GET'
    }))
  end

  # Get information about an existing user.
  #
  # ==== Parameters
  # * options<~Hash>:
  #   * 'id'<~String> - The ID of the user to retrieve
  #
  # ==== Returns
  # * 'user'<~User>:
  #   * 'time_zone'<~String>
  #   * 'color'<~String>
  #   * 'email'<~String>
  #   * 'avatar_url'<~String>
  #   * 'user_url'<~String>
  #   * 'invitation_sent'<~Boolean>
  #   * 'role'<~String>
  #   * 'name'<~String>
  #   * 'id'<~String>
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/users/show]
  def get_user(options={})
    get_users.users.detect { |user| user.id == options[:id] }
  end

  # Create a new user for your account. An invite email will be sent asking the user to choose a password
  #
  # ==== Parameters
  # * options<~Hash>:
  #   * 'role'<~String> - The user's role. This can either be admin or user and defaults to user if not specificed
  #   * 'name'<~String> - The name of the user
  #   * 'email'<~String> - The email of the user. The newly created user will receive an email asking to confirm the subscription
  #   * 'time_zone'<~String> - The time zone the user is in. If not specified, the time zone of the account making the API call will be used
  #   * 'requester_id'<~String> - The user id of the user creating the user. This is only needed if you are using token based authentication
  #
  # ==== Returns
  # * 'user'<~User>
  #   * 'time_zone'<~String>
  #   * 'color'<~String>
  #   * 'email'<~String>
  #   * 'avatar_url'<~String>
  #   * 'user_url'<~String>
  #   * 'invitation_sent'<~String>
  #   * 'role'<~String>
  #   * 'name'<~String>
  #   * 'id'<~String>
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/users/create]
  def create_user(options={})
    User.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/users",
      data: options,
      method: 'POST'
    })['user'])
  end


end
