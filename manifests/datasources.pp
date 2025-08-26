# == Class: watcher::datasources
#
# Configure the datasources options
#
# === Parameters
#
# [*datasources*]
#  (Optional) Datasources to use in order to query the needed metrics.
#  Defaults to $facts['os_service_default']
#
# [*query_max_retries*]
#  (Optional) How many times Watcher is trying to query again.
#  Defaults to $facts['os_service_default']
#
# [*query_interval*]
#  (Optional) How many seconds Watcher should wait to do query again.
#  Defaults to $facts['os_service_default']
#
class watcher::datasources (
  $datasources       = $facts['os_service_default'],
  $query_max_retries = $facts['os_service_default'],
  $query_interval    = $facts['os_service_default'],
) {
  include watcher::deps

  watcher_config {
    'datasources/datasources':       value => join(any2array($datasources), ',');
    'datasources/query_max_retries': value => $query_max_retries;
    'datasources/query_interval':    value => $query_interval;
  }
}
