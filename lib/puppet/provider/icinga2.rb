begin
  require 'rest-client'
  require 'json'
rescue LoadError => e
  nil
end

class Puppet::Provider::Icinga2 < Puppet::Provider

end
