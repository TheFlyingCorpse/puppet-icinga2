require "net/http"
require 'net/https'
require "uri"
require 'json'

module Puppet::Parser::Functions
  newfunction(:icinga2_ticket_hash, :type => :rvalue) do |args|
    raise Puppet::ParseError, 'Must provide exactly seven arguments to icinga2_ticket_hash' if args.length != 7

    if !args[0] or args[0] == ''
      raise Puppet::ParseError, 'first argument (icinga_ca_host) can not be empty for icinga2_ticket_hash'
    end
    if !args[1] or args[1] == ''
      raise Puppet::ParseError, 'second argument (icinga_ca_port) can not be empty for icinga2_ticket_hash'
    end
    if !args[2] or args[2] == ''
      raise Puppet::ParseError, 'third argument (icinga_api_username) can not be empty for icinga2_ticket_hash'
    end
    if !args[3] or args[3] == ''
      raise Puppet::ParseError, 'fourth argument (icinga_api_password) can not be empty for icinga2_ticket_hash'
    end
    if !args[6] or args[6] == ''
      raise Puppet::ParseError, 'seventh argument (hostname) can not be empty for icinga2_ticket_hash'
    end

    icinga_ssl_verify = args[5]

    if $icinga_ssl_verify
      if !args[4] or args[4] == ''
        raise Puppet::ParseError, 'fifth argument (icinga_ca_path) can not be empty for icinga2_ticket_hash as long as ssl_verify is set to true'
      end
    end

    icinga2_ca_host = args[0]
    icinga2_ca_port = args[1]
    icinga2_api_user = args[2]
    icinga2_api_password = args[3]
    icinga2_ca_path = args[4]

    hostname = args[6]

    url = "https://" + icinga2_ca_host + ":" + icinga2_ca_port.to_s +  "/v1/actions/generate-ticket"
    body = {'cn' => hostname}

    http = Net::HTTP.new(icinga2_ca_host,icinga2_ca_port)
    http.read_timeout = 10 # seconds
    http.use_ssl = true

    if $icinga2_ssl_verify
      http.ca_file = $icinga2_ca_path
    else
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    request = Net::HTTP::Post.new(url)
    request.initialize_http_header({"Accept" => "application/json"})
    request.basic_auth(icinga2_api_user,icinga2_api_password)
    request.body = body.to_json
    response = http.request(request)

    if response.code != "200"
      raise(Puppet::ParseError, "Invalid result from Icinga2 CA: " + response.code + " - " + response.msg)
    end

    # Store results in a hash
    results = JSON.parse(response.body)

    # Initialize an empty hash to store the result in
    result = {}
    results.each do |temp_key,temp_result|
      # Expected to be ["results", [{....}]]
      # We trim this to be only the array.
      if temp_key == "results"
        result = temp_result
      end
    end

    # Find if the result was valid or not.
    result.each do |key|
      if key['code'] == 200.0
        return key['ticket']
      else
        raise(Puppet::ParseError, "Invalid result from Icinga2 CA: " + response.code + " - " + response.msg)
      end
    end

  end
end

