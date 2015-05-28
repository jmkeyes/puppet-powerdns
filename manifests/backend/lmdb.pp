# == Class: powerdns::backend::lmdb

class powerdns::backend::lmdb (
  $options = {},
) {
  $backend_package_name = 'pdns-backend-lmdb'

  package { $backend_package_name:
    ensure => $::powerdns::install::package_ensure,
  } ->

  file { "${::powerdns::config::config_path}/pdns.d/lmdb.conf":
    ensure  => present,
    content => template("${module_name}/backend.conf.erb"),
    owner   => $::powerdns::config::config_owner,
    group   => $::powerdns::config::config_group,
    mode    => $::powerdns::config::config_mode,
  }
}
