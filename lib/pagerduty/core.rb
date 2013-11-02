class Pagerduty
  module Core

    ###################################################################################
    # def curl
    #
    # Purpose: Performs a CURL request
    #
    # Params: options<~Hash> - The options Hash to send
    #           uri<~String> - The URI to curl
    #           ssl<~Boolean><Optional> - Whether or not to use SSL
    #           port<~Integer><Optional> - The port number to connect to
    #           params<~Hash><Optional> - The params to send in the curl request
    #           headers<~Hash><Optional> - The headers to send in the curl request
    #           method<~String> - The HTTP method to perform
    #           basic_auth<~Hash><Optional>
    #             user<~String> - Basic auth user
    #             password<~String> - Basic auth password
    #
    # Returns: <String>
    ###################################################################################
    def curl(options)

      curl_request = {
        ssl: true,
        port: 443,
        headers: {
          "Content-Type" => "application/json",
          "Authorization" => "Token token=#{Pagerduty.class_variable_get(:@@token)}",
        },
      }

      options.merge! curl_request

      url = URI.parse(options[:uri])

      if options[:params]
        parameters = options[:params].map { |k,v| "#{k}=#{v}" }.join("&")
        url += "?#{parameters}"
      end

      http = Net::HTTP.new(url.host, 443)
      http.use_ssl = true

      request = case options[:method]
                when 'DELETE'
                  Net::HTTP::Delete.new(url)
                when 'GET'
                  Net::HTTP::Get.new(url)
                when 'POST'
                  Net::HTTP::Post.new(url)
                when 'PUT'
                  Net::HTTP::Put.new(url)
                end

      if options.has_key?(:data)
        request.set_form_data(options[:data])
      end

      if options.has_key?(:basic_auth)
        request.basic_auth options[:basic_auth][:user], options[:basic_auth][:password]
      end

      request.body = options[:body]

      options[:headers].each { |key,val| request.add_field(key,val) }

      response = if options[:method] == 'POST'
                   http.post(url.path,options[:data].to_json,options[:headers])
                 elsif options[:method] == 'PUT'
                   http.put(url.path,options[:data].to_json,options[:headers])
                 else
                   http.request(request)
                 end

      options[:raw_response] == true ? response : JSON.parse(response.body)
    end


    # Check a Hash object for expected keys
    #
    # ==== Parameters
    # * 'keys'<~Array><~Object> - An array of objects expected to be found as keys in the supplied Hash
    # * 'options'<~Hash> - The Hash to perform the check on
    #
    # ==== Returns
    # * Boolean
    #
    def has_requirements?(keys,options)
      (keys - options.keys).empty?
    end

  end
end
