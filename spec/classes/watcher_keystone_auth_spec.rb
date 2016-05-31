#
# Unit tests for watcher::keystone::auth
#

require 'spec_helper'

describe 'watcher::keystone::auth' do
  shared_examples_for 'watcher-keystone-auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'watcher_password',
          :tenant   => 'foobar' }
      end

      it { is_expected.to contain_keystone_user('watcher').with(
        :ensure   => 'present',
        :password => 'watcher_password',
      ) }

      it { is_expected.to contain_keystone_user_role('watcher@foobar').with(
        :ensure  => 'present',
        :roles   => ['admin']
      )}

      it { is_expected.to contain_keystone_service('watcher::infra-optim').with(
        :ensure      => 'present',
        :description => 'Infrastructure Optimization service'
      ) }

      it { is_expected.to contain_keystone_endpoint('RegionOne/watcher::infra-optim').with(
        :ensure       => 'present',
        :public_url   => 'http://127.0.0.1:9322',
        :admin_url    => 'http://127.0.0.1:9322',
        :internal_url => 'http://127.0.0.1:9322',
      ) }
    end

    context 'when overriding URL parameters' do
      let :params do
        { :password     => 'watcher_password',
          :public_url   => 'https://10.10.10.10:80',
          :internal_url => 'http://10.10.10.11:81',
          :admin_url    => 'http://10.10.10.12:81', }
      end

      it { is_expected.to contain_keystone_endpoint('RegionOne/watcher::infra-optim').with(
        :ensure       => 'present',
        :public_url   => 'https://10.10.10.10:80',
        :internal_url => 'http://10.10.10.11:81',
        :admin_url    => 'http://10.10.10.12:81',
      ) }
    end

    context 'when overriding auth name' do
      let :params do
        { :password => 'foo',
          :auth_name => 'watchery' }
      end

      it { is_expected.to contain_keystone_user('watchery') }
      it { is_expected.to contain_keystone_user_role('watchery@services') }
      it { is_expected.to contain_keystone_service('watchery::infra-optim') }
      it { is_expected.to contain_keystone_endpoint('RegionOne/watchery::infra-optim') }
    end

    context 'when overriding service name' do
      let :params do
        { :service_name => 'watcher_service',
          :auth_name    => 'watcher',
          :password     => 'watcher_password' }
      end

      it { is_expected.to contain_keystone_user('watcher') }
      it { is_expected.to contain_keystone_user_role('watcher@services') }
      it { is_expected.to contain_keystone_service('watcher_service::infra-optim') }
      it { is_expected.to contain_keystone_endpoint('RegionOne/watcher_service::infra-optim') }
    end

    context 'when disabling user configuration' do

      let :params do
        {
          :password       => 'watcher_password',
          :configure_user => false
        }
      end

      it { is_expected.not_to contain_keystone_user('watcher') }
      it { is_expected.to contain_keystone_user_role('watcher@services') }
      it { is_expected.to contain_keystone_service('watcher::infra-optim').with(
        :ensure      => 'present',
        :description => 'Infrastructure Optimization service'
      ) }

    end

    context 'when disabling user and user role configuration' do

      let :params do
        {
          :password            => 'watcher_password',
          :configure_user      => false,
          :configure_user_role => false
        }
      end

      it { is_expected.not_to contain_keystone_user('watcher') }
      it { is_expected.not_to contain_keystone_user_role('watcher@services') }
      it { is_expected.to contain_keystone_service('watcher::infra-optim').with(
        :ensure      => 'present',
        :description => 'Infrastructure Optimization service'
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

      it_behaves_like 'watcher-keystone-auth'
    end
  end
end
