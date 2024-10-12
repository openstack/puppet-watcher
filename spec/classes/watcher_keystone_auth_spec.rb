#
# Unit tests for watcher::keystone::auth
#

require 'spec_helper'

describe 'watcher::keystone::auth' do
  shared_examples_for 'watcher::keystone::auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'watcher_password' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('watcher').with(
        :configure_user      => true,
        :configure_user_role => true,
        :configure_endpoint  => true,
        :configure_service   => true,
        :service_name        => 'watcher',
        :service_type        => 'infra-optim',
        :service_description => 'Infrastructure Optimization service',
        :region              => 'RegionOne',
        :auth_name           => 'watcher',
        :password            => 'watcher_password',
        :email               => 'watcher@localhost',
        :tenant              => 'services',
        :roles               => ['admin'],
        :system_scope        => 'all',
        :system_roles        => [],
        :public_url          => 'http://127.0.0.1:9322',
        :internal_url        => 'http://127.0.0.1:9322',
        :admin_url           => 'http://127.0.0.1:9322',
      ) }
    end

    context 'when overriding parameters' do
      let :params do
        { :password            => 'watcher_password',
          :auth_name           => 'alt_watcher',
          :email               => 'alt_watcher@alt_localhost',
          :tenant              => 'alt_service',
          :roles               => ['admin', 'service'],
          :system_scope        => 'alt_all',
          :system_roles        => ['admin', 'member', 'reader'],
          :configure_endpoint  => false,
          :configure_user      => false,
          :configure_user_role => false,
          :configure_service   => false,
          :service_description => 'Alternative Infrastructure Optimization service',
          :service_name        => 'alt_service',
          :service_type        => 'alt_infra-optim',
          :region              => 'RegionTwo',
          :public_url          => 'https://10.10.10.10:80',
          :internal_url        => 'http://10.10.10.11:81',
          :admin_url           => 'http://10.10.10.12:81' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('watcher').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => false,
        :configure_service   => false,
        :service_name        => 'alt_service',
        :service_type        => 'alt_infra-optim',
        :service_description => 'Alternative Infrastructure Optimization service',
        :region              => 'RegionTwo',
        :auth_name           => 'alt_watcher',
        :password            => 'watcher_password',
        :email               => 'alt_watcher@alt_localhost',
        :tenant              => 'alt_service',
        :roles               => ['admin', 'service'],
        :system_scope        => 'alt_all',
        :system_roles        => ['admin', 'member', 'reader'],
        :public_url          => 'https://10.10.10.10:80',
        :internal_url        => 'http://10.10.10.11:81',
        :admin_url           => 'http://10.10.10.12:81',
      ) }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'watcher::keystone::auth'
    end
  end
end
