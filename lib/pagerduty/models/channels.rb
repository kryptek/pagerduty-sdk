class Nagios
  include Virtus.model

  attribute :type
  attribute :summary
  attribute :host
  attribute :service
  attribute :state
  attribute :details
end

class Api
  include Virtus.model

  attribute :type
  attribute :summary
  attribute :service_key
  attribute :description
  attribute :incident_key
  attribute :details
end

class Email
  include Virtus.model

  attribute :type
  attribute :summary
  attribute :to
  attribute :from
  attribute :subject
  attribute :body
  attribute :content_type
  attribute :raw_url
  attribute :html_url
end

class WebTrigger
  include Virtus.model

  attribute :type
  attribute :summary
  attribute :subject
  attribute :details
end
