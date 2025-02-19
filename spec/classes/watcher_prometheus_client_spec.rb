require 'spec_helper'

describe 'watcher::prometheus_client' do

  shared_examples 'watcher::prometheus_client' do
    let :params do
      {
        :host => '127.0.0.1'
      }
    end

    context 'with defaults' do
      it 'should set the defaults' do
        should contain_watcher_config('prometheus_client/host').with_value('127.0.0.1')
        should contain_watcher_config('prometheus_client/port').with_value('<SERVICE DEFAULT>')
        should contain_watcher_config('prometheus_client/fqdn_label').with_value('<SERVICE DEFAULT>')
        should contain_watcher_config('prometheus_client/instance_uuid_label').with_value('<SERVICE DEFAULT>')
        should contain_watcher_config('prometheus_client/username').with_value('<SERVICE DEFAULT>')
        should contain_watcher_config('prometheus_client/password').with_value('<SERVICE DEFAULT>').with_secret(true)
      end
    end

    context 'with parameters overridden' do
      before :each do
        params.merge!({
          :port                => 9090,
          :fqdn_label          => 'fqdn',
          :instance_uuid_label => 'resource',
          :username            => 'promuser',
          :password            => 'prompass'
        })
      end

      it 'should set the overridden values' do
        should contain_watcher_config('prometheus_client/host').with_value('127.0.0.1')
        should contain_watcher_config('prometheus_client/port').with_value(9090)
        should contain_watcher_config('prometheus_client/fqdn_label').with_value('fqdn')
        should contain_watcher_config('prometheus_client/instance_uuid_label').with_value('resource')
        should contain_watcher_config('prometheus_client/username').with_value('promuser')
        should contain_watcher_config('prometheus_client/password').with_value('prompass').with_secret(true)
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
      it_behaves_like 'watcher::prometheus_client'
    end
  end

end
