require 'spec_helper'

describe 'watcher::applier' do

  shared_examples 'watcher-applier' do

    context 'with default parameters' do

      it 'installs packages' do
        is_expected.to contain_package('watcher-applier').with(
          :name   => platform_params[:watcher_applier_package],
          :ensure => 'present',
          :tag    => ['openstack', 'watcher-package']
        )
      end

      it 'configures watcher applier service' do
        is_expected.to contain_watcher_config('watcher_applier/workers').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('watcher_applier/conductor_topic').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('watcher_applier/status_topic').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('watcher_applier/publisher_id').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('watcher_applier/workflow_engine').with_value('<SERVICE DEFAULT>')
      end
    end

    [{:enabled => true}, {:enabled => false}].each do |param_hash|
    context "when service should be #{param_hash[:enabled] ? 'enabled' : 'disabled'}" do
      let :params do
        { :enabled           => true,
          :manage_service    => true,
        }
      end
      before do
        params.merge!(param_hash)
      end

      it 'configures watcher applier service' do
        is_expected.to contain_service('watcher-applier').with(
          :ensure     => (params[:manage_service] && params[:enabled]) ? 'running' : 'stopped',
          :name       => platform_params[:applier_service_name],
          :enable     => params[:enabled],
          :hasstatus  => true,
          :hasrestart => true,
          :tag        => ['watcher-service'],
        )
        end
      end
    end

    context 'with overridden parameters' do
      let :params do
        {
          :package_ensure             => '2012.1.1-15.el6',
          :applier_workers            => '10',
          :applier_conductor_topic    => 'applier123',
          :applier_status_topic       => 'someStatus',
          :applier_publisher_id       => '20120101',
          :applier_workflow_engine    => 'taskFloooow',
        }
      end
      it 'configures watcher applier' do
        is_expected.to contain_watcher_config('watcher_applier/workers').with_value('10')
        is_expected.to contain_watcher_config('watcher_applier/conductor_topic').with_value('applier123')
        is_expected.to contain_watcher_config('watcher_applier/status_topic').with_value('someStatus')
        is_expected.to contain_watcher_config('watcher_applier/publisher_id').with_value('20120101')
        is_expected.to contain_watcher_config('watcher_applier/workflow_engine').with_value('taskFloooow')
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
      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          { :watcher_applier_package => 'watcher-applier',
            :applier_service_name    => 'watcher-applier',
          }
        when 'RedHat'
          { :watcher_applier_package => 'openstack-watcher-applier',
            :applier_service_name    => 'openstack-watcher-applier',
          }
        end
      end
      it_behaves_like 'watcher-applier'
    end
  end
end
