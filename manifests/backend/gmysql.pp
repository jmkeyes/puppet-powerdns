# == Class: powerdns::backend::gmysql

class powerdns::backend::gmysql (
  $host,
  $user,
  $password,
  $dbname,
  $port = 3306,
) {
  $backend_package_name = 'pdns-backend-mysql'

  package { $backend_package_name:
    ensure => $::powerdns::install::package_ensure,
  }

  $options = {
    'host'     => $host,
    'user'     => $user,
    'password' => $password,
    'dbname'   => $dbname,
    'port'     => $port,
  }

  file { "${::powerdns::config::config_path}/pdns.d/gmysql.conf":
    ensure  => present,
    content => template("${module_name}/backend.conf.erb"),
    owner   => $::powerdns::config::config_owner,
    group   => $::powerdns::config::config_group,
    mode    => $::powerdns::config::config_mode,
  }
}
