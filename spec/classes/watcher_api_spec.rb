require 'spec_helper'

describe 'watcher::api' do

  let :params do
    { :keystone_password => 'password' }
  end

  shared_examples 'watcher-api' do

    context 'without required parameter keystone_password' do
      before { params.delete(:keystone_password) }
      it { expect { is_expected.to raise_error(Puppet::Error) } }
    end

    context 'keystone authtoken with default parameters' do
      it 'configures keystone authtoken' do
        is_expected.to contain_watcher_config('keystone_authtoken/username').with_value('watcher')
        is_expected.to contain_watcher_config('keystone_authtoken/password').with_value( params[:keystone_password] )
        is_expected.to contain_watcher_config('keystone_authtoken/auth_url').with_value('http://localhost:35357/')
        is_expected.to contain_watcher_config('keystone_authtoken/auth_uri').with_value('http://localhost:5000/')
        is_expected.to contain_watcher_config('keystone_authtoken/project_name').with_value('service')
        is_expected.to contain_watcher_config('keystone_authtoken/project_domain_name').with_value('Default')
        is_expected.to contain_watcher_config('keystone_authtoken/insecure').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/auth_version').with_value('3')
        is_expected.to contain_watcher_config('keystone_authtoken/auth_type').with_value('password')
        is_expected.to contain_watcher_config('keystone_authtoken/signing_dir').with_value('/var/cache/watcher')
        is_expected.to contain_watcher_config('keystone_authtoken/region_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/cafile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/certfile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('keystone_authtoken/keyfile').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'keystone authtoken with overridden parameters' do
      before do
        params.merge! ({
          :keystone_password             => 'password1234',
          :keystone_username             => 'watcher_admin',
          :auth_url                      => 'https://127.0.0.1:35357/',
          :auth_uri                      => 'https://127.0.0.1:5000/',
          :keystone_project_name         => 'WatcherProject',
          :keystone_project_domain_name  => 'NiceDomain',
          :keystone_insecure             => 'true',
          :keystone_auth_version         => '4',
          :keystone_signing_dir          => '/tmp',
          :keystone_region_name          => 'RegionOne',
          :keystone_cafile               => '/etc/watcher/conf/ssl.crt/my_ca.crt',
          :keystone_certfile             => '/etc/watcher/ssl/certs/mydomain.com.crt',
          :keystone_keyfile              => '/etc/watcher/ssl/private/mydomain.com.pem',
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
      end
    end

    context 'watcher clients auth section with default parameters' do
      it 'configures watcher clients auth' do
        is_expected.to contain_watcher_config('watcher_clients_auth/username').with_value('watcher')
        is_expected.to contain_watcher_config('watcher_clients_auth/password').with_value( params[:keystone_password] )
        is_expected.to contain_watcher_config('watcher_clients_auth/auth_url').with_value('http://localhost:35357/')
        is_expected.to contain_watcher_config('watcher_clients_auth/auth_uri').with_value('http://localhost:5000/')
        is_expected.to contain_watcher_config('watcher_clients_auth/project_name').with_value('service')
        is_expected.to contain_watcher_config('watcher_clients_auth/project_domain_name').with_value('Default')
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
        is_expected.to contain_watcher_config('watcher_clients_auth/project_domain_name').with_value('Default')
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
      it_behaves_like 'watcher-api'
    end
  end
end
