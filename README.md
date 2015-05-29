# Yet Another Puppet ::powerdns Module

[![Puppet Forge](http://img.shields.io/puppetforge/v/jmkeyes/powerdns.svg)](https://forge.puppetlabs.com/jmkeyes/powerdns)
[![Build Status](https://travis-ci.org/jmkeyes/puppet-powerdns.svg?branch=master)](https://travis-ci.org/jmkeyes/puppet-powerdns)

#### Table of Contents

 1. [Overview](#overview)
 2. [Description](#description)
 3. [Todo](#todo)

## Overview

This is yet another Puppet module to manage a PowerDNS DNS server. It currently targets the
latest stable release of Puppet, and should support both RedHat and Debian family distributions.

*Beware that this module will recursively purge your distribution's default PowerDNS configuration.*

## Description

To use this module, use either an include-like or resource-like declaration:

    # An include-like declaration for Hiera integration.
    include ::powerdns

    # A resource-like declaration for manual overrides.
    class { '::powerdns': }

This module is intended to work with Puppet 4.x.

## Configuration

All configuration can be handled either through Hiera or by arguments to the `powerdns` class.

The `backends` parameter indicates to PowerDNS which backends to load; it will configure the
PowerDNS `launch` parameter in `pdns.conf`. In order to configure a given backend, you will
also need to include any selected backends as specified in the examples below.

## Supported PowerDNS Backends

  - MySQL (`gmysql`)
  - PostgreSQL (`gpgsql`)
  - SQLite3 (`gsqlite3`)
  - LMDB (`lmdb`)
  - Pipe (`pipe`)

### PowerDNS with MySQL (using manifests)

    # Install PowerDNS:
    class { '::powerdns':
      backends => [ 'gmysql' ]
    }

    # Load the MySQL backend:
    class { '::powerdns::backend::gmysql':
      options => {
        'gmysql-host'     => '127.0.0.1',
        'gmysql-dbname'   => 'powerdns',
        'gmysql-user'     => 'username',
        'gmysql-password' => 'password',
        'gmysql-port'     => '3306',
      }
    }

### PowerDNS with PostgreSQL (using Hiera)

    # In Hiera configuration:
    classes:
      - 'powerdns'
      - 'powerdns::backend::gpgsql'

    powerdns::backends:
      - 'gpgsql'

    powerdns::backend::gpgsql::options:
      'gpgsql-host':     '127.0.0.1'
      'gpgsql-dbname':   'powerdns'
      'gpgsql-user':     'username'
      'gpgsql-password': 'password'
      'gpgsql-port':     '3306'

## Todo

  * Ensure PowerDNS works with SELinux on distributions that use it.
  * Consider supporting a chrooted installation.
  * Extend support to other distributions.
