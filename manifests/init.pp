# == Class: powerdns
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

class powerdns (
  $settings        = {},
  $master          = undef,
  $slave           = undef,
  $setuid          = undef,
  $setgid          = undef,
  $package_name    = undef,
  $package_ensure  = undef,
  $service_name    = undef,
  $service_ensure  = undef,
  $service_enable  = undef,
  $config_owner    = undef,
  $config_group    = undef,
  $config_mode     = undef,
  $config_path     = undef,
  $config_purge    = undef,
) {
  # Fail fast if we're not using a new Puppet version.
  if versioncmp($::puppetversion, '3.7.0') < 0 {
    fail('This module requires the use of Puppet v3.7.0 or newer.')
  }

  validate_hash($settings)

  if $master and $slave {
    validate_bool($master)
    validate_bool($slave)
  }

  if $setuid and $setgid {
    validate_string($setuid)
    validate_string($setgid)
  }

  contain '::powerdns::install'
  contain '::powerdns::config'
  contain '::powerdns::service'

  Class['::powerdns::install'] ->
  Class['::powerdns::config'] ~>
  Class['::powerdns::service']

}
