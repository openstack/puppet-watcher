require 'spec_helper'

describe 'watcher' do

  shared_examples 'watcher' do

    context 'with default parameters' do
      let :params do
        { :purge_config => false }
      end

      it { should contain_class('openstacklib::openstackclient') }

      it 'contains the db class' do
        is_expected.to contain_class('watcher::db')
      end

      it 'installs packages' do
        is_expected.to contain_package('watcher').with(
          :name   => platform_params[:watcher_common_package],
          :ensure => 'present',
          :tag    => ['openstack', 'watcher-package']
        )
      end

      it { is_expected.to contain_class('watcher::policy') }
      it { is_expected.to contain_class('watcher::deps') }

      it 'cofigures common options' do
        is_expected.to contain_watcher_config('DEFAULT/host').with_value('<SERVICE DEFAULT>')
      end

      it 'configures messaging' do
        is_expected.to contain_oslo__messaging__default('watcher_config').with(
          :transport_url        => '<SERVICE DEFAULT>',
          :rpc_response_timeout => '<SERVICE DEFAULT>',
          :control_exchange     => '<SERVICE DEFAULT>'
        )
        is_expected.to contain_oslo__messaging__rabbit('watcher_config').with(
          :rabbit_use_ssl                  => '<SERVICE DEFAULT>',
          :heartbeat_timeout_threshold     => '<SERVICE DEFAULT>',
          :heartbeat_rate                  => '<SERVICE DEFAULT>',
          :kombu_reconnect_delay           => '<SERVICE DEFAULT>',
          :kombu_failover_strategy         => '<SERVICE DEFAULT>',
          :amqp_durable_queues             => '<SERVICE DEFAULT>',
          :kombu_compression               => '<SERVICE DEFAULT>',
          :kombu_ssl_ca_certs              => '<SERVICE DEFAULT>',
          :kombu_ssl_certfile              => '<SERVICE DEFAULT>',
          :kombu_ssl_keyfile               => '<SERVICE DEFAULT>',
          :kombu_ssl_version               => '<SERVICE DEFAULT>',
          :rabbit_ha_queues                => '<SERVICE DEFAULT>',
          :rabbit_quorum_queue             => '<SERVICE DEFAULT>',
          :rabbit_transient_quorum_queue   => '<SERVICE DEFAULT>',
          :rabbit_quorum_delivery_limit    => '<SERVICE DEFAULT>',
          :rabbit_quorum_max_memory_length => '<SERVICE DEFAULT>',
          :rabbit_quorum_max_memory_bytes  => '<SERVICE DEFAULT>',
          :use_queue_manager               => '<SERVICE DEFAULT>',
          :rabbit_stream_fanout            => '<SERVICE DEFAULT>',
          :enable_cancel_on_failover       => '<SERVICE DEFAULT>',
          :rabbit_retry_interval           => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_oslo__messaging__notifications('watcher_config').with(
          :transport_url => '<SERVICE DEFAULT>',
          :driver        => '<SERVICE DEFAULT>',
          :topics        => '<SERVICE DEFAULT>',
          :retry         => '<SERVICE DEFAULT>',
        )
      end

      it 'passes purge to resource' do
        is_expected.to contain_resources('watcher_config').with({
          :purge => false
        })
      end

    end

    context 'with overridden parameters' do
      let :params do
        {
          :host                               => 'localhost',
          :default_transport_url              => 'rabbit://rabbit_user:password@localhost:5673',
          :rpc_response_timeout               => '120',
          :control_exchange                   => 'watcher',
          :rabbit_ha_queues                   => 'true',
          :rabbit_quorum_queue                => true,
          :rabbit_transient_quorum_queue      => true,
          :rabbit_quorum_delivery_limit       => 3,
          :rabbit_quorum_max_memory_length    => 5,
          :rabbit_quorum_max_memory_bytes     => 1073741824,
          :rabbit_use_queue_manager           => true,
          :rabbit_stream_fanout               => true,
          :rabbit_enable_cancel_on_failover   => false,
          :rabbit_heartbeat_timeout_threshold => '60',
          :rabbit_heartbeat_rate              => '10',
          :amqp_durable_queues                => true,
          :kombu_compression                  => 'gzip',
          :kombu_failover_strategy            => 'shuffle',
          :kombu_reconnect_delay              => '5.0',
          :notification_transport_url         => 'rabbit://rabbit_user:password@localhost:5673',
          :notification_driver                => 'messaging',
          :notification_topics                => 'notifications',
          :notification_retry                 => 10,
        }
      end

      it 'cofigures common options' do
        is_expected.to contain_watcher_config('DEFAULT/host').with_value('localhost')
      end
      it 'configures messaging' do
        is_expected.to contain_oslo__messaging__default('watcher_config').with(
          :transport_url        => 'rabbit://rabbit_user:password@localhost:5673',
          :rpc_response_timeout => '120',
          :control_exchange     => 'watcher'
        )
        is_expected.to contain_oslo__messaging__rabbit('watcher_config').with(
          :rabbit_use_ssl                  => '<SERVICE DEFAULT>',
          :heartbeat_timeout_threshold     => '60',
          :heartbeat_rate                  => '10',
          :kombu_reconnect_delay           => '5.0',
          :kombu_failover_strategy         => 'shuffle',
          :amqp_durable_queues             => true,
          :kombu_compression               => 'gzip',
          :kombu_ssl_ca_certs              => '<SERVICE DEFAULT>',
          :kombu_ssl_certfile              => '<SERVICE DEFAULT>',
          :kombu_ssl_keyfile               => '<SERVICE DEFAULT>',
          :kombu_ssl_version               => '<SERVICE DEFAULT>',
          :rabbit_ha_queues                => true,
          :rabbit_quorum_queue             => true,
          :rabbit_transient_quorum_queue   => true,
          :rabbit_quorum_delivery_limit    => 3,
          :rabbit_quorum_max_memory_length => 5,
          :rabbit_quorum_max_memory_bytes  => 1073741824,
          :use_queue_manager               => true,
          :rabbit_stream_fanout            => true,
          :enable_cancel_on_failover       => false,
          :rabbit_retry_interval           => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_oslo__messaging__notifications('watcher_config').with(
          :transport_url => 'rabbit://rabbit_user:password@localhost:5673',
          :driver        => 'messaging',
          :topics        => 'notifications',
          :retry         => 10,
        )
      end

    end

    context 'with rabbit ssl enabled with kombu' do
      let :params do
        { :rabbit_use_ssl     => true,
          :kombu_ssl_ca_certs => '/etc/ca.cert',
          :kombu_ssl_certfile => '/etc/certfile',
          :kombu_ssl_keyfile  => '/etc/key',
          :kombu_ssl_version  => 'TLSv1', }
      end

      it 'configures rabbit' do
        is_expected.to contain_oslo__messaging__rabbit('watcher_config').with(
          :rabbit_use_ssl     => true,
          :kombu_ssl_ca_certs => '/etc/ca.cert',
          :kombu_ssl_certfile => '/etc/certfile',
          :kombu_ssl_keyfile  => '/etc/key',
          :kombu_ssl_version  => 'TLSv1',
        )
      end
    end

    context 'with rabbit ssl enabled without kombu' do
      let :params do
        { :rabbit_use_ssl     => true, }
      end

      it 'configures rabbit' do
        is_expected.to contain_oslo__messaging__rabbit('watcher_config').with(
          :rabbit_use_ssl     => true,
          :kombu_ssl_ca_certs => '<SERVICE DEFAULT>',
          :kombu_ssl_certfile => '<SERVICE DEFAULT>',
          :kombu_ssl_keyfile  => '<SERVICE DEFAULT>',
          :kombu_ssl_version  => '<SERVICE DEFAULT>',
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
      let(:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          { :watcher_common_package => 'watcher-common' }
        when 'RedHat'
          { :watcher_common_package => 'openstack-watcher-common' }
        end
      end
      it_behaves_like 'watcher'
    end
  end

end
