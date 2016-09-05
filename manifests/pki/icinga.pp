# == Class: icinga2::pki::icinga
#
# Takes care about requesting SSL certificates for the Icinga daemon
#
class icinga2::pki::icinga (
  $icinga2_ca_host,
  $icinga2_ca_port        = undef,
  $icinga2_api_user       = undef,
  $icinga2_api_password   = undef,
  $icinga2_api_ssl_verify = true,
  $icinga2_ca_file        = undef,
  $hostname              = $::fqdn,
) {

  validate_string($ticket_salt)
  validate_string($icinga_ca_host)

  unless $icinga_ca_port {
    $icinga_ca_port = 5665
  }

  validate_numeric($icinga_ca_port)
  $_icinga_ca_port = " --port '${icinga_ca_port}'"

  #$ticket_id = icinga2_ticket_id($::fqdn, $ticket_salt)
  $ticket_hash = icinga2_ticket_hash($icinga2_ca_host, $icinga2_ca_port, $icinga2_api_user, $icinga2_api_password, $icinga2_api_ssl_verify, $hostname)

  $pki_dir = "${::icinga2::config_dir}/pki"
  $ca = "${pki_dir}/ca.crt"
  $key = "${pki_dir}/${hostname}.key"
  $cert = "${pki_dir}/${hostname}.crt"
  $trusted_cert = "${pki_dir}/trusted-cert.crt"

  Exec {
    user => 'root',
    path => $::path,
  }
  File {
    ensure => file,
    owner  => $::icinga2::config_owner,
    group  => $::icinga2::config_owner,
    mode   => '0644',
  }

  exec { 'icinga2 pki create key':
    command => "icinga2 pki new-cert --cn '${hostname}' --key '${key}' --cert '${cert}'",
    creates => $key,
  } ->
  file {
    $key:
      mode => '0600';
    $cert:
  } ->

  exec { 'icinga2 pki get trusted-cert':
    command => "icinga2 pki save-cert --host '${icinga2_ca_host}'${_icinga2_ca_port} --key '${key}' --cert '${cert}' --trustedcert '${trusted_cert}'",
    creates => $trusted_cert,
  } ->
  file { $trusted_cert:
  } ->

  exec { 'icinga2 pki request':
    command => "icinga2 pki request --host '${icinga2_ca_host}'${_icinga2_ca_port} --ca '${ca}' --key '${key}' --cert '${cert}' --trustedcert '${trusted_cert}' --ticket '${ticket_id}'",
    creates => $ca,
  } ->
  file { $ca:
  }

  # ordering of this class
  Class['::icinga2::config'] -> Class['::icinga2::pki::icinga'] ~> Class['icinga2::service']
}
