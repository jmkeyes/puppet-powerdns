# == Class: powerdns::service

class powerdns::service {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} from ${caller_module_name}")
  }

  $service_name   = pick($::powerdns::service_name,   'pdns')
  $service_ensure = pick($::powerdns::service_ensure, 'running')
  $service_enable = pick($::powerdns::service_enable, true)

  validate_string($service_name)

  validate_string($service_ensure)
  validate_re($service_ensure, '^(running|stopped|[._0-9a-zA-Z:-]+)$')

  validate_bool($service_enable)

  service { $service_name:
    ensure => $service_ensure,
    enable => $service_enable,
  }
}
