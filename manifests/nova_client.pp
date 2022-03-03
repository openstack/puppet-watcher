# == Class: watcher::nova_client
#
# Configure the nova_client options
#
# === Parameters
#
# [*api_version*]
#  (Optional) Version of Nova API to use in novaclient.
#  Defaults to $::os_service_default
#
# [*endpoint_type*]
#  (Optional) Type of endpoint to use in novaclient.
#  Defaults to $::os_service_default
#
# [*region_name*]
#  (Optional) Region in Identify service catalog to use for communication
#  with the OpenStack service.
#  Defaults to $::os_service_default.
#
class watcher::nova_client (
  $api_version   = $::os_service_default,
  $endpoint_type = $::os_service_default,
  $region_name   = $::os_service_default,
) {

  include watcher::deps
  include watcher::params

  watcher_config {
    'nova_client/api_version':   value => $api_version;
    'nova_client/endpoint_type': value => $endpoint_type;
    'nova_client/region_name':   value => $region_name;
  }
}
