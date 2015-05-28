describe 'powerdns::backend' do
  shared_examples 'a Linux distribution' do |osfamily|
    SUPPORTED_BACKENDS.each do |backend|
      let (:pre_condition) { 'include ::powerdns' }

      let (:facts) do
        {
          :operatingsystem => osfamily,
          :osfamily        => osfamily,
        }
      end

      context "on #{osfamily} with the #{backend} backend" do
        let (:title) { backend }

        it { should compile.with_all_deps }

        it { should contain_class("powerdns::backend::#{backend}").that_requires('Class[powerdns::install]') }
        it { should contain_class("powerdns::backend::#{backend}").that_notifies('Class[powerdns::service]') }
      end
    end

    context "on #{osfamily} with an unsupported backend" do
      let (:title) { 'unsupported' }

      let (:facts) do
        {
          :operatingsystem => osfamily,
          :osfamily        => osfamily,
        }
      end

      it { should_not compile.with_all_deps }

      it do
        expect { should contain_class('powerdns::backend::unsupported') }
        .to raise_error(Puppet::Error, /This module does not support the unsupported backend for PowerDNS!/)
      end
    end
  end


  it_behaves_like 'a Linux distribution', 'RedHat'
  it_behaves_like 'a Linux distribution', 'Debian'
end
