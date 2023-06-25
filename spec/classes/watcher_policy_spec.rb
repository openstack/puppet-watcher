require 'spec_helper'

describe 'watcher::policy' do
  shared_examples 'watcher::policy' do

    context 'setup policy with parameters' do
      let :params do
        {
          :enforce_scope        => false,
          :enforce_new_defaults => false,
          :policy_path          => '/etc/watcher/policy.yaml',
          :policy_dirs          => '/etc/watcher/policy.d',
          :policies             => {
            'context_is_admin' => {
              'key'   => 'context_is_admin',
              'value' => 'foo:bar'
            }
          }
        }
      end

      it 'set up the policies' do
        is_expected.to contain_openstacklib__policy('/etc/watcher/policy.yaml').with(
          :policies     => {
            'context_is_admin' => {
              'key'   => 'context_is_admin',
              'value' => 'foo:bar'
            }
          },
          :policy_path  => '/etc/watcher/policy.yaml',
          :file_user    => 'root',
          :file_group   => 'watcher',
          :file_format  => 'yaml',
          :purge_config => false,
          :tag          => 'watcher',
        )
        is_expected.to contain_oslo__policy('watcher_config').with(
          :enforce_scope        => false,
          :enforce_new_defaults => false,
          :policy_file          => '/etc/watcher/policy.yaml',
          :policy_dirs          => '/etc/watcher/policy.d',
        )
      end
    end

    context 'with empty policies and purge_config enabled' do
      let :params do
        {
          :enforce_scope        => false,
          :enforce_new_defaults => false,
          :policy_path          => '/etc/watcher/policy.yaml',
          :policies             => {},
          :purge_config         => true,
        }
      end

      it 'set up the policies' do
        is_expected.to contain_openstacklib__policy('/etc/watcher/policy.yaml').with(
          :policies     => {},
          :policy_path  => '/etc/watcher/policy.yaml',
          :file_user    => 'root',
          :file_group   => 'watcher',
          :file_format  => 'yaml',
          :purge_config => true,
          :tag          => 'watcher',
        )
        is_expected.to contain_oslo__policy('watcher_config').with(
          :enforce_scope        => false,
          :enforce_new_defaults => false,
          :policy_file          => '/etc/watcher/policy.yaml',
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

      it_behaves_like 'watcher::policy'
    end
  end
end
