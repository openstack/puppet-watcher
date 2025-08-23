# == Class: watcher::decision_engine
#
# === Parameters
#
# [*package_ensure*]
#   (Optional) The state of the package.
#   Defaults to 'present'.
#
# [*enabled*]
#   (Optional) The state of the service
#   Defaults to 'true'.
#
# [*max_audit_workers*]
#   (Optional) The maximum number of threads that can be used to execute
#   audits in pararell.
#   Defaults to $facts['os_service_default']
#
# [*max_general_workers*]
#   (Optional) The maximum number of threads that can be used to execute
#   general tasks in parallel.
#   Defaults to $facts['os_service_default']
#
# [*manage_service*]
#   (Optional) Whether to start/stop the service.
#   Defaults to 'true'.
#
# [*decision_engine_conductor_topic*]
#   (Optional) The topic name used forcontrol events, this topic used
#   for rpc call
#   Defaults to $facts['os_service_default']
#
# [*decision_engine_status_topic*]
#   (Optional) The topic name used for status events, this topic is used
#   so as to notifythe others components of the system
#   Defaults to $facts['os_service_default']
#
# [*decision_engine_notification_topics*]
#   (Optional) The topic names from which notification events will be
#   listened to (list value)
#   Defaults to $facts['os_service_default']
#
# [*decision_engine_publisher_id*]
#   (Optional) The identifier used by watcher module on the message broker
#   Defaults to $facts['os_service_default']
#
# [*decision_engine_workers*]
#   (Optional) The maximum number of threads that can be used to execute
#   strategies
#   Defaults to $facts['os_service_default']
#
# [*planner*]
#   (Optional) The selected planner used to schedule the actions (string value)
#   Defaults to $facts['os_service_default']
#
# [*weights*]
#   (Optional) Hash of weights used to schedule the actions (dict value).
#   The key is an action, value is an order number.
#   Defaults to $facts['os_service_default']
#   Example:
#     { 'change_nova_service_state' => '2',
#       'migrate' => '3', 'nop' => '0', 'sleep' => '1' }
#
#
class watcher::decision_engine (
  $package_ensure                      = 'present',
  Boolean $enabled                     = true,
  Boolean $manage_service              = true,
  $max_audit_workers                   = $facts['os_service_default'],
  $max_general_workers                 = $facts['os_service_default'],
  $decision_engine_conductor_topic     = $facts['os_service_default'],
  $decision_engine_status_topic        = $facts['os_service_default'],
  $decision_engine_notification_topics = $facts['os_service_default'],
  $decision_engine_publisher_id        = $facts['os_service_default'],
  $decision_engine_workers             = $facts['os_service_default'],
  $planner                             = $facts['os_service_default'],
  $weights                             = $facts['os_service_default'],
) {
  include watcher::params
  include watcher::deps

  if $weights =~ Hash {
    $weights_real = join(sort(join_keys_to_values($weights, ':')), ',')
  } else {
    $weights_real = join(any2array($weights), ',')
  }

  package { 'watcher-decision-engine':
    ensure => $package_ensure,
    name   => $watcher::params::decision_engine_package_name,
    tag    => ['openstack', 'watcher-package'],
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }

    service { 'watcher-decision-engine':
      ensure     => $service_ensure,
      name       => $watcher::params::decision_engine_service_name,
      enable     => $enabled,
      hasstatus  => true,
      hasrestart => true,
      tag        => ['watcher-service'],
    }
  }

  watcher_config {
    'watcher_decision_engine/max_audit_workers':   value => $max_audit_workers;
    'watcher_decision_engine/max_general_workers': value => $max_general_workers;
    'watcher_decision_engine/conductor_topic':     value => $decision_engine_conductor_topic;
    'watcher_decision_engine/status_topic':        value => $decision_engine_status_topic;
    'watcher_decision_engine/notification_topics': value => join(any2array($decision_engine_notification_topics), ',');
    'watcher_decision_engine/publisher_id':        value => $decision_engine_publisher_id;
    'watcher_decision_engine/max_workers':         value => $decision_engine_workers;
  }

  watcher_config {
    'watcher_planner/planner':          value => $planner;
    'watcher_planners.default/weights': value => $weights_real;
  }
}
