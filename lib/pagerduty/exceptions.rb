require 'json'

class Pagerduty
    class Exceptions
        class NotFound < StandardError
            def initialize(response)
                method = response.env.method.upcase
                uri = response.env.url.request_uri
                body = JSON.parse(response.body)

                msg = "Error: The requested resource was not found #{method} #{uri} - body: #{body}"

                super(msg)
            end
        end

        class InsufficientPermission < StandardError
            def initialize(response)
                method = response.env.method.upcase
                uri = response.env.url.request_uri
                body = JSON.parse(response.body)
                msg = "Your user access token has insufficient permission to access #{method} #{uri}"
                super(msg)
            end
        end

        class UnauthorizedAccess < StandardError
            def initialize
                msg = "Your authentication credentials are invalid"
                super(msg)
            end
        end

        class InvalidArguments < StandardError
            def initialize(response)
                method = response.env.method.upcase
                uri = response.env.url.request_uri
                body = JSON.parse(response.body)

                msg = "You've provided invalid arguments for the #{method} call to #{uri} - body: #{body}"
                super(msg)
            end
        end

        class RequestThrottled < StandardError
            def initialize
                msg = "Too many requests have been made; the rate limit has been reached"
                super(msg)
            end
        end

        class FeatureUnavailable < StandardError
            def initialize
                msg = "The requested action is not available to this account"
                super(msg)
            end
        end

        class MissingAttributes < StandardError
            def initialize(keys)
                msg = "Missing the following attributes: #{keys}"
                super(msg)
            end
        end

        class InvalidContactMethodType < StandardError
            def initialize(type)
                msg = "Unrecognized Contact Method type: `#{type}'"
            end
        end
    end
end
