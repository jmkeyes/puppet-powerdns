# == Class: powerdns::config

class powerdns::config {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} from ${caller_module_name}")
  }

  $default_config_path  = $::osfamily ? {
    'Debian' => '/etc/powerdns',
    'RedHat' => '/etc/pdns',
    default  => undef,
  }

  $config_purge = pick($::powerdns::config_purge, true)
  $config_owner = pick($::powerdns::config_owner, 'root')
  $config_group = pick($::powerdns::config_group, 'root')
  $config_mode  = pick($::powerdns::config_mode,  '0600')
  $config_path  = pick($::powerdns::config_path,  $default_config_path)

  validate_bool($config_purge)

  validate_string($config_owner)
  validate_string($config_group)
  validate_string($config_mode)

  validate_absolute_path($config_path)

  file { $config_path:
    ensure  => directory,
    owner   => $config_owner,
    group   => $config_group,
    purge   => $config_purge,
    recurse => $config_purge,
    force   => $config_purge,
    mode    => '0755'
  } ->

  file { "${config_path}/pdns.d":
    ensure => directory,
    owner  => $config_owner,
    group  => $config_group,
    mode   => '0755'
  } ->

  concat { "${config_path}/pdns.conf":
    ensure => present,
    path   => "${config_path}/pdns.conf",
    owner  => $config_owner,
    group  => $config_group,
    mode   => $config_mode,
  }

  powerdns::setting { 'daemon':
    value => 'yes',
  }

  powerdns::setting { 'guardian':
    value => 'yes',
  }

  powerdns::setting { 'launch':
    value => '',
  }

  powerdns::setting { 'config-dir':
    value => $config_path,
  }

  powerdns::setting { 'include-dir':
    value => "${config_path}/pdns.d",
  }

  if $::powerdns::master {
    powerdns::setting { 'master':
      value => 'yes',
    }
  }

  if $::powerdns::slave {
    powerdns::setting { 'slave':
      value => 'yes',
    }
  }

  if $::powerdns::setuid and $powerdns::setgid {
    powerdns::setting { 'setuid':
      value => $::powerdns::setuid,
    }

    powerdns::setting { 'setgid':
      value => $::powerdns::setgid,
    }
  }

  if empty($::powerdns::settings) == false {
    $settings = $::powerdns::settings
    $convert  = "(@settings.inject({}){|o,(k,v)|;o[k]={'value'=>v};o})"
    $options  = parsejson(inline_template("<%= ${convert}.to_json %>"))
    create_resources('powerdns::setting', $options)
  }
}
