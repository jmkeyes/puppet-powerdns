# == Class: powerdns::backend::gsqlite3

class powerdns::backend::gsqlite3 (
  $database,
  $synchronous,
  $foreign_keys,
) {
  $backend_package_name = $::osfamily ? {
    'Debian' => 'pdns-backend-sqlite3',
    'RedHat' => 'pdns-backend-sqlite'
  }

  package { $backend_package_name:
    ensure => $::powerdns::install::package_ensure,
  }

  $options = {
    'database'            => $database,
    'pragma-synchronous'  => $synchronous,
    'pragma-foreign-keys' => $foreign_keys,
  }

  file { "${::powerdns::config::config_path}/pdns.d/gsqlite3.conf":
    ensure  => present,
    content => template("${module_name}/backend.conf.erb"),
    owner   => $::powerdns::config::config_owner,
    group   => $::powerdns::config::config_group,
    mode    => $::powerdns::config::config_mode,
  }
}
