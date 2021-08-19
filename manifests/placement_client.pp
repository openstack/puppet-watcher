# == Class: watcher::placement_client
#
# Configure the placement_client options
#
# === Parameters
#
# [*api_version*]
#  (Optional) Microversion of placement API when using placement service.
#  Defaults to $::os_service_default
#
# [*interface*]
#  (Optional) Type of endpoint when using placement service.
#  Defaults to $::os_service_default
#
# [*region_name*]
#  (Optional) Region in Identify service catalog to use for communication
#  with the OpenStack service.
#  Defaults to $::os_service_default.
#
class watcher::placement_client (
  $api_version = $::os_service_default,
  $interface   = $::os_service_default,
  $region_name = $::os_service_default,
) {

  include watcher::deps
  include watcher::params

  watcher_config {
    'placement_client/api_version': value => $api_version;
    'placement_client/interface':   value => $interface;
    'placement_client/region_name': value => $region_name;
  }
}
