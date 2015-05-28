# == Class: powerdns::install

class powerdns::install {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} from ${caller_module_name}")
  }

  if $::osfamily == 'RedHat' and defined('::epel') {
    warning('This module requires EPEL on RedHat-based distributions.')
  }

  $default_package_name   = $::osfamily ? {
    'Debian' => 'pdns-server',
    'RedHat' => 'pdns',
    default  => undef,
  }

  $package_name   = pick($::powerdns::package_name, $default_package_name)
  $package_ensure = pick($::powerdns::package_ensure, 'installed')

  validate_string($package_name)

  validate_string($package_ensure)
  validate_re($package_ensure, '^(present|latest|nstalled|[._0-9a-zA-Z:-]+)$')

  package { $package_name:
    ensure => $package_ensure,
  }
}
