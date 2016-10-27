require 'spec_helper'

describe 'watcher::policy' do
  shared_examples_for 'watcher-policies' do
    let :params do
      {
        :policy_path => '/etc/watcher/policy.json',
        :policies    => {
          'context_is_admin' => {
            'key'   => 'context_is_admin',
            'value' => 'foo:bar'
          }
        }
      }
    end

    it 'set up the policies' do
      is_expected.to contain_openstacklib__policy__base('context_is_admin').with({
        :key   => 'context_is_admin',
        :value => 'foo:bar'
      })
      is_expected.to contain_watcher_config('oslo_policy/policy_file').with_value('/etc/watcher/policy.json')
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'watcher-policies'
    end
  end
end
