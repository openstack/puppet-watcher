require 'spec_helper'

describe 'watcher::placement_client' do

  shared_examples 'watcher::placement_client' do
    context 'with defaults' do
      let :params do
        {}
      end

      it 'should set the defaults' do
        should contain_watcher_config('placement_client/api_version').with_value('<SERVICE DEFAULT>')
        should contain_watcher_config('placement_client/interface').with_value('<SERVICE DEFAULT>')
        should contain_watcher_config('placement_client/region_name').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with parameters overridden' do
      let :params do
        {
          :api_version => 1,
          :interface   => 'publicURL',
          :region_name => 'regionOne'
        }
      end

      it 'should set the defaults' do
        should contain_watcher_config('placement_client/api_version').with_value(1)
        should contain_watcher_config('placement_client/interface').with_value('publicURL')
        should contain_watcher_config('placement_client/region_name').with_value('regionOne')
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
      it_behaves_like 'watcher::placement_client'
    end
  end

end
