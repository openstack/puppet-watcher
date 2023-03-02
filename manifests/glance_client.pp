# == Class: watcher::glance_client
#
# Configure the glance_client options
#
# === Parameters
#
# [*api_version*]
#  (Optional) Version of Glance API to use in glanceclient.
#  Defaults to $facts['os_service_default']
#
# [*endpoint_type*]
#  (Optional) Type of endpoint to use in glanceclient.
#  Defaults to $facts['os_service_default']
#
# [*region_name*]
#  (Optional) Region in Identify service catalog to use for communication
#  with the OpenStack service.
#  Defaults to $facts['os_service_default'].
#
class watcher::glance_client (
  $api_version   = $facts['os_service_default'],
  $endpoint_type = $facts['os_service_default'],
  $region_name   = $facts['os_service_default'],
) {

  include watcher::deps
  include watcher::params

  watcher_config {
    'glance_client/api_version':   value => $api_version;
    'glance_client/endpoint_type': value => $endpoint_type;
    'glance_client/region_name':   value => $region_name;
  }
}
