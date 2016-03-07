# == Class: powerdns::backend::gpgsql
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

class powerdns::backend::gpgsql (
  $host,
  $user,
  $password,
  $dbname,
  $port = 5432,
) {
  $backend_package_name = $::osfamily ? {
    'RedHat' => 'pdns-backend-postgresql',
    'Debian' => 'pdns-backend-pgsql',
  }

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

  file { "${::powerdns::config::config_path}/pdns.d/gpgsql.conf":
    ensure  => present,
    content => template("${module_name}/backend.conf.erb"),
    owner   => $::powerdns::config::config_owner,
    group   => $::powerdns::config::config_group,
    mode    => $::powerdns::config::config_mode,
  }
}
