#require File.join(File.dirname(__FILE__), '../..', 'icinga2/pbkdf2.rb')
require File.join(File.dirname(__FILE__), '../..', 'icinga2/api_generate-ticket.rb')

module Puppet::Parser::Functions
  newfunction(:icinga2_ticket_hash, :type => :rvalue) do |args|
    raise Puppet::ParseError, 'Must provide exactly six arguments to icinga2_ticket_hash' if args.length != 6

    if !args[0] or args[0] == ''
      raise Puppet::ParseError, 'first argument (icinga_ca_host) can not be empty for icinga2_ticket_hash'
    end
    if !args[1] or args[1] == ''
      raise Puppet::ParseError, 'second argument (icinga2_ca_port) can not be empty for icinga2_ticket_hash'
    end
    if !args[2] or args[2] == ''
      raise Puppet::ParseError, 'third argument (icinga2_api_user) can not be empty for icinga2_ticket_hash'
    end
    if !args[3] or args[3] == ''
      raise Puppet::ParseError, 'fourth argument (icinga2_api_password) can not be empty for icinga2_ticket_hash'
    end
    if !args[4] or args[4] == ''
      raise Puppet::ParseError, 'fifth argument (icinga2_api_ssl_verify) can not be empty for icinga2_ticket_hash'
    end
    if !args[5] or args[5] == ''
      raise Puppet::ParseError, 'sixth argument (cn) can not be empty for icinga2_ticket_hash'
    end

    Icinga2TicketHash.new(
      :icinga2_ca_host => args[0],
      :icinga2_ca_port => args[1],
      :icinga2_api_user => args[2],
      :icinga2_api_password => args[3],
      :icinga2_api_ssl_verify => args[4],
      :cn => args[5],
    )
  end
end
