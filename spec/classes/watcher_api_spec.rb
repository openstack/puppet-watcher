require 'spec_helper'

describe 'watcher::api' do

  let :params do
    { :keystone_password => 'password',
      :manage_service    => true,
      :enabled           => true,
      :package_ensure    => 'latest',
    }
  end

  shared_examples 'watcher-api' do

    context 'without required parameter keystone_password' do
      before { params.delete(:keystone_password) }
      it { expect { is_expected.to raise_error(Puppet::Error) } }
    end

    it { is_expected.to contain_class('watcher::params') }

    it 'installs watcher-api package' do
      is_expected.to contain_package('watcher-api').with(
        :ensure => 'latest',
        :name   => platform_params[:api_package_name],
        :tag    => ['openstack', 'watcher-package'],
      )
    end

#    context 'keystone authtoken with default parameters' do
      it 'configures keystone authtoken' do
        is_expected.to contain_watcher_config('keystone_authtoken/username').with_value('watcher')
        is_expected.to contain_watcher_config('keystone_authtoken/password').with_value( params[:keystone_password] )
        is_expected.to contain_watcher_config('keystone_authtoken/auth_url').with_value('http://localhost:35357/')
        is_expected.to contain_watcher_config('keystone_authtoken/auth_uri').with_value('http://localhost:5000/')
        is_expected.to contain_watcher_config('keystone_authtoken/project_name').with_value('service')
        is_expected.to contain_watcher_config('keystone_authtoken/project_domain_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/insecure').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/auth_version').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/auth_type').with_value('password')
        is_expected.to contain_watcher_config('keystone_authtoken/signing_dir').with_value('/var/cache/watcher')
        is_expected.to contain_watcher_config('keystone_authtoken/region_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/cafile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/certfile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/keyfile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/user_domain_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/auth_section').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/check_revocations_for_cached').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/enforce_token_bind').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/include_service_catalog').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/revocation_cache_time').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/token_cache_time').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/memcache_pool_conn_get_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/memcache_pool_dead_retry').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/memcache_pool_maxsize').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/memcache_pool_socket_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/memcache_secret_key').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/memcache_security_strategy').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/memcache_use_advanced_pool').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/memcache_pool_unused_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/memcached_servers').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/cache').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/delay_auth_decision').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/hash_algorithms').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/http_connect_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/http_request_max_retries').with_value('<SERVICE DEFAULT>')
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

    context 'keystone authtoken with overridden parameters' do
      before do
        params.merge! ({
          :keystone_password                       => 'password1234',
          :keystone_username                       => 'watcher_admin',
          :auth_url                                => 'https://127.0.0.1:35357/',
          :auth_uri                                => 'https://127.0.0.1:5000/',
          :keystone_project_name                   => 'WatcherProject',
          :keystone_project_domain_name            => 'NiceDomain',
          :keystone_insecure                       => true,
          :keystone_auth_version                   => '4',
          :keystone_signing_dir                    => '/tmp',
          :keystone_region_name                    => 'RegionOne',
          :keystone_cafile                         => '/etc/watcher/conf/ssl.crt/my_ca.crt',
          :keystone_certfile                       => '/etc/watcher/ssl/certs/mydomain.com.crt',
          :keystone_keyfile                        => '/etc/watcher/ssl/private/mydomain.com.pem',
          :keystone_user_domain_name               => 'someDomain',
          :keystone_auth_section                   => 'SectionOne',
          :keystone_check_revocations_for_cached   => true,
          :keystone_enforce_token_bind             => 'Sure',
          :keystone_include_service_catalog        => false,
          :keystone_revocation_cache_time          => '200',
          :keystone_token_cache_time               => '100',
          :keystone_memcache_pool_conn_get_timeout => '10',
          :keystone_memcache_pool_dead_retry       => '2',
          :keystone_memcache_pool_maxsize          => '1000',
          :keystone_memcache_pool_socket_timeout   => '80',
          :keystone_memcache_secret_key            => 'NoSecret',
          :keystone_memcache_security_strategy     => 'MAC',
          :keystone_memcache_use_advanced_pool     => true,
          :keystone_memcache_pool_unused_timeout   => '6',
          :keystone_memcached_servers              => ['memcached01:11211', 'memcached02:11211'],
          :keystone_cache                          => 'NoCache',
          :keystone_delay_auth_decision            => true,
          :keystone_hash_algorithms                => 'md5',
          :keystone_http_connect_timeout           => '20',
          :keystone_http_request_max_retries       => '2',
        })
      end
      it 'configures keystone authtoken' do
        is_expected.to contain_watcher_config('keystone_authtoken/username').with_value( params[:keystone_username] )
        is_expected.to contain_watcher_config('keystone_authtoken/password').with_value( params[:keystone_password] )
        is_expected.to contain_watcher_config('keystone_authtoken/auth_url').with_value( params[:auth_url] )
        is_expected.to contain_watcher_config('keystone_authtoken/auth_uri').with_value( params[:auth_uri] )
        is_expected.to contain_watcher_config('keystone_authtoken/project_name').with_value( params[:keystone_project_name] )
        is_expected.to contain_watcher_config('keystone_authtoken/project_domain_name').with_value( params[:keystone_project_domain_name] )
        is_expected.to contain_watcher_config('keystone_authtoken/insecure').with_value( params[:keystone_insecure] )
        is_expected.to contain_watcher_config('keystone_authtoken/auth_version').with_value( params[:keystone_auth_version] )
        is_expected.to contain_watcher_config('keystone_authtoken/auth_type').with_value('password')
        is_expected.to contain_watcher_config('keystone_authtoken/signing_dir').with_value( params[:keystone_signing_dir] )
        is_expected.to contain_watcher_config('keystone_authtoken/region_name').with_value( params[:keystone_region_name] )
        is_expected.to contain_watcher_config('keystone_authtoken/cafile').with_value( params[:keystone_cafile] )
        is_expected.to contain_watcher_config('keystone_authtoken/certfile').with_value( params[:keystone_certfile] )
        is_expected.to contain_watcher_config('keystone_authtoken/keyfile').with_value( params[:keystone_keyfile] )
        is_expected.to contain_watcher_config('keystone_authtoken/user_domain_name').with_value( params[:keystone_user_domain_name] )
        is_expected.to contain_watcher_config('keystone_authtoken/auth_section').with_value( params[:keystone_auth_section] )
        is_expected.to contain_watcher_config('keystone_authtoken/check_revocations_for_cached').with_value( params[:keystone_check_revocations_for_cached] )
        is_expected.to contain_watcher_config('keystone_authtoken/enforce_token_bind').with_value( params[:keystone_enforce_token_bind] )
        is_expected.to contain_watcher_config('keystone_authtoken/include_service_catalog').with_value( params[:keystone_include_service_catalog] )
        is_expected.to contain_watcher_config('keystone_authtoken/revocation_cache_time').with_value( params[:keystone_revocation_cache_time] )
        is_expected.to contain_watcher_config('keystone_authtoken/token_cache_time').with_value( params[:keystone_token_cache_time] )
        is_expected.to contain_watcher_config('keystone_authtoken/memcache_pool_conn_get_timeout').with_value( params[:keystone_memcache_pool_conn_get_timeout] )
        is_expected.to contain_watcher_config('keystone_authtoken/memcache_pool_dead_retry').with_value( params[:keystone_memcache_pool_dead_retry] )
        is_expected.to contain_watcher_config('keystone_authtoken/memcache_pool_maxsize').with_value( params[:keystone_memcache_pool_maxsize] )
        is_expected.to contain_watcher_config('keystone_authtoken/memcache_pool_socket_timeout').with_value( params[:keystone_memcache_pool_socket_timeout] )
        is_expected.to contain_watcher_config('keystone_authtoken/memcache_secret_key').with_value( params[:keystone_memcache_secret_key] )
        is_expected.to contain_watcher_config('keystone_authtoken/memcache_security_strategy').with_value( params[:keystone_memcache_security_strategy] )
        is_expected.to contain_watcher_config('keystone_authtoken/memcache_use_advanced_pool').with_value( params[:keystone_memcache_use_advanced_pool] )
        is_expected.to contain_watcher_config('keystone_authtoken/memcache_pool_unused_timeout').with_value( params[:keystone_memcache_pool_unused_timeout] )
        is_expected.to contain_watcher_config('keystone_authtoken/memcached_servers').with_value('memcached01:11211,memcached02:11211')
        is_expected.to contain_watcher_config('keystone_authtoken/cache').with_value( params[:keystone_cache] )
        is_expected.to contain_watcher_config('keystone_authtoken/delay_auth_decision').with_value( params[:keystone_delay_auth_decision] )
        is_expected.to contain_watcher_config('keystone_authtoken/hash_algorithms').with_value( params[:keystone_hash_algorithms] )
        is_expected.to contain_watcher_config('keystone_authtoken/http_connect_timeout').with_value( params[:keystone_http_connect_timeout] )
        is_expected.to contain_watcher_config('keystone_authtoken/http_request_max_retries').with_value( params[:keystone_http_request_max_retries] )
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
    end

    context 'watcher clients auth section with default parameters' do
      it 'configures watcher clients auth' do
        is_expected.to contain_watcher_config('watcher_clients_auth/username').with_value('watcher')
        is_expected.to contain_watcher_config('watcher_clients_auth/password').with_value( params[:keystone_password] )
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
        is_expected.to contain_watcher_config('watcher_clients_auth/auth_url').with_value('http://localhost:35357/')
        is_expected.to contain_watcher_config('watcher_clients_auth/auth_uri').with_value('http://localhost:5000/')
        is_expected.to contain_watcher_config('watcher_clients_auth/project_name').with_value( params[:watcher_client_project_name] )
        is_expected.to contain_watcher_config('watcher_clients_auth/project_domain_name').with_value( params[:watcher_client_project_domain_name] )
        is_expected.to contain_watcher_config('watcher_clients_auth/insecure').with_value( params[:watcher_client_insecure] )
        is_expected.to contain_watcher_config('watcher_clients_auth/auth_type').with_value( params[:watcher_client_auth_type] )
        is_expected.to contain_watcher_config('watcher_clients_auth/cafile').with_value( params[:watcher_client_cafile] )
        is_expected.to contain_watcher_config('watcher_clients_auth/certfile').with_value( params[:watcher_client_certfile] )
        is_expected.to contain_watcher_config('watcher_clients_auth/keyfile').with_value( params[:watcher_client_keyfile] )
      end
    end

    context 'with watcher clients is taking keystone authtoken parameters' do
      before do
        params.merge! ( {
          :keystone_password             => 'password1234',
          :keystone_username             => 'watcher_admin',
          :auth_url                      => 'https://127.0.0.1:35357/',
          :auth_uri                      => 'https://127.0.0.1:5000/',
          :keystone_project_name         => 'WatcherProject',
          :keystone_project_domain_name  => 'NiceDomain',
          :keystone_insecure             => 'true',
          :keystone_cafile               => '/etc/watcher/conf/ssl.crt/my_ca.crt',
          :keystone_certfile             => '/etc/watcher/ssl/certs/mydomain.com.crt',
          :keystone_keyfile              => '/etc/watcher/ssl/private/mydomain.com.pem',
        })
      end
      # these parameters we can check in second test:  keystone authtoken with overridden parameter
      it 'configures watcher clients auth' do
        is_expected.to contain_watcher_config('watcher_clients_auth/username').with_value( params[:keystone_username] )
        is_expected.to contain_watcher_config('watcher_clients_auth/password').with_value( params[:keystone_password]).with_secret(true)
        is_expected.to contain_watcher_config('watcher_clients_auth/auth_url').with_value( params[:auth_url] )
        is_expected.to contain_watcher_config('watcher_clients_auth/auth_uri').with_value( params[:auth_uri] )
        is_expected.to contain_watcher_config('watcher_clients_auth/project_name').with_value( params[:keystone_project_name] )
        is_expected.to contain_watcher_config('watcher_clients_auth/project_domain_name').with_value( params[:keystone_project_domain_name] )
        is_expected.to contain_watcher_config('watcher_clients_auth/insecure').with_value( params[:keystone_insecure] )
        is_expected.to contain_watcher_config('watcher_clients_auth/auth_type').with_value('password')
        is_expected.to contain_watcher_config('watcher_clients_auth/cafile').with_value( params[:keystone_cafile] )
        is_expected.to contain_watcher_config('watcher_clients_auth/certfile').with_value( params[:keystone_certfile] )
        is_expected.to contain_watcher_config('watcher_clients_auth/keyfile').with_value( params[:keystone_keyfile] )
      end
    end

    context 'with mixed watcher clients auth parameters' do
      before do
        params.merge! ({
          :keystone_password       => 'password',
          :keystone_username       => 'watcher_admin',
          :keystone_insecure       => 'true',
          :keystone_region_name    => 'RegionOne',
          :watcher_client_username => 'watcher_user',
          :watcher_client_password => 'watcher_password',
          :watcher_client_insecure => 'false',
        })
      end
      it 'configures watcher clients auth' do
        is_expected.to contain_watcher_config('watcher_clients_auth/username').with_value('watcher_user')
        is_expected.to contain_watcher_config('watcher_clients_auth/password').with_value('watcher_password')
        is_expected.to contain_watcher_config('watcher_clients_auth/auth_url').with_value('http://localhost:35357/')
        is_expected.to contain_watcher_config('watcher_clients_auth/auth_uri').with_value('http://localhost:5000/')
        is_expected.to contain_watcher_config('watcher_clients_auth/project_name').with_value('service')
        is_expected.to contain_watcher_config('watcher_clients_auth/project_domain_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('watcher_clients_auth/insecure').with_value('false')
        is_expected.to contain_watcher_config('watcher_clients_auth/auth_type').with_value('password')
        is_expected.to contain_watcher_config('watcher_clients_auth/cafile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('watcher_clients_auth/certfile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('watcher_clients_auth/keyfile').with_value('<SERVICE DEFAULT>')
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
