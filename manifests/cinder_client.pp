# == Class: watcher::cinder_client
#
# Configure the cinder_client options
#
# === Parameters
#
# [*api_version*]
#  (Optional) Version of Cinder API to use in cinderclient.
#  Defaults to $facts['os_service_default']
#
# [*endpoint_type*]
#  (Optional) Type of endpoint to use in cinderclient.
#  Defaults to $facts['os_service_default']
#
# [*region_name*]
#  (Optional) Region in Identify service catalog to use for communication
#  with the OpenStack service.
#  Defaults to $facts['os_service_default'].
#
class watcher::cinder_client (
  $api_version   = $facts['os_service_default'],
  $endpoint_type = $facts['os_service_default'],
  $region_name   = $facts['os_service_default'],
) {
  include watcher::deps

  watcher_config {
    'cinder_client/api_version':   value => $api_version;
    'cinder_client/endpoint_type': value => $endpoint_type;
    'cinder_client/region_name':   value => $region_name;
  }
}
