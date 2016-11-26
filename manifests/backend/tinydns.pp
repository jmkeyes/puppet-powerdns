# == Class: powerdns::backend::tinydns
#
# Copyright 2016 Mark McKinstry <mmckinst@nexcess.net>
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

class powerdns::backend::tinydns (
  $dbfile,
  $tai_adjust = '11',
  $notify_on_startup = 'no',
  $ignore_bogus_records = 'no',
  $locations = 'yes',
) {
  if $::powerdns::install::manage_backend_packages {
    $backend_package_name = 'pdns-backend-tinydns'

    package { $backend_package_name:
      ensure => $::powerdns::install::package_ensure,
    }
  }

  $options = {
    'dbfile'               => $dbfile,
    'tai-adjust'           => $tai_adjust,
    'notify-on-startup'    => $notify_on_startup,
    'ignore-bogus-records' => $ignore_bogus_records,
    'locations'            => $locations,
  }

  file { "${::powerdns::config::config_path}/pdns.d/tinydns.conf":
    ensure  => present,
    content => template("${module_name}/backend.conf.erb"),
    owner   => $::powerdns::config::config_owner,
    group   => $::powerdns::config::config_group,
    mode    => $::powerdns::config::config_mode,
  }
}
