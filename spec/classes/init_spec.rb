describe 'powerdns' do
  shared_examples 'a Linux distribution' do |osfamily|
    context "on #{osfamily}" do
      let (:facts) do
        {
          :operatingsystem => osfamily,
          :osfamily        => osfamily,
        }
      end

      it { should compile.with_all_deps }
      it { should contain_class('powerdns::install').that_comes_before('Class[powerdns::config]') }
      it { should contain_class('powerdns::config').that_requires('Class[powerdns::install]') }
      it { should contain_class('powerdns::config').that_notifies('Class[powerdns::service]') }
      it { should contain_class('powerdns::service').that_subscribes_to('Class[powerdns::config]') }
    end
  end

  it_behaves_like 'a Linux distribution', 'RedHat'
  it_behaves_like 'a Linux distribution', 'Debian'
end
