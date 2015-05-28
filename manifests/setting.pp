# == Define: powerdns::setting

define powerdns::setting (
  $ensure = 'present',
  $value  = undef,
) {
  concat::fragment { $name:
    ensure  => $ensure,
    target  => "${::powerdns::config::config_path}/pdns.conf",
    content => "${name}=${value}",
  }
}
