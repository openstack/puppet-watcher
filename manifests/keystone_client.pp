# == Class: watcher::keystone_client
#
# Configure the keystone_client options
#
# === Parameters
#
# [*endpoint_type*]
#  (Optional) Type of endpoint to use in keystoneclient.
#  Defaults to $::os_service_default
#
# [*region_name*]
#  (Optional) Region in Identify service catalog to use for communication
#  with the OpenStack service.
#  Defaults to $::os_service_default.
#
class watcher::keystone_client (
  $endpoint_type = $::os_service_default,
  $region_name   = $::os_service_default,
) {

  include watcher::deps
  include watcher::params

  watcher_config {
    'keystone_client/endpoint_type': value => $endpoint_type;
    'keystone_client/region_name':   value => $region_name;
  }
}
