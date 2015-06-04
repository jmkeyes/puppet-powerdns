describe "powerdns::backend::gmysql" do
  let (:params) do
    {
      :host     => '127.0.0.1',
      :user     => 'username',
      :password => 'password',
      :dbname   => 'powerdns',
      :port     => 3306,
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
    it { should contain_package('pdns-backend-mysql') }

    it do
      should create_file('/etc/powerdns/pdns.d/gmysql.conf').with({
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
    it { should contain_package('pdns-backend-mysql') }

    it do
      should create_file('/etc/pdns/pdns.d/gmysql.conf').with({
        :ensure => 'present',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0600',
     })
    end
  end
end
