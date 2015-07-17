
class Pagerduty

  include Pagerduty::Core

  attr_reader :token
  attr_reader :subdomain

  def initialize(options)
    @@token = options[:token]
    @@subdomain = options[:subdomain]
  end

end
