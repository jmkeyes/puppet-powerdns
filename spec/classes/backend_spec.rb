SUPPORTED_BACKENDS.each do |backend|
  describe "powerdns::backend::#{backend}" do
    shared_examples 'a Linux distribution' do |osfamily, config_directory, packages|
      let (:pre_condition) { 'include ::powerdns' }

      let (:facts) do
        {
          :operatingsystem => osfamily,
          :osfamily        => osfamily,
        }
      end

      it { should compile.with_all_deps }
      it { should create_class("powerdns::backend::#{backend}") }
      it { should contain_package(packages[backend]).with_ensure('installed') }

      it do
        should contain_file("#{config_directory}/pdns.d/#{backend}.conf").with({
          :ensure => 'present',
          :owner  => 'root',
          :group  => 'root',
          :mode   => '0600'
        })
      end
    end

    context "on Debian" do
      it_behaves_like 'a Linux distribution', 'Debian', '/etc/powerdns', {
        'lmdb'     => 'pdns-backend-lmdb',
        'pipe'     => 'pdns-backend-pipe',
        'gmysql'   => 'pdns-backend-mysql',
        'gpgsql'   => 'pdns-backend-pgsql',
        'gsqlite3' => 'pdns-backend-sqlite3',
      }
    end

    context "on RedHat" do
      it_behaves_like 'a Linux distribution', 'RedHat', '/etc/pdns', {
        'lmdb'     => 'pdns-backend-lmdb',
        'pipe'     => 'pdns-backend-pipe',
        'gmysql'   => 'pdns-backend-mysql',
        'gsqlite3' => 'pdns-backend-sqlite',
        'gpgsql'   => 'pdns-backend-postgresql',
      }
    end
  end
end
