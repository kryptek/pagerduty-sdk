class Pagerduty
  # List existing on-call schedules
  #
  # ==== Parameters
  # * options<~Hash>:
  #   * 'query'<~String> - Filters the result, showing only the schedules whose name matches the query
  #   * 'requester_id'<~String> - The user id of the user making the request. This will be used to generate the calendar private urls. This is only needed if you are using token based authentication
  #
  # ==== Returns
  # * <~Pagerduty::Schedules>
  #   * 'schedules'<~Array>
  #     * <~Pagerduty::Schedules::Schedule>
  #       * 'id'<~String>
  #       * 'name'<~String>
  #       * 'time_zone'<~String>
  #       * 'today'<~String>
  #       * 'escalation_policies'<~Array>
  #         * <~EscalationPolicy>
  #           * 'id'<~String>
  #           * 'name'<~String>
  #           * 'description'<~String>
  #           * 'escalation_rules'<~Array>
  #           * 'services'<~Set>
  #           * 'num_loops'<~Integer>
  # * 'limit'<~Integer>
  # * 'offset'<~Integer>
  # * 'total'<~Integer>
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/schedules/list]
  def get_schedules(options={})
    Pagerduty::Schedules.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/schedules",
      params: options,
      method: 'GET'
    }))
  end

  # Show detailed information about a schedule, including entries for each layer and sub-schedule
  #
  # ==== Parameters
  # * options<~Hash>:
  #   * 'since'<~String> - The start of the date range over which you want to return on-call schedule entries and on-call schedule layers
  #   * 'until'<~String> - The end of the date range over which you want to return schedule entries and on-call schedule layers
  #   * 'time_zone'<~TimeZone> - Time zone in which dates in the result will be rendered. Defaults to account time zone
  #
  # ==== Returns
  # * response<~ScheduleInfo>:
  #   * 'id'<~String>
  #   * 'name'<~String>
  #   * 'time_zone'<~String>
  #   * 'today'<~String>
  #   * 'escalation_policies'<~Array>:
  #     * <~EscalationPolicy>:
  #       * 'id'<~String>
  #       * 'name'<~String>
  #       * 'description'<~String>
  #       * 'escalation_rules'<~Array>
  #       * 'services'<~Set>
  #       * 'num_loops'<~Integer>
  #   * 'schedule_layers'<~Array>:
  #     * <~Pagerduty::Schedules::ScheduleLayer>:
  #       * 'name'<~String>
  #       * 'rendered_schedule_entries'<~Array>
  #       * 'id'<~String>
  #       * 'priority'<~Integer>
  #       * 'start'<~String>
  #       * 'end'<~String>
  #       * 'restriction_type'<~String>
  #       * 'rotation_virtual_start'<~String>
  #       * 'rotation_turn_length_seconds'<~Integer>
  #       * 'users'<~Array>
  #         * <~Pagerduty::Schedules::ScheduleLayer::User>:
  #           * 'member_order'<~Integer>
  #           * 'user'<~Pagerduty::User>:
  #             * 'id'<~String>
  #             * 'name'<~String>
  #             * 'email'<~String>
  #             * 'time_zone'<~String>
  #             * 'color'<~String>
  #             * 'role'<~String>
  #             * 'avatar_url'<~String>
  #             * 'user_url'<~String>
  #             * 'invitation_sent'<~Boolean>
  #             * 'marketing'<~String>
  #             * 'marketing_opt_out'<~String>
  #             * 'type'<~String>
  #       * 'restrictions'<~Array>
  #       * 'rendered_coverage_percentage'<~Float>
  #   * 'overrides_schedule'<~Pagerduty::Schedules::Override>:
  #     * 'name'<~String>
  #     * 'rendered_schedule_entries'<~Array>
  #   * 'final_schedule'<~Pagerduty::Schedules::FinalSchedule>:
  #     * 'name'<~String>
  #     * 'rendered_schedule_entries'<~Array>
  #     * 'rendered_coverage_percentage'<~Float>
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/schedules/show]
  def get_schedule(options={})
    Pagerduty::ScheduleInfo.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/schedules/#{options[:id]}",
      params: options,
      method: 'GET'
     })['schedule'])
  end

  # List all the users on-call in a given schedule for a given time range.
  #
  # ==== Parameters
  # * options<~Hash>:
  #   * 'since'<~String> - The start of the date range over which you want to return on-call users
  #   * 'until'<~String> - The end time of the date range over which you want to return on-call users
  #
  # ==== Returns
  # * <~Array>:
  #   * <~Pagerduty::User>
  #     * 'id'<~String>
  #     * 'name'<~String>
  #     * 'email'<~String>
  #     * 'time_zone'<~String>
  #     * 'color'<~String>
  #     * 'role'<~String>
  #     * 'avatar_url'<~String>
  #     * 'user_url'<~String>
  #     * 'invitation_sent'<~Boolean>
  #     * 'marketing'<~String>
  #     * 'marketing_opt_out'<~String>
  #     * 'type'<~String>
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/schedules/users]
  def get_schedule_users(options={})
    Users.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/schedules/#{options[:id]}/users",
      params: options,
      method: 'GET'
    })).users
  end

end
