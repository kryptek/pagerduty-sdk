class Pagerduty

  # List existing maintenance windows, optionally filtered by service, or whether they are from the past, present or future
  #
  # ==== Parameters
  # * options<~Hash>
  #   * 'query'<~String> - Filters the results, showing only the maintenance windows whose descriptions contain the query
  #   * 'service_ids'<~Array> - An array of service IDs, specifying services whose maintenance windows shall be returned
  #   * 'filter'<~String> - Only return maintenance windows that are of this type. Possible values are past, future, ongoing. If this parameter is omitted, all maintenance windows will be returned
  #
  # ==== Returns
  # * <~Pagerduty::MaintenanceWindows>
  #   * 'maintenance_windows'<~Array>
  #     * <~Pagerduty::MaintenanceWindow>
  #       * 'id'<~String>
  #       * 'sequence_number'<~Integer>
  #       * 'start_time'<~String>
  #       * 'end_time'<~String>
  #       * 'description'<~String>
  #       * 'created_by'<~Pagerduty::User>
  #         * 'id'<~String>
  #         * 'name'<~String>
  #         * 'email'<~String>
  #         * 'time_zone'<~String>
  #         * 'color'<~String>
  #         * 'role'<~String>
  #         * 'avatar_url'<~String>
  #         * 'user_url'<~String>
  #         * 'invitation_sent'<~Boolean>
  #         * 'marketing'<~String>
  #         * 'marketing_opt_out'<~String>
  #         * 'type'<~String>
  #       * 'services'<~Array>
  #         * <~Service>
  #           * 'id'<~String>
  #           * 'name'<~String>
  #           * 'html_url'<~String>
  #           * 'delete_at'<~String>
  #       * 'service_ids'<~Array> - An array of strings of all the service IDs associated with the maintenance window
  # * 'limit'<~Integer>
  # * 'offset'<~Integer>
  # * 'total'<~Integer>
  # * 'query'<~Integer>
  # * 'query'<~String>
  # * 'counts'<~Pagerduty::MaintenanceWindow::Count>
  #   * 'ongoing'<~Integer>
  #   * 'future'<~Integer>
  #   * 'past'<~Integer>
  #   * 'all'<~Integer>
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/maintenance_windows/list]
  def get_maintenance_windows(options={})
    Pagerduty::MaintenanceWindows.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/maintenance_windows",
      params: options,
      method: 'GET'
    }))
  end

  # Get details about an existing maintenance window
  #
  # ==== Parameters
  # * 'options'<~Hash>:
  #   * 'id'<~String> - The id of the maintenance window to retrieve
  #
  # ==== Returns
  # * <~Pagerduty::MaintenanceWindow>
  #   * 'id'<~String>
  #   * 'sequence_number'<~Integer>
  #   * 'start_time'<~String>
  #   * 'end_time'<~String>
  #   * 'description'<~String>
  #   * 'created_by'<~Pagerduty::User>
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
  #   * 'services'<~Array>
  #     * <~Service>
  #       * 'id'<~String>
  #       * 'name'<~String>
  #       * 'html_url'<~String>
  #       * 'delete_at'<~String>
  #   * 'service_ids'<~Array> - An array of strings of all the service IDs associated with the maintenance window
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/maintenance_windows/show]
  def get_maintenance_window(options={})
    Pagerduty::MaintenanceWindow.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/maintenance_windows/#{options[:id]}",
      params: options,
      method: 'GET'
    })['maintenance_window'])
  end

  # Create a new maintenance window for the specified services. No new incidents will be created for a service that is currently in maintenance
  #
  # ==== Parameters
  # * 'options'<~Hash>
  #   * 'requester_id'<~String>
  #   * 'maintenance_window'<~Hash>
  #     * 'start_time'<~String>
  #     * 'end_time'<~String>
  #     * 'description'<~String>
  #     * 'service_ids'<~Array>
  #
  # ==== Returns
  # * <~Pagerduty::MaintenanceWindow>
  #   * 'id'<~String>
  #   * 'sequence_number'<~Integer>
  #   * 'start_time'<~String>
  #   * 'end_time'<~String>
  #   * 'description'<~String>
  #   * 'created_by'<~Pagerduty::User>
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
  #   * 'services'<~Array>
  #     * <~Service>
  #       * 'id'<~String>
  #       * 'name'<~String>
  #       * 'html_url'<~String>
  #       * 'delete_at'<~String>
  #   * 'service_ids'<~Array> - An array of strings of all the service IDs associated with the maintenance window
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/maintenance_windows/create]
  def create_maintenance_window(options={})
    Pagerduty::MaintenanceWindow.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/maintenance_windows",
      data: options,
      method: 'POST'
    })['maintenance_window'])
  end

end
