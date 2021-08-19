# == Class: watcher::gnocchi_client
#
# Configure the gnocchi_client options
#
# === Parameters
#
# [*api_version*]
#  (Optional) Version of Gnocchi API to use in gnocchiclient.
#  Defaults to $::os_service_default
#
# [*endpoint_type*]
#  (Optional) Type of endpoint to use in gnocchiclient.
#  Defaults to $::os_service_default
#
# [*region_name*]
#  (Optional) Region in Identify service catalog to use for communication
#  with the OpenStack service.
#  Defaults to $::os_service_default.
#
class watcher::gnocchi_client (
  $api_version   = $::os_service_default,
  $endpoint_type = $::os_service_default,
  $region_name   = $::os_service_default,
) {

  include watcher::deps
  include watcher::params

  watcher_config {
    'gnocchi_client/api_version':   value => $api_version;
    'gnocchi_client/endpoint_type': value => $endpoint_type;
    'gnocchi_client/region_name':   value => $region_name;
  }
}
