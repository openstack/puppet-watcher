# == Class: watcher::neutron_client
#
# Configure the neutron_client options
#
# === Parameters
#
# [*api_version*]
#  (Optional) Version of Neutron API to use in neutronclient.
#  Defaults to $facts['os_service_default']
#
# [*endpoint_type*]
#  (Optional) Type of endpoint to use in neutronclient.
#  Defaults to $facts['os_service_default']
#
# [*region_name*]
#  (Optional) Region in Identify service catalog to use for communication
#  with the OpenStack service.
#  Defaults to $facts['os_service_default'].
#
class watcher::neutron_client (
  $api_version   = $facts['os_service_default'],
  $endpoint_type = $facts['os_service_default'],
  $region_name   = $facts['os_service_default'],
) {

  include watcher::deps
  include watcher::params

  watcher_config {
    'neutron_client/api_version':   value => $api_version;
    'neutron_client/endpoint_type': value => $endpoint_type;
    'neutron_client/region_name':   value => $region_name;
  }
}
