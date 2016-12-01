require 'spec_helper'

describe 'watcher::api' do

  let :params do
    { :watcher_client_password => 'password',
      :manage_service    => true,
      :enabled           => true,
      :package_ensure    => 'latest',
    }
  end

  shared_examples 'watcher-api' do

    context 'without required parameter watcher_client_password' do
      before { params.delete(:watcher_client_password) }
      it { expect { is_expected.to raise_error(Puppet::Error) } }
    end

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
            :ensure     => (params[:manage_service] && params[:enabled]) ? 'running' : 'stopped',
            :name       => platform_params[:api_service_name],
            :enable     => params[:enabled],
            :hasstatus  => true,
            :hasrestart => true,
            :tag        => ['watcher-service',
                            'watcher-db-manage-create_schema',
                            'watcher-db-manage-upgrade'],
          )
        end
      end
    end

    context 'with default api configuration' do
      it 'should configure the api configurations section when enabled' do
        is_expected.to contain_watcher_config('api/port').with_value('9322')
        is_expected.to contain_watcher_config('api/max_limit').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('api/host').with_value('0.0.0.0')
        is_expected.to contain_watcher_config('api/workers').with_value(2)
        is_expected.to contain_watcher_config('api/enable_ssl_api').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with disabled service managing' do
      before do
        params.merge!({
          :manage_service => false,
          :enabled        => false })
      end

      it 'configures watcher-api service' do
        is_expected.to contain_service('watcher-api').with(
          :ensure     => nil,
          :name       => platform_params[:api_service_name],
          :enable     => false,
          :hasstatus  => true,
          :hasrestart => true,
          :tag        => ['watcher-service',
                          'watcher-db-manage-create_schema',
                          'watcher-db-manage-upgrade'],
        )
      end

      it 'should not configure the api configurations section when disabled' do
        is_expected.to_not contain_watcher_config('api/port')
        is_expected.to_not contain_watcher_config('api/max_limit')
        is_expected.to_not contain_watcher_config('api/host')
        is_expected.to_not contain_watcher_config('api/workers')
        is_expected.to_not contain_watcher_config('api/enable_ssl_api')
      end

    end

    context 'watcher clients auth section with default parameters' do
      it 'configures watcher clients auth' do
        is_expected.to contain_watcher_config('watcher_clients_auth/username').with_value('watcher')
        is_expected.to contain_watcher_config('watcher_clients_auth/password').with_value( params[:watcher_client_password] )
        is_expected.to contain_watcher_config('watcher_clients_auth/auth_url').with_value('http://localhost:35357/')
        is_expected.to contain_watcher_config('watcher_clients_auth/auth_uri').with_value('http://localhost:5000/')
        is_expected.to contain_watcher_config('watcher_clients_auth/project_name').with_value('service')
        is_expected.to contain_watcher_config('watcher_clients_auth/project_domain_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('watcher_clients_auth/insecure').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('watcher_clients_auth/auth_type').with_value('password')
        is_expected.to contain_watcher_config('watcher_clients_auth/cafile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('watcher_clients_auth/certfile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('watcher_clients_auth/keyfile').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'watcher clients auth section with overridden parameters' do
      before do
        params.merge! ({
          :watcher_client_username            => 'watcher_user',
          :watcher_client_password            => 'PassWoRD',
          :watcher_client_auth_uri            => 'http://localhost:5001/',
          :watcher_client_auth_url            => 'http://localhost:35358/',
          :watcher_client_project_name        => 'ProjectZero',
          :watcher_client_project_domain_name => 'WatcherDomain',
          :watcher_client_insecure            => 'true',
          :watcher_client_auth_type           => 'password',
          :watcher_client_cafile              => '/tmp/ca.crt',
          :watcher_client_certfile            => '/tmp/watcher.com.crt',
          :watcher_client_keyfile             => '/tmp/key.pm',
        })
      end
      it 'configures watcher clients auth' do
        is_expected.to contain_watcher_config('watcher_clients_auth/username').with_value( params[:watcher_client_username] )
        is_expected.to contain_watcher_config('watcher_clients_auth/password').with_value( params[:watcher_client_password] )
        is_expected.to contain_watcher_config('watcher_clients_auth/auth_uri').with_value('http://localhost:5001/')
        is_expected.to contain_watcher_config('watcher_clients_auth/auth_url').with_value('http://localhost:35358/')
        is_expected.to contain_watcher_config('watcher_clients_auth/project_name').with_value( params[:watcher_client_project_name] )
        is_expected.to contain_watcher_config('watcher_clients_auth/project_domain_name').with_value( params[:watcher_client_project_domain_name] )
        is_expected.to contain_watcher_config('watcher_clients_auth/insecure').with_value( params[:watcher_client_insecure] )
        is_expected.to contain_watcher_config('watcher_clients_auth/auth_type').with_value( params[:watcher_client_auth_type] )
        is_expected.to contain_watcher_config('watcher_clients_auth/cafile').with_value( params[:watcher_client_cafile] )
        is_expected.to contain_watcher_config('watcher_clients_auth/certfile').with_value( params[:watcher_client_certfile] )
        is_expected.to contain_watcher_config('watcher_clients_auth/keyfile').with_value( params[:watcher_client_keyfile] )
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
        case facts[:osfamily]
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
