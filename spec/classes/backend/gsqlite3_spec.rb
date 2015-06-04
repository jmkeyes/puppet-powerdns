describe "powerdns::backend::gsqlite3" do
  let (:params) do
    {
      :database     => '/var/tmp/pdns.db',
      :synchronous  => 1,
      :foreign_keys => 1,
    }
  end

  context "on Debian" do
    let (:pre_condition) { 'include ::powerdns' }

    let (:facts) do
      {
        :osfamily => 'Debian'
      }
    end

    it { should compile.with_all_deps }
    it { should create_class(class_name) }
    it { should contain_package('pdns-backend-sqlite3') }

    it do
      should create_file('/etc/powerdns/pdns.d/gsqlite3.conf').with({
        :ensure => 'present',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0600',
     })
    end
  end

  context "on RedHat" do
    let (:pre_condition) { 'include ::powerdns' }

    let (:facts) do
      {
        :osfamily => 'RedHat'
      }
    end

    it { should compile.with_all_deps }
    it { should create_class(class_name) }
    it { should contain_package('pdns-backend-sqlite') }

    it do
      should create_file('/etc/pdns/pdns.d/gsqlite3.conf').with({
        :ensure => 'present',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0600',
     })
    end
  end
end
