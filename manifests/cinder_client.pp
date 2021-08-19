# == Class: watcher::cinder_client
#
# Configure the cinder_client options
#
# === Parameters
#
# [*api_version*]
#  (Optional) Version of Cinder API to use in cinderclient.
#  Defaults to $::os_service_default
#
# [*endpoint_type*]
#  (Optional) Type of endpoint to use in cinderclient.
#  Defaults to $::os_service_default
#
# [*region_name*]
#  (Optional) Region in Identify service catalog to use for communication
#  with the OpenStack service.
#  Defaults to $::os_service_default.
#
class watcher::cinder_client (
  $api_version   = $::os_service_default,
  $endpoint_type = $::os_service_default,
  $region_name   = $::os_service_default,
) {

  include watcher::deps
  include watcher::params

  $api_version_real = pick($::watcher::cinder_client_api_version, $api_version)

  watcher_config {
    'cinder_client/api_version':   value => $api_version_real;
    'cinder_client/endpoint_type': value => $endpoint_type;
    'cinder_client/region_name':   value => $region_name;
  }
}