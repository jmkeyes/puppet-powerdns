# == Class: powerdns::backend::gpgsql

class powerdns::backend::gpgsql (
  $options = {},
) {
  $backend_package_name = $::osfamily ? {
    'RedHat' => 'pdns-backend-postgresql',
    'Debian' => 'pdns-backend-pgsql',
  }

  package { $backend_package_name:
    ensure => $::powerdns::install::package_ensure,
  }

  file { "${::powerdns::config::config_path}/pdns.d/gpgsql.conf":
    ensure  => present,
    content => template("${module_name}/backend.conf.erb"),
    owner   => $::powerdns::config::config_owner,
    group   => $::powerdns::config::config_group,
    mode    => $::powerdns::config::config_mode,
  }
}
