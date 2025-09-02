require 'spec_helper'

describe 'watcher::collector' do

  shared_examples 'watcher::collector' do
    context 'with defaults' do
      let :params do
        {}
      end

      it 'should set the defaults' do
        should contain_watcher_config('collector/collector_plugins').with_value('<SERVICE DEFAULT>')
        should contain_watcher_config('collector/api_query_retries').with_value('<SERVICE DEFAULT>')
        should contain_watcher_config('collector/api_query_interval').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with parameters overridden' do
      let :params do
        {
          :collector_plugins  => ['compute', 'storage'],
          :api_query_retries  => 10,
          :api_query_interval => 1,
        }
      end

      it 'should set the overridden values' do
        should contain_watcher_config('collector/collector_plugins').with_value('compute,storage')
        should contain_watcher_config('collector/api_query_retries').with_value(10)
        should contain_watcher_config('collector/api_query_interval').with_value(1)
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
      it_behaves_like 'watcher::collector'
    end
  end

end
