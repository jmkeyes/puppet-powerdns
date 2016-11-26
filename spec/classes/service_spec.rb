describe 'powerdns::service' do
  shared_examples 'a Linux distribution' do |osfamily|
    let (:pre_condition) { 'include ::powerdns' }

    let (:facts) do
      {
        :operatingsystem => osfamily,
        :osfamily        => osfamily,
      }
    end

    let (:default_params) do
      {
        :ensure => 'running',
        :enable => true
      }
    end

    it { should compile.with_all_deps }
    it { should create_class('powerdns::service') }
    it { should contain_service('pdns').with(default_params) }
  end

  it_behaves_like 'a Linux distribution', 'RedHat'
  it_behaves_like 'a Linux distribution', 'Debian'
  it_behaves_like 'a Linux distribution', 'ArchLinux'
end
