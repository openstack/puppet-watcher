require 'spec_helper'

describe 'watcher::decision_engine' do

  shared_examples 'watcher-decision-engine' do

    context 'with default parameters' do

      it 'installs packages' do
        is_expected.to contain_package('watcher-decision-engine').with(
          :name   => platform_params[:watcher_decision_engine_package],
          :ensure => 'present',
          :tag    => ['openstack', 'watcher-package']
        )
      end

      it 'configures watcher decision engine service' do
        is_expected.to contain_watcher_config('watcher_decision_engine/conductor_topic').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('watcher_decision_engine/status_topic').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('watcher_decision_engine/notification_topics').with_value(['<SERVICE DEFAULT>'])
        is_expected.to contain_watcher_config('watcher_decision_engine/publisher_id').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('watcher_decision_engine/max_workers').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('watcher_planner/planner').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_watcher_config('watcher_planners.default/weights').with_value('<SERVICE DEFAULT>')
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

      it 'configures watcher decision engine service' do
        is_expected.to contain_service('watcher-decision-engine').with(
          :ensure     => (params[:manage_service] && params[:enabled]) ? 'running' : 'stopped',
          :name       => platform_params[:decision_engine_service_name],
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
          :package_ensure                      => '2012.1.1-15.el6',
          :decision_engine_conductor_topic     => 'test_conductor_topic',
          :decision_engine_status_topic        => 'niceTopic',
          :decision_engine_notification_topics => ['topic_1','topic_2'],
          :decision_engine_publisher_id        => '123456',
          :decision_engine_workers             => '10',
          :planner                             => 'NoPlanner',
          :weights                             => {'foo'  => 'fooValue',
                                               'foo2' => 'fooValue2'},
        }
      end
      it 'configures watcher decision engine' do
        is_expected.to contain_watcher_config('watcher_decision_engine/conductor_topic').with_value('test_conductor_topic')
        is_expected.to contain_watcher_config('watcher_decision_engine/status_topic').with_value('niceTopic')
        is_expected.to contain_watcher_config('watcher_decision_engine/notification_topics').with_value(['topic_1','topic_2'])
        is_expected.to contain_watcher_config('watcher_decision_engine/publisher_id').with_value('123456')
        is_expected.to contain_watcher_config('watcher_decision_engine/max_workers').with_value('10')
        is_expected.to contain_watcher_config('watcher_planner/planner').with_value('NoPlanner')
        is_expected.to contain_watcher_config('watcher_planners.default/weights').with_value('foo2:fooValue2,foo:fooValue')
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
          { :watcher_decision_engine_package => 'watcher-decision-engine',
            :decision_engine_service_name    => 'watcher-decision-engine',
          }
        when 'RedHat'
          { :watcher_decision_engine_package => 'openstack-watcher-decision-engine',
            :decision_engine_service_name    => 'openstack-watcher-decision-engine',
          }
        end
      end
      it_behaves_like 'watcher-decision-engine'
    end
  end
end
