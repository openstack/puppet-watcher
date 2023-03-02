require 'spec_helper'

describe 'watcher::client' do

  shared_examples_for 'watcher client' do

    it { is_expected.to contain_class('watcher::deps') }
    it { is_expected.to contain_class('watcher::params') }

    it 'installs watcher client package' do
      is_expected.to contain_package('python-watcherclient').with(
        :ensure => 'present',
        :name   => platform_params[:client_package_name],
        :tag    => 'openstack',
      )
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let(:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          { :client_package_name => 'python3-watcherclient' }
        when 'RedHat'
          { :client_package_name => 'python3-watcherclient' }
        end
      end

      it_behaves_like 'watcher client'
    end
  end

end
