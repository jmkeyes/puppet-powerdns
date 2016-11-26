# == Class: powerdns::backend::lmdb
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

class powerdns::backend::lmdb (
  $package_name = undef,
  $datapath,
) {
  $default_package_name = 'pdns-backend-lmdb'
  $default_package_name = $::osfamily ? {
    'Debian'    => 'pdns-backend-lmdb',
    'RedHat'    => 'pdns-backend-lmdb',
    'ArchLinux' => 'none',
    default     => undef,
  }

  $backend_package_name = pick($package_name, $default_package_name)

  if ($backend_package_name != 'none') {
    package { $backend_package_name:
      ensure => $::powerdns::install::package_ensure,
    }
  }

  $options = {
    'datapath' => $datapath
  }

  file { "${::powerdns::config::config_path}/pdns.d/lmdb.conf":
    ensure  => present,
    content => template("${module_name}/backend.conf.erb"),
    owner   => $::powerdns::config::config_owner,
    group   => $::powerdns::config::config_group,
    mode    => $::powerdns::config::config_mode,
  }
}
