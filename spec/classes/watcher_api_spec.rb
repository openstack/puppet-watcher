require 'spec_helper'

describe 'watcher::api' do

  let :params do
    {
      :enabled        => true,
      :package_ensure => 'latest',
    }
  end

  let :pre_condition do
    "include watcher::db
     class { 'watcher': }
     class { 'watcher::keystone::authtoken':
       password => 'a_big_secret',
     }"
  end

  shared_examples 'watcher-api' do

    it { is_expected.to contain_class('watcher::params') }
    it { is_expected.to contain_class('watcher::deps') }

    it 'installs watcher-api package' do
      is_expected.to contain_package('watcher-api').with(
        :ensure => 'latest',
        :name   => platform_params[:api_package_name],
        :tag    => ['openstack', 'watcher-package'],
      )
    end

    [{:enabled => true}, {:enabled => false}].each do |param_hash|
      context "when service should be #{param_hash[:enabled] ? 'enabled' : 'disabled'}" do
        before do
          params.merge!(param_hash)
        end

        it 'configures watcher-api service' do
          is_expected.to contain_service('watcher-api').with(
            :ensure     => params[:enabled] ? 'running' : 'stopped',
            :name       => platform_params[:api_service_name],
            :enable     => params[:enabled],
            :hasstatus  => true,
            :hasrestart => true,
            :tag        => ['watcher-service'],
          )
        end
      end
    end

    context 'with default api configuration' do
      it 'should configure the api configurations section when enabled' do
        is_expected.to contain_watcher_config('api/port').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('api/max_limit').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('api/host').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('api/workers').with_value(2)
        is_expected.to contain_watcher_config('api/enable_ssl_api').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with disabled service managing' do
      before do
        params.merge!({
          :manage_service => false,
        })
      end

      it 'should not configure watcher-api service' do
        is_expected.to_not contain_service('watcher-api')
      end
    end

    context 'when running watcher-api in wsgi' do
      before do
        params.merge!({ :service_name => 'httpd' })
      end

      let :pre_condition do
        "include apache
         include watcher::db
         class { 'watcher': }
         class { 'watcher::keystone::authtoken':
           password => 'a_big_secret',
         }"
      end

      it 'configures watcher-api service with Apache' do
        is_expected.to contain_service('watcher-api').with(
          :ensure => 'stopped',
          :name   => platform_params[:api_service_name],
          :enable => false,
          :tag    => ['watcher-service'],
        )
      end
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
          { :api_package_name => 'watcher-api',
            :api_service_name => 'watcher-api' }
        when 'RedHat'
          { :api_package_name => 'openstack-watcher-api',
            :api_service_name => 'openstack-watcher-api' }
        end
      end
      it_behaves_like 'watcher-api'
    end
  end

end
