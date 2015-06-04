# == Class: powerdns::backend::pipe

class powerdns::backend::pipe (
  $regex,
  $command,
  $timeout = 2000
) {
  $backend_package_name = 'pdns-backend-pipe'

  package { $backend_package_name:
    ensure => $::powerdns::install::package_ensure,
  }

  $options = {
    'regex'   => $regex,
    'command' => $command,
    'timeout' => $timeout,
  }

  file { "${::powerdns::config::config_path}/pdns.d/pipe.conf":
    ensure  => present,
    content => template("${module_name}/backend.conf.erb"),
    owner   => $::powerdns::config::config_owner,
    group   => $::powerdns::config::config_group,
    mode    => $::powerdns::config::config_mode,
  }
}
