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

      it 'configures messaging' do
        is_expected.to contain_oslo__messaging__default('watcher_config').with(
          :transport_url        => '<SERVICE DEFAULT>',
          :rpc_response_timeout => '<SERVICE DEFAULT>',
          :control_exchange     => '<SERVICE DEFAULT>'
        )
        is_expected.to contain_oslo__messaging__rabbit('watcher_config').with(
          :rabbit_use_ssl              => '<SERVICE DEFAULT>',
          :heartbeat_timeout_threshold => '<SERVICE DEFAULT>',
          :heartbeat_rate              => '<SERVICE DEFAULT>',
          :heartbeat_in_pthread        => '<SERVICE DEFAULT>',
          :kombu_reconnect_delay       => '<SERVICE DEFAULT>',
          :kombu_failover_strategy     => '<SERVICE DEFAULT>',
          :amqp_durable_queues         => '<SERVICE DEFAULT>',
          :kombu_compression           => '<SERVICE DEFAULT>',
          :kombu_ssl_ca_certs          => '<SERVICE DEFAULT>',
          :kombu_ssl_certfile          => '<SERVICE DEFAULT>',
          :kombu_ssl_keyfile           => '<SERVICE DEFAULT>',
          :kombu_ssl_version           => '<SERVICE DEFAULT>',
          :rabbit_ha_queues            => '<SERVICE DEFAULT>',
          :rabbit_retry_interval       => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_oslo__messaging__amqp('watcher_config').with(
          :server_request_prefix => '<SERVICE DEFAULT>',
          :broadcast_prefix      => '<SERVICE DEFAULT>',
          :group_request_prefix  => '<SERVICE DEFAULT>',
          :container_name        => '<SERVICE DEFAULT>',
          :idle_timeout          => '<SERVICE DEFAULT>',
          :trace                 => '<SERVICE DEFAULT>',
          :ssl_ca_file           => '<SERVICE DEFAULT>',
          :ssl_cert_file         => '<SERVICE DEFAULT>',
          :ssl_key_file          => '<SERVICE DEFAULT>',
          :sasl_mechanisms       => '<SERVICE DEFAULT>',
          :sasl_config_dir       => '<SERVICE DEFAULT>',
          :sasl_config_name      => '<SERVICE DEFAULT>',
          :username              => '<SERVICE DEFAULT>',
          :password              => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_oslo__messaging__notifications('watcher_config').with(
          :transport_url => '<SERVICE DEFAULT>',
          :driver        => '<SERVICE DEFAULT>',
          :topics        => '<SERVICE DEFAULT>'
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
          :default_transport_url              => 'rabbit://rabbit_user:password@localhost:5673',
          :rpc_response_timeout               => '120',
          :control_exchange                   => 'watcher',
          :rabbit_ha_queues                   => 'true',
          :rabbit_heartbeat_timeout_threshold => '60',
          :rabbit_heartbeat_rate              => '10',
          :rabbit_heartbeat_in_pthread        => true,
          :amqp_durable_queues                => true,
          :kombu_compression                  => 'gzip',
          :kombu_failover_strategy            => 'shuffle',
          :kombu_reconnect_delay              => '5.0',
          :notification_transport_url         => 'rabbit://rabbit_user:password@localhost:5673',
          :notification_driver                => 'messaging',
          :notification_topics                => 'notifications',
        }
      end
      it 'configures messaging' do
        is_expected.to contain_oslo__messaging__default('watcher_config').with(
          :transport_url        => 'rabbit://rabbit_user:password@localhost:5673',
          :rpc_response_timeout => '120',
          :control_exchange     => 'watcher'
        )
        is_expected.to contain_oslo__messaging__rabbit('watcher_config').with(
          :rabbit_use_ssl              => '<SERVICE DEFAULT>',
          :heartbeat_timeout_threshold => '60',
          :heartbeat_rate              => '10',
          :heartbeat_in_pthread        => true,
          :kombu_reconnect_delay       => '5.0',
          :kombu_failover_strategy     => 'shuffle',
          :amqp_durable_queues         => true,
          :kombu_compression           => 'gzip',
          :kombu_ssl_ca_certs          => '<SERVICE DEFAULT>',
          :kombu_ssl_certfile          => '<SERVICE DEFAULT>',
          :kombu_ssl_keyfile           => '<SERVICE DEFAULT>',
          :kombu_ssl_version           => '<SERVICE DEFAULT>',
          :rabbit_ha_queues            => true,
          :rabbit_retry_interval       => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_oslo__messaging__amqp('watcher_config').with(
          :server_request_prefix => '<SERVICE DEFAULT>',
          :broadcast_prefix      => '<SERVICE DEFAULT>',
          :group_request_prefix  => '<SERVICE DEFAULT>',
          :container_name        => '<SERVICE DEFAULT>',
          :idle_timeout          => '<SERVICE DEFAULT>',
          :trace                 => '<SERVICE DEFAULT>',
          :ssl_ca_file           => '<SERVICE DEFAULT>',
          :ssl_cert_file         => '<SERVICE DEFAULT>',
          :ssl_key_file          => '<SERVICE DEFAULT>',
          :sasl_mechanisms       => '<SERVICE DEFAULT>',
          :sasl_config_dir       => '<SERVICE DEFAULT>',
          :sasl_config_name      => '<SERVICE DEFAULT>',
          :username              => '<SERVICE DEFAULT>',
          :password              => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_oslo__messaging__notifications('watcher_config').with(
          :transport_url => 'rabbit://rabbit_user:password@localhost:5673',
          :driver        => 'messaging',
          :topics        => 'notifications'
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

    context 'with overridden amqp parameters' do
      let :params do
        { :default_transport_url => 'amqp://amqp_user:password@localhost:5672',
          :amqp_idle_timeout     => '60',
          :amqp_trace            => true,
          :amqp_ssl_ca_file      => '/etc/ca.cert',
          :amqp_ssl_cert_file    => '/etc/certfile',
          :amqp_ssl_key_file     => '/etc/key',
          :amqp_username         => 'amqp_user',
          :amqp_password         => 'password',
        }
      end

      it 'configures amqp' do
        is_expected.to contain_oslo__messaging__default('watcher_config').with(
          :transport_url => 'amqp://amqp_user:password@localhost:5672',
        )
        is_expected.to contain_oslo__messaging__amqp('watcher_config').with(
          :server_request_prefix => '<SERVICE DEFAULT>',
          :broadcast_prefix      => '<SERVICE DEFAULT>',
          :group_request_prefix  => '<SERVICE DEFAULT>',
          :container_name        => '<SERVICE DEFAULT>',
          :idle_timeout          => '60',
          :trace                 => true,
          :ssl_ca_file           => '/etc/ca.cert',
          :ssl_cert_file         => '/etc/certfile',
          :ssl_key_file          => '/etc/key',
          :sasl_mechanisms       => '<SERVICE DEFAULT>',
          :sasl_config_dir       => '<SERVICE DEFAULT>',
          :sasl_config_name      => '<SERVICE DEFAULT>',
          :username              => 'amqp_user',
          :password              => 'password',
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
