class Pagerduty
  # List existing notes for the specified incident.
  #
  # ==== Parameters
  # * options<~Hash>:
  #   * 'id' - The id of the incident to retrieve notes from
  #
  # ==== Returns
  # * <~Notes>:
  #   * 'notes'<~Array>:
  #     * ~<Note>:
  #       * 'id' - 
  #       * 'user'<~Pagerduty::User>:
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
  #       * 'content'<~String> - 
  #       * 'created_at'<~String> - 
  #
  # {Pagerduty API Reference}[http://developer.pagerduty.com/documentation/rest/incidents/notes/list]
  def notes(id)
    Notes.new(curl({
      uri: "https://#@@subdomain.pagerduty.com/api/v1/incidents/#{id}/notes",
      method: 'GET'
    }))
  end

end
