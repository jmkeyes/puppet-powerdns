describe "powerdns::backend::tinydns" do
  let (:params) do
    {
      :dbfile => '/var/tmp/pdns.cdb',
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
    it { should contain_package('pdns-backend-tinydns') }

    it do
      should create_file('/etc/powerdns/pdns.d/tinydns.conf').with({
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
    it { should contain_package('pdns-backend-tinydns') }

    it do
      should create_file('/etc/pdns/pdns.d/tinydns.conf').with({
        :ensure => 'present',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0600',
      })
    end
  end

  context "on ArchLinux" do
    let (:pre_condition) { 'include ::powerdns' }

    let (:facts) do
      {
        :osfamily => 'ArchLinux'
      }
    end

    it { should compile.with_all_deps }
    it { should create_class(class_name) }

    it do
      should create_file('/etc/powerdns/pdns.d/tinydns.conf').with({
        :ensure => 'present',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0600',
      })
    end
  end
end
