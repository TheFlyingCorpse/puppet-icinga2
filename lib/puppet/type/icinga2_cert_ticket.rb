Puppet::Type.newtype(:icinga2_generate_ticket) do
  @doc = "Generates an Icinga2 ticket"

  ensurable

  newparam(:host, :namevar => true) do
    desc "NodeName of the host to generate a ticket for"
  end
  newparam(:icinga2_api_username) do
    desc "Username with rights to generate-ticket"
  end
  newparam(:icinga2_api_password) do
    desc "Password for the user specified"
  end
  newparam(:icinga2_ca_host) do
    desc "Host to generate the ticket from, usually the Icinga2 CA"
  end
  newparam(:icinga2_ca_port) do
    desc "Port for the Icinga2 ca, defaults to 5665"
  end
  newparam(:icinga2_api_uri) do
    desc "Uri for the Icinga2 Api action, defaults to 'v1/actions/generate-ticket'"
  end
end
