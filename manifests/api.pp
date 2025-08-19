# == Class: watcher::api
#
# Configure Watcher API service.
#
# === Parameters:
#
# All options are optional unless specified otherwise.
# All options defaults to $facts['os_service_default'] and
# the default values from the service are used.
#
# === Watcher configuration
#
# [*package_ensure*]
#   (Optional)Ensure state of the openstackclient package.
#   Defaults to 'present'.
#
# [*enabled*]
#   (Optional) Whether the watcher api service will be run
#   Defaults to true
#
# [*manage_service*]
#   (Optional) Whether the service should be managed by Puppet.
#   Defaults to true.
#
# [*port*]
#   (Optional) The port on which the watcher API will listen.
#   Defaults to $facts['os_service_default'].
#
# [*max_limit*]
#   (Optional)The maximum number of items returned in a single response from a
#   collection resource.
#   Defaults to $facts['os_service_default'].
#
# [*bind_host*]
#   (Optional) Listen IP for the watcher API server.
#   Defaults to $facts['os_service_default'].
#
# [*workers*]
#   (Optional) Number of worker processors to for the Watcher API service.
#   Defaults to $facts['os_workers'].
#
# [*enable_ssl_api*]
#   (Optional) Enable the integrated stand-alone API to service requests via HTTPS instead
#   of HTTP. If there is a front-end service performing HTTPS offloading from the
#   service, this option should be False; note, you will want to change public
#   API endpoint to represent SSL termination URL with 'public_endpoint' option.
#   Defaults to $facts['os_service_default'].
#
# [*service_name*]
#   (optional) Name of the service that will be providing the
#   server functionality of watcher-api.
#   If the value is 'httpd', this means watcher-api will be a web
#   service, and you must use another class to configure that
#   web service. For example, use class { 'watcher::wsgi::apache'...}
#   to make watcher-api be a web app using apache mod_wsgi.
#   Defaults to '$watcher::params::api_service_name'
#
# === DB management
#
# [*create_db_schema*]
#   (Optional) Run watcher-db-manage create_schema on api nodes after
#   installing the package.
#   Defaults to false
#
# [*upgrade_db*]
#   (Optional) Run watcher-db-manage upgrade on api nodes after
#   installing the package.
#   Defaults to false
#
# [*auth_strategy*]
#   (optional) Type of authentication to be used.
#   Defaults to 'keystone'
#
class watcher::api (
  $package_ensure           = 'present',
  Boolean $enabled          = true,
  Boolean $manage_service   = true,
  $port                     = $facts['os_service_default'],
  $max_limit                = $facts['os_service_default'],
  $bind_host                = $facts['os_service_default'],
  $workers                  = $facts['os_workers'],
  $enable_ssl_api           = $facts['os_service_default'],
  $service_name             = $watcher::params::api_service_name,
  Boolean $create_db_schema = false,
  Boolean $upgrade_db       = false,
  $auth_strategy            = 'keystone',
) inherits watcher::params {

  include watcher::policy
  include watcher::deps

  if $auth_strategy == 'keystone' {
    include watcher::keystone::authtoken
  }

  package { 'watcher-api':
    ensure => $package_ensure,
    name   => $watcher::params::api_package_name,
    tag    => ['openstack', 'watcher-package'],
  }

  if $create_db_schema {
    include watcher::db::create_schema
  }

  if $upgrade_db {
    include watcher::db::upgrade
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }

    if $service_name == $watcher::params::api_service_name {
      # NOTE(danpawlik) Watcher doesn't support db_sync command.
      service { 'watcher-api':
        ensure     => $service_ensure,
        name       => $watcher::params::api_service_name,
        enable     => $enabled,
        hasstatus  => true,
        hasrestart => true,
        tag        => [ 'watcher-service',
                        'watcher-db-manage-create_schema',
                        'watcher-db-manage-upgrade'],
      }
    } elsif $service_name == 'httpd' {
      service { 'watcher-api':
        ensure => 'stopped',
        name   => $watcher::params::api_service_name,
        enable => false,
        tag    => [ 'watcher-service',
                    'watcher-db-manage-create_schema',
                    'watcher-db-manage-upgrade'],
      }

      # we need to make sure watcher-api/eventlet is stopped before trying to start apache
      Service['watcher-api'] -> Service[$service_name]
    } else {
      fail("Invalid service_name. Either watcher/openstack-watcher-api for running \
as a standalone service, or httpd for being run by a httpd server")
    }
  }

  watcher_config {
    'api/port':           value => $port;
    'api/max_limit':      value => $max_limit;
    'api/host':           value => $bind_host;
    'api/workers':        value => $workers;
    'api/enable_ssl_api': value => $enable_ssl_api;
  }
}
