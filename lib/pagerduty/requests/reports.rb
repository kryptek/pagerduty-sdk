class Pagerduty

  # Get high level statistics about the number of alerts (SMSes, phone calls and emails) sent for the desired time period, summed daily, weekly or monthly.
  #
  # ==== Parameters
  # * options<~Hash>:
  #   * 'since'<~String> - The start of the date range over which you want to search. The time element is optional.
  #   * 'until'<~String> - The end of the date range over which you want to search. This should be in the same format as since. The size of the date range must be less than 3 months.
  #   * 'rollup'<~String> - Possible values are daily,  weekly or monthly. Specifies the bucket duration for each summation. Defaults to monthly. (Example: A time window of two years (based on since and until) with a rollup of monthly will result in 24 sets of data points being returned (one for each month in the span))
  #
  # ==== Returns
  # * 'alerts'<~Array>
  #   * <~Pagerduty::Reports::Alert>:
  #     * 'number_of_alerts'<~Integer>
  #     * 'number_of_phone_alerts'<~Integer>
  #     * 'number_of_sms_alerts'<~Integer>
  #     * 'number_of_email_alerts'<~Integer>
  #     * 'start'<~String>
  #     * 'end'<~String>
  #   * 'total_number_of_alerts'<~Integer> -
  #   * 'total_number_of_phone_alerts'<~Integer> -
  #   * 'total_number_of_sms_alerts'<~Integer> -
  #   * 'total_number_of_email_alerts'<~Integer> -
  #   * 'total_number_of_billable_alerts'<~Integer> -
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/reports/alerts_per_time]
  def alerts_per_time(options={})
    Pagerduty::Reports::Alerts.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/reports/alerts_per_time",
      params: options,
      method: 'GET'
    }))
  end

  # Get high level statistics about the number of incidents created for the desired time period, summed daily, weekly or monthly
  #
  # ==== Parameters
  # * options<~Hash>:
  #   * 'since'<~String>: The start of the date range over which you want to search. The time element is optional.
  #   * 'until'<~String>: The end of the date range over which you want to search. This should be in the same format as since. The size of the date range must be less than 3 months.
  #   * 'rollup'<~String>: Possible values are daily,  weekly or monthly. Specifies the bucket duration for each summation. Defaults to monthly. (Example: A time window of two years (based on since and until) with a rollup of monthly will result in 24 sets of data points being returned (one for each month in the span))
  #
  # ==== Returns
  # * <~Pagerduty::Reports::Incidents>
  #   * 'incidents'<~Array>
  #     * <~Pagerduty::Reports::Incident>
  #       * 'number_of_incidents'<~Integer> -
  #       * 'start'<~String> -
  #       * 'end'<~String> -
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/reports/incidents_per_time]
  def incidents_per_time(options={})
    Pagerduty::Reports::Incidents.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/reports/incidents_per_time/",
      params: options,
      method: 'GET'
    }))
  end


end
