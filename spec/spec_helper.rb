require 'puppetlabs_spec_helper/module_spec_helper'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

RSpec.configure do |c|
  c.module_path = File.join(fixture_path, 'modules')
  c.manifest_dir = File.join(fixture_path, 'manifests')

  c.default_facts = {
    :kernel          => 'Linux',
    :concat_basedir  => '/var/lib/puppet/concat',
    :puppetversion   => ENV['PUPPET_VERSION'] || Puppet.version
  }
end

SUPPORTED_BACKENDS = [
  'lmdb',
  'gmysql',
  'pipe',
  'gpgsql',
  'gsqlite3',
]
