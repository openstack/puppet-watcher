# == Class: watcher::prometheus_client
#
# Configure the prometheus_client options
#
# === Parameters
#
# [*host*]
#  (Required) The hostname of IP address for the prometheus server.
#
# [*port*]
#  (Optional) The port number used by the prometheus server.
#  Defaults to $facts['os_service_default']
#
# [*fqdn_label*]
#  (Optional) The label that Prometheus uses to store the fqdn of exporters.
#  Defaults to $facts['os_service_default']
#
# [*instance_uuid_label*]
#  (Optional) The label that Prometheus uses to store the uuid of OpenStack
#  instances.
#  Defaults to $facts['os_service_default']
#
# [*username*]
#  (Optional) The basic_auth username to use to authenticate with
#  the Prometheus server.
#  Defaults to $facts['os_service_default'].
#
# [*password*]
#  (Optional) The basic_auth password to use to authenticate with
#  the Prometheus server.
#  Defaults to $facts['os_service_default'].
#
class watcher::prometheus_client (
  $host,
  $port                = $facts['os_service_default'],
  $fqdn_label          = $facts['os_service_default'],
  $instance_uuid_label = $facts['os_service_default'],
  $username            = $facts['os_service_default'],
  $password            = $facts['os_service_default'],
) {

  include watcher::deps

  watcher_config {
    'prometheus_client/host':                value => $host;
    'prometheus_client/port':                value => $port;
    'prometheus_client/fqdn_label':          value => $fqdn_label;
    'prometheus_client/instance_uuid_label': value => $instance_uuid_label;
    'prometheus_client/username':            value => $username;
    'prometheus_client/password':            value => $password, secret => true;
  }
}
