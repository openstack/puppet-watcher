require 'spec_helper'

describe 'watcher::watcher_clients_auth' do

  shared_examples 'watcher::watcher_clients_auth' do
    let :params do
      { :password => 'watcher_password' }
    end

    context 'with defaults' do
      it 'should set the defaults' do
        should contain_watcher_config('watcher_clients_auth/password').with_value('watcher_password').with_secret(true)
        should contain_watcher_config('watcher_clients_auth/auth_url').with_value('http://localhost:5000/')
        should contain_watcher_config('watcher_clients_auth/username').with_value('watcher')
        should contain_watcher_config('watcher_clients_auth/project_name').with_value('services')
        should contain_watcher_config('watcher_clients_auth/user_domain_name').with_value('Default')
        should contain_watcher_config('watcher_clients_auth/project_domain_name').with_value('Default')
        should contain_watcher_config('watcher_clients_auth/system_scope').with_value('<SERVICE DEFAULT>')
        should contain_watcher_config('watcher_clients_auth/insecure').with_value('<SERVICE DEFAULT>')
        should contain_watcher_config('watcher_clients_auth/certfile').with_value('<SERVICE DEFAULT>')
        should contain_watcher_config('watcher_clients_auth/cafile').with_value('<SERVICE DEFAULT>')
        should contain_watcher_config('watcher_clients_auth/keyfile').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with parameters overridden' do
      before do
        params.merge!({
          :auth_url            => 'http://127.0.0.1:5000/',
          :username            => 'alt_watcher',
          :project_name        => 'alt_services',
          :project_domain_name => 'project_domain',
          :user_domain_name    => 'user_domain',
          :insecure            => false,
          :certfile            => 'path_to_cert',
          :cafile              => 'path_to_ca',
          :keyfile             => 'path_to_key',
        })
      end

      it 'should set the parameters' do
        should contain_watcher_config('watcher_clients_auth/auth_url').with_value('http://127.0.0.1:5000/')
        should contain_watcher_config('watcher_clients_auth/username').with_value('alt_watcher')
        should contain_watcher_config('watcher_clients_auth/project_name').with_value('alt_services')
        should contain_watcher_config('watcher_clients_auth/user_domain_name').with_value('user_domain')
        should contain_watcher_config('watcher_clients_auth/project_domain_name').with_value('project_domain')
        should contain_watcher_config('watcher_clients_auth/system_scope').with_value('<SERVICE DEFAULT>')
        should contain_watcher_config('watcher_clients_auth/insecure').with_value(false)
        should contain_watcher_config('watcher_clients_auth/certfile').with_value('path_to_cert')
        should contain_watcher_config('watcher_clients_auth/cafile').with_value('path_to_ca')
        should contain_watcher_config('watcher_clients_auth/keyfile').with_value('path_to_key')
      end
    end

    context 'when system_scope is set' do
      before do
        params.merge!(
          :system_scope => 'all'
        )
      end
      it 'configures system-scoped credential' do
        is_expected.to contain_watcher_config('watcher_clients_auth/project_domain_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('watcher_clients_auth/project_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('watcher_clients_auth/system_scope').with_value('all')
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
      it_behaves_like 'watcher::watcher_clients_auth'
    end
  end

end
