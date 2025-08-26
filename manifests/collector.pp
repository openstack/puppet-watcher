# == Class: watcher::collector
#
# Configure the collector options
#
# === Parameters
#
# [*collector_plugins*]
#  (Optional) The cluster data model plugin names
#  Defaults to $facts['os_service_default']
#
# [*api_query_retries*]
#  (Optional) Number of retries before giving up on external service queries.
#  Defaults to $facts['os_service_default']
#
# [*api_query_interval*]
#  (Optional) How many seconds Watcher should wait to do query again.
#  Defaults to $facts['os_service_default']
#
class watcher::collector (
  $collector_plugins  = $facts['os_service_default'],
  $api_query_retries  = $facts['os_service_default'],
  $api_query_interval = $facts['os_service_default'],
) {
  include watcher::deps

  watcher_config {
    'collector/collector_plugins':  value => join(any2array($collector_plugins), ',');
    'collector/api_query_retries':  value => $api_query_retries;
    'collector/api_query_interval': value => $api_query_interval;
  }
}
