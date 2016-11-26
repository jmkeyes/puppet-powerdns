describe 'powerdns::config' do
  shared_examples 'a Linux distribution' do |osfamily, config_directory, module_directory|
    context "on #{osfamily}" do
      let (:facts) do
        {
          :operatingsystem => osfamily,
          :osfamily        => osfamily,
        }
      end

      let (:include_directory) { config_directory + '/pdns.d' }
      let (:config_file) { config_directory + '/pdns.conf' }

      describe "with default parameters" do
        let (:pre_condition) { 'include ::powerdns' }

        let (:default_params) do
          {
            'ensure' => 'directory',
            'owner'  => 'root',
            'group'  => 'root',
            'mode'   => '0755',
          }
        end

        it { should compile.with_all_deps }
        it { should create_class('powerdns::config') }

        it { should contain_file(config_directory).with(default_params) }
        it { should contain_file(module_directory).with(default_params) }
        it { should contain_file(include_directory).with(default_params) }

        it do
          should contain_concat(config_file).with({
            'path'   => config_file,
            'ensure' => 'present',
            'owner'  => 'root',
            'group'  => 'root',
            'mode'   => '0600',
          })
        end

        it { should contain_powerdns__setting('daemon').with_value('yes') }
        it { should contain_concat__fragment('daemon').with_content("daemon=yes\n") }

        it { should contain_powerdns__setting('guardian').with_value('yes') }
        it { should contain_concat__fragment('guardian').with_content("guardian=yes\n") }

        it { should contain_powerdns__setting('config-dir').with_value(config_directory) }
        it { should contain_concat__fragment('config-dir').with_content("config-dir=#{config_directory}\n") }

        it { should contain_powerdns__setting('module-dir').with_value(module_directory) }
        it { should contain_concat__fragment('module-dir').with_content("module-dir=#{module_directory}\n") }

        it { should contain_powerdns__setting('include-dir').with_value(include_directory) }
        it { should contain_concat__fragment('include-dir').with_content("include-dir=#{include_directory}\n") }

        it { should contain_powerdns__setting('launch').with_value('') }
        it { should contain_concat__fragment('launch').with_content("launch=\n") }

        [ 'master', 'slave' ].each do |mode|
          it { should_not contain_powerdns__setting(mode) }
          it { should_not contain_concat__fragment(mode) }
        end

        it { should_not contain_powerdns__setting('setuid') }
        it { should_not contain_concat__fragment('setuid') }

        it { should_not contain_powerdns__setting('setgid') }
        it { should_not contain_concat__fragment('setgid') }
      end

      [ 'master', 'slave' ].each do |mode|
        describe "with #{mode} => true" do
          let (:pre_condition) { "class { '::powerdns': #{mode} => true }" }
          it { should contain_powerdns__setting(mode).with_value('yes') }
          it { should contain_concat__fragment(mode).with_content("#{mode}=yes\n") }
        end
      end

      describe "with setuid => 'pdns' and setgid => 'pdns'" do
        let (:pre_condition) { "class { '::powerdns': setuid => 'pdns', setgid => 'pdns' }" }
        it { should contain_powerdns__setting('setuid').with_value('pdns') }
        it { should contain_concat__fragment('setuid').with_content("setuid=pdns\n") }
        it { should contain_powerdns__setting('setgid').with_value('pdns') }
        it { should contain_concat__fragment('setgid').with_content("setgid=pdns\n") }
      end

      describe "with settings => { 'cache-ttl' => 20 }" do
        let (:pre_condition) { "class { '::powerdns': settings => { 'cache-ttl' => 20 } }" }
        it { should contain_powerdns__setting('cache-ttl').with_value(20) }
        it { should contain_concat__fragment('cache-ttl').with_content("cache-ttl=20\n") }
      end
    end
  end

  it_behaves_like "a Linux distribution", 'RedHat', '/etc/pdns', '/usr/lib64/pdns'
  it_behaves_like "a Linux distribution", 'Debian', '/etc/powerdns', '/usr/lib/x86_64-linux-gnu/pdns'
end
