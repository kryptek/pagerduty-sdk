require 'pagerduty/exceptions'

class Pagerduty
    class Helpers
        module Common
            def handle_bad_response(response)
                case response.status
                when 400
                    raise Pagerduty::Exceptions::InvalidArguments.new(response)
                when 401
                    raise Pagerduty::Exceptions::UnauthorizedAccess
                when 402
                    raise Pagerduty::Exceptions::FeatureUnavailable
                when 403
                    raise Pagerduty::Exceptions::InsufficientPermission.new(response)
                when 404
                    raise Pagerduty::Exceptions::NotFound.new(response)
                when 429
                    raise Pagerduty::Exceptions::RequestThrottled
                end
            end


            def truncate_keys(keys, hash)
                hash.reject { |k, v| keys.include? k }
            end

            def truncate_nil_keys(hash)
                hash = hash.attributes if hash.respond_to?(:attributes)
                hash.inject({}) do |hash, (k,v)|
                    if v.respond_to?(:attributes)
                        hash[k] = truncate_nil_keys(v.attributes)
                    elsif v.is_a? Hash
                        h = truncate_nil_keys(v)
                        hash[k] = h unless h.empty?
                    elsif v.is_a?(Array)
                        hash[k] = v.collect do |obj|
                            if obj.respond_to?(:attributes)
                                truncate_nil_keys(obj.attributes)
                            else
                                truncate_nil_keys(obj)
                            end
                        end unless v.empty?
                    else
                        hash[k] = v unless v.nil?
                    end
                    hash
                end
            end

            def contact_method_from_string(method)
                contact_method_types = {
                    'email_contact_method' => EmailContactMethod,
                    'phone_contact_method' => PhoneContactMethod,
                    'sms_contact_method' => PhoneContactMethod,
                    'push_notification_contact_method' => PushContactMethod
                }[method]
            end

            def validate_attributes(required_attributes)
                attributes = prepare
                missing_keys = required_attributes.select { |attribute| attributes[attribute] == nil }

                raise Pagerduty::Exceptions::MissingAttributes.new(missing_keys) unless missing_keys.empty?
            end

        end
    end
end
