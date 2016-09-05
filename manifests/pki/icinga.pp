# == Class: icinga2::pki::icinga
#
# Takes care about requesting SSL certificates for the Icinga daemon
#
class icinga2::pki::icinga (
  $hostname              = $::fqdn,
  $icinga_ca_host        = undef,
  $icinga_ca_port        = 5665,
  $icinga_api_username   = undef,
  $icinga_api_password   = undef,
  $icinga_ca_path        = undef,
  $icinga_ssl_verify     = true,
) {

  validate_string($icinga_ca_host)
  validate_numeric($icinga_ca_port)
  validate_bool($icinga_ssl_verify)
  validate_string($hostname)
  validate_string($icinga_api_username)
  validate_string($icinga_api_password)
  if $icinga_ssl_verify {
    validate_string($icinga_ca_path)
  }

  $ticket_hash = icinga2_ticket_hash($icinga_ca_host,$icinga_ca_port,$icinga_api_username,$icinga_api_password,$icinga_ca_path,$icinga_ssl_verify,$hostname)

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
    command => "icinga2 pki new-cert --hostname '${hostname}' --key '${key}' --cert '${cert}'",
    creates => $key,
  } ->
  file {
    $key:
      mode => '0600';
    $cert:
  } ->

  exec { 'icinga2 pki get trusted-cert':
    command => "icinga2 pki save-cert --host '${icinga_ca_host}' --port ${icinga_ca_port} --key '${key}' --cert '${cert}' --trustedcert '${trusted_cert}'",
    creates => $trusted_cert,
  } ->
  file { $trusted_cert:
  } ->

  exec { 'icinga2 pki request':
    command => "icinga2 pki request --host '${icinga_ca_host}' --port ${icinga_ca_port} --ca '${ca}' --key '${key}' --cert '${cert}' --trustedcert '${trusted_cert}' --ticket '${ticket_hash}'",
    creates => $ca,
  } ->
  file { $ca:
  }

  # ordering of this class
  Class['::icinga2::config'] -> Class['::icinga2::pki::icinga'] ~> Class['icinga2::service']
}
