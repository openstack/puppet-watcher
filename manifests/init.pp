# == Class: watcher
#
# Full description of class watcher here.
#
# === Parameters:
#
# [*use_ssl*]
#   (required) Enable SSL on the API server.
#   Defaults to false.
#
# [*package_ensure*]
#  (optional) Whether the watcher api package will be installed
#  Defaults to 'present'
#
# [*rabbit_login_method*]
#   (optional) The RabbitMQ login method. (string value)
#   Defaults to $facts['os_service_default']
#
# [*rabbit_retry_interval*]
#   (Optional) How frequently to retry connecting with RabbitMQ.
#   (integer value)
#   Defaults to $facts['os_service_default']
#
# [*rabbit_retry_backoff*]
#   (Optional) How long to backoff for between retries when connecting
#   to RabbitMQ. (integer value)
#   Defaults to $facts['os_service_default']
#
# [*rabbit_interval_max*]
#   (Optional) Maximum interval of RabbitMQ connection retries. (integer value)
#   Defaults to $facts['os_service_default']
#
# [*rabbit_use_ssl*]
#   (optional) Connect over SSL for RabbitMQ.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_heartbeat_rate*]
#   (optional) ow often times during the heartbeat_timeout_threshold we
#   check the heartbeat.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_heartbeat_in_pthread*]
#   (Optional) EXPERIMENTAL: Run the health check heartbeat thread
#   through a native python thread. By default if this
#   option isn't provided the  health check heartbeat will
#   inherit the execution model from the parent process. By
#   example if the parent process have monkey patched the
#   stdlib by using eventlet/greenlet then the heartbeat
#   will be run through a green thread.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_ha_queues*]
#   (optional) Use HA queues in RabbitMQ (x-ha-policy: all). If you change this
#   option, you must wipe the RabbitMQ database.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_transient_queues_ttl*]
#   (Optional) Positive integer representing duration in seconds for
#   queue TTL (x-expires). Queues which are unused for the duration
#   of the TTL are automatically deleted.
#   The parameter affects only reply and fanout queues. (integer value)
#   Min to 1
#   Defaults to $facts['os_service_default']
#
# [*rabbit_heartbeat_timeout_threshold*]
#   (Optional) Number of seconds after which the Rabbit broker is
#   considered down if heartbeat's keep-alive fails
#   (0 disable the heartbeat). EXPERIMENTAL. (integer value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_ca_certs*]
#   (optional) SSL certification authority file (valid only if SSL enabled).
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_certfile*]
#   (optional) SSL cert file (valid only if SSL enabled).
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_keyfile*]
#   (optional) SSL key file (valid only if SSL enabled).
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_version*]
#   (optional) SSL version to use (valid only if SSL enabled). Valid values are
#   TLSv1 and SSLv23. SSLv2, SSLv3, TLSv1_1, and TLSv1_2 may be
#   available on some distributions.
#   Defaults to $facts['os_service_default']
#
# [*kombu_reconnect_delay*]
#   (optional) How long to wait before reconnecting in response to an AMQP
#   consumer cancel notification.
#   Defaults to $facts['os_service_default']
#
# [*kombu_missing_consumer_retry_timeout*]
#  (optional)How long to wait a missing client beforce abandoning to send it
#   its replies. This value should not be longer than rpc_response_timeout.
#   Defaults to $facts['os_service_default']
#
# [*kombu_failover_strategy*]
#   (Optional) Determines how the next RabbitMQ node is chosen in case the one
#   we are currently connected to becomes unavailable. Takes effect only if
#   more than one RabbitMQ node is provided in config. (string value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_compression*]
#   (optional) Possible values are: gzip, bz2. If not set compression will not
#   be used. This option may notbe available in future versions. EXPERIMENTAL.
#   (string value)
#   Defaults to $facts['os_service_default']
#
# [*amqp_durable_queues*]
#   (optional) Use durable queues in AMQP.
#   Defaults to $facts['os_service_default']
#
# [*default_transport_url*]
#   (Optional) A URL representing the messaging driver to use and its full
#   configuration. If not set, we fall back to the rpc_backend option
#   and driver specific configuration.
#   Defaults to $facts['os_service_default']
#
# [*rpc_response_timeout*]
#  (Optional) Seconds to wait for a response from a call.
#  Defaults to $facts['os_service_default']
#
# [*control_exchange*]
#   (Optional) The default exchange under which topics are scoped. May be
#   overridden by an exchange name specified in the transport_url
#   option.
#   Defaults to $facts['os_service_default']
#
# [*amqp_password*]
#   (Optional) Password for message broker authentication.
#   Defaults to $facts['os_service_default']
#
# [*amqp_username*]
#   (Optional) User name for message broker authentication.
#   Defaults to $facts['os_service_default']
#
# [*amqp_ssl_ca_file*]
#   (Optional) CA certificate PEM file to verify server certificate.
#   Defaults to $facts['os_service_default']
#
# [*amqp_ssl_key_file*]
#   (Optional) Private key PEM file used to sign cert_file certificate.
#   Defaults to $facts['os_service_default']
#
# [*amqp_container_name*]
#   (Optional) Name for the AMQP container.
#   Defaults to $facts['os_service_default']
#
# [*amqp_sasl_mechanisms*]
#   (Optional) Space separated list of acceptable SASL mechanisms.
#   Defaults to $facts['os_service_default']
#
# [*amqp_server_request_prefix*]
#   (Optional) Address prefix used when sending to a specific server.
#   Defaults to $facts['os_service_default']
#
# [*amqp_ssl_key_password*]
#   (Optional) Password for decrypting ssl_key_file (if encrypted).
#   Defaults to $facts['os_service_default']
#
# [*amqp_idle_timeout*]
#   (Optional) Timeout for inactive connections (in seconds).
#   Defaults to $facts['os_service_default']
#
# [*amqp_ssl_cert_file*]
#   (Optional) Identifying certificate PEM file to present to clients.
#   Defaults to $facts['os_service_default']
#
# [*amqp_broadcast_prefix*]
#   (Optional) Address prefix used when broadcasting to all servers.
#   Defaults to $facts['os_service_default']
#
# [*amqp_trace*]
#   (Optional) Debug: dump AMQP frames to stdout.
#   Defaults to $facts['os_service_default']
#
# [*amqp_sasl_config_name*]
#   (Optional) Name of configuration file (without .conf suffix).
#   Defaults to $facts['os_service_default']
#
# [*amqp_sasl_config_dir*]
#   (Optional) Path to directory that contains the SASL configuration.
#   Defaults to $facts['os_service_default']
#
# [*amqp_group_request_prefix*]
#   (Optional) Address prefix when sending to any server in group.
#   Defaults to $facts['os_service_default']
#
# [*notification_transport_url*]
#  (optional) A URL representing the messaging driver to use for notifications
#  and its full configuration. Transport URLs take the form:
#    transport://user:pass@host1:port[,hostN:portN]/virtual_host
#  Defaults to $facts['os_service_default']
#
# [*notification_driver*]
#  (optional) Driver or drivers to handle sending notifications.
#  Value can be a string or a list.
#  Defaults to $facts['os_service_default']
#
# [*notification_topics*]
#  (optional) AMQP topic used for OpenStack notifications
#  Defaults to $facts['os_service_default']
#
# [*purge_config*]
#   (optional) Whether to set only the specified config options
#   in the watcher config.
#   Defaults to false.
#
# === Authors
#
# Daniel Pawlik  <daniel.pawlik@corp.ovh.com>
#
class watcher (
  $purge_config                         = false,
  $use_ssl                              = false,
  $package_ensure                       = 'present',
  $rabbit_login_method                  = $facts['os_service_default'],
  $rabbit_retry_interval                = $facts['os_service_default'],
  $rabbit_retry_backoff                 = $facts['os_service_default'],
  $rabbit_interval_max                  = $facts['os_service_default'],
  $rabbit_use_ssl                       = $facts['os_service_default'],
  $rabbit_heartbeat_rate                = $facts['os_service_default'],
  $rabbit_heartbeat_in_pthread          = $facts['os_service_default'],
  $rabbit_ha_queues                     = $facts['os_service_default'],
  $rabbit_transient_queues_ttl          = $facts['os_service_default'],
  $rabbit_heartbeat_timeout_threshold   = $facts['os_service_default'],
  $kombu_ssl_ca_certs                   = $facts['os_service_default'],
  $kombu_ssl_certfile                   = $facts['os_service_default'],
  $kombu_ssl_keyfile                    = $facts['os_service_default'],
  $kombu_ssl_version                    = $facts['os_service_default'],
  $kombu_reconnect_delay                = $facts['os_service_default'],
  $kombu_missing_consumer_retry_timeout = $facts['os_service_default'],
  $kombu_failover_strategy              = $facts['os_service_default'],
  $kombu_compression                    = $facts['os_service_default'],
  $amqp_durable_queues                  = $facts['os_service_default'],
  $default_transport_url                = $facts['os_service_default'],
  $rpc_response_timeout                 = $facts['os_service_default'],
  $control_exchange                     = $facts['os_service_default'],
  # amqp
  $amqp_username                        = $facts['os_service_default'],
  $amqp_password                        = $facts['os_service_default'],
  $amqp_ssl_ca_file                     = $facts['os_service_default'],
  $amqp_ssl_key_file                    = $facts['os_service_default'],
  $amqp_container_name                  = $facts['os_service_default'],
  $amqp_sasl_mechanisms                 = $facts['os_service_default'],
  $amqp_server_request_prefix           = $facts['os_service_default'],
  $amqp_ssl_key_password                = $facts['os_service_default'],
  $amqp_idle_timeout                    = $facts['os_service_default'],
  $amqp_ssl_cert_file                   = $facts['os_service_default'],
  $amqp_broadcast_prefix                = $facts['os_service_default'],
  $amqp_trace                           = $facts['os_service_default'],
  $amqp_sasl_config_name                = $facts['os_service_default'],
  $amqp_sasl_config_dir                 = $facts['os_service_default'],
  $amqp_group_request_prefix            = $facts['os_service_default'],
  # messaging
  $notification_transport_url           = $facts['os_service_default'],
  $notification_driver                  = $facts['os_service_default'],
  $notification_topics                  = $facts['os_service_default'],
) {

  include openstacklib::openstackclient

  include watcher::deps
  include watcher::params
  include watcher::policy
  include watcher::db

  package { 'watcher':
    ensure => $package_ensure,
    name   => $::watcher::params::common_package_name,
    tag    => ['openstack', 'watcher-package'],
  }

  resources { 'watcher_config':
    purge  => $purge_config,
  }

  oslo::messaging::rabbit { 'watcher_config':
    amqp_durable_queues                  => $amqp_durable_queues,
    kombu_ssl_version                    => $kombu_ssl_version,
    kombu_ssl_keyfile                    => $kombu_ssl_keyfile,
    kombu_ssl_certfile                   => $kombu_ssl_certfile,
    kombu_ssl_ca_certs                   => $kombu_ssl_ca_certs,
    kombu_reconnect_delay                => $kombu_reconnect_delay,
    kombu_missing_consumer_retry_timeout => $kombu_missing_consumer_retry_timeout,
    kombu_failover_strategy              => $kombu_failover_strategy,
    kombu_compression                    => $kombu_compression,
    rabbit_use_ssl                       => $rabbit_use_ssl,
    rabbit_login_method                  => $rabbit_login_method,
    rabbit_retry_interval                => $rabbit_retry_interval,
    rabbit_retry_backoff                 => $rabbit_retry_backoff,
    rabbit_interval_max                  => $rabbit_interval_max,
    rabbit_ha_queues                     => $rabbit_ha_queues,
    rabbit_transient_queues_ttl          => $rabbit_transient_queues_ttl,
    heartbeat_timeout_threshold          => $rabbit_heartbeat_timeout_threshold,
    heartbeat_rate                       => $rabbit_heartbeat_rate,
    heartbeat_in_pthread                 => $rabbit_heartbeat_in_pthread,
  }

  oslo::messaging::amqp { 'watcher_config':
    username              => $amqp_username,
    password              => $amqp_password,
    server_request_prefix => $amqp_server_request_prefix,
    broadcast_prefix      => $amqp_broadcast_prefix,
    group_request_prefix  => $amqp_group_request_prefix,
    container_name        => $amqp_container_name,
    idle_timeout          => $amqp_idle_timeout,
    trace                 => $amqp_trace,
    ssl_ca_file           => $amqp_ssl_ca_file,
    ssl_cert_file         => $amqp_ssl_cert_file,
    ssl_key_file          => $amqp_ssl_key_file,
    ssl_key_password      => $amqp_ssl_key_password,
    sasl_mechanisms       => $amqp_sasl_mechanisms,
    sasl_config_dir       => $amqp_sasl_config_dir,
    sasl_config_name      => $amqp_sasl_config_name,
  }

  oslo::messaging::default { 'watcher_config':
    transport_url        => $default_transport_url,
    rpc_response_timeout => $rpc_response_timeout,
    control_exchange     => $control_exchange,
  }

  oslo::messaging::notifications { 'watcher_config':
    transport_url => $notification_transport_url,
    driver        => $notification_driver,
    topics        => $notification_topics,
  }
}

