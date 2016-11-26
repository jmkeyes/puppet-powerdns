# == Class: powerdns::config
#
# Copyright 2016 Joshua M. Keyes <joshua.michael.keyes@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class powerdns::config {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} from ${caller_module_name}")
  }

  $default_config_path = $::osfamily ? {
    'Debian'    => '/etc/powerdns',
    'RedHat'    => '/etc/pdns',
    'ArchLinux' => '/etc/powerdns',
    default     => undef,
  }

  $default_module_path = $::osfamily ? {
    'Debian'    => '/usr/lib/x86_64-linux-gnu/pdns',
    'RedHat'    => '/usr/lib64/pdns',
    'ArchLinux' => '/usr/lib/powerdns',
  }

  $module_path = pick($::powerdns::module_path, $default_module_path)

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

  validate_absolute_path($module_path)

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

  file { $module_path:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
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

  if $module_path {
    powerdns::setting { 'module-dir':
      value => $module_path,
    }
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
