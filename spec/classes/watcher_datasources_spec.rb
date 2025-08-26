require 'spec_helper'

describe 'watcher::datasources' do

  shared_examples 'watcher::datasources' do
    context 'with defaults' do
      let :params do
        {}
      end

      it 'should set the defaults' do
        should contain_watcher_config('datasources/datasources').with_value('<SERVICE DEFAULT>')
        should contain_watcher_config('datasources/query_max_retries').with_value('<SERVICE DEFAULT>')
        should contain_watcher_config('datasources/query_interval').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with parameters overridden' do
      let :params do
        {
          :datasources       => ['gnocchi', 'prometheus'],
          :query_max_retries => 10,
          :query_interval    => 0,
        }
      end

      it 'should set the overridden values' do
        should contain_watcher_config('datasources/datasources').with_value('gnocchi,prometheus')
        should contain_watcher_config('datasources/query_max_retries').with_value(10)
        should contain_watcher_config('datasources/query_interval').with_value(0)
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
      it_behaves_like 'watcher::datasources'
    end
  end

end
