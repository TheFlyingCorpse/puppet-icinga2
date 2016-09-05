require "net/http"
require 'net/https'
require "uri"
require 'json'

module Puppet
  module Icinga2
    module Api
      module GenerateTicket
        def self.GetTicket(icinga2_ca_host,icinga2_ca_port,icinga2_api_username,icinga2_api_password,icinga2_api_ssl_verify,cn)
          # override with options
          raise ArgumentError, "icinga2_ca_host not set" if @icinga2_ca_host.nil?
          raise ArgumentError, "icinga2_ca_port not set" if @icinga2_ca_port.nil?
          raise ArgumentError, "icinga2_api_ssl_verify not set" if @icinga2_api_verify.nil?
          raise ArgumentError, "icinga2_api_username not set" if @icinga2_api_username.nil?
          raise ArgumentError, "icinga2_api_password not set" if @icinga2_api_password.nil?
          raise ArgumentError, "icinga2_api_username not set" if @icinga2_api_username.nil?
        end

      end
    end
  end
end

