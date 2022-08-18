# == Class: watcher::api
#
# Configure Watcher API service.
#
# === Parameters:
#
# All options are optional unless specified otherwise.
# All options defaults to $::os_service_default and
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
#   Defaults to $::os_service_default.
#
# [*max_limit*]
#   (Optional)The maximum number of items returned in a single response from a
#   collection resource.
#   Defaults to $::os_service_default.
#
# [*bind_host*]
#   (Optional) Listen IP for the watcher API server.
#   Defaults to $::os_service_default.
#
# [*workers*]
#   (Optional) Number of worker processors to for the Watcher API service.
#   Defaults to $::os_workers.
#
# [*enable_ssl_api*]
#   (Optional) Enable the integrated stand-alone API to service requests via HTTPS instead
#   of HTTP. If there is a front-end service performing HTTPS offloading from the
#   service, this option should be False; note, you will want to change public
#   API endpoint to represent SSL termination URL with 'public_endpoint' option.
#   Defaults to $::os_service_default.
#
# [*service_name*]
#   (optional) Name of the service that will be providing the
#   server functionality of watcher-api.
#   If the value is 'httpd', this means watcher-api will be a web
#   service, and you must use another class to configure that
#   web service. For example, use class { 'watcher::wsgi::apache'...}
#   to make watcher-api be a web app using apache mod_wsgi.
#   Defaults to '$::watcher::params::api_service_name'
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
# DEPRECATED PARAMETERS
#
# [*validate*]
#   (Optional) Whether to validate the service is working after any service
#   refreshes
#   Defaults to undef
#
# [*validation_options*]
#   (Optional) Service validation options
#   Should be a hash of options defined in openstacklib::service_validation
#   If empty, defaults values are taken from openstacklib function.
#   Require validate set at True.
#   Defaults to undef
#
# [*watcher_client_auth_uri*]
#   (Optional) Public Identity API endpoint.
#   Defaults to undef
#
# [*watcher_client_default_domain_name*]
#   (Optional)domain name to use with v3 API and v2 parameters. It will
#   be used for both the user and project domain in v3 and ignored in v2
#   authentication.
#   Defaults to undef
#
# [*watcher_client_password*]
#   (optional) User's password
#   Defaults to undef
#
# [*watcher_client_username*]
#   (optional) The name of the auth user
#   Defaults to undef
#
# [*watcher_client_auth_url*]
#   Specifies the admin Identity URI for Watcher to use.
#   Defaults to undef
#
# [*watcher_client_project_name*]
#   (Optional) Service project name.
#   Defaults to undef
#
# [*watcher_client_certfile*]
#   (Optional) PEM encoded client certificate cert file.
#   Defaults to undef
#
# [*watcher_client_cafile*]
#   (Optional)PEM encoded Certificate Authority to use when verifying HTTPs
#   connections.
#   Defaults to undef
#
# [*watcher_client_project_domain_name*]
#   (Optional) Domain name containing project.
#   Defaults to undef
#
# [*watcher_client_user_domain_name*]
#   (Optional) User Domain name.
#   Defaults to undef
#
# [*watcher_client_insecure*]
#   (Optional) Verify HTTPS connections.
#   Defaults to undef
#
# [*watcher_client_keyfile*]
#   (Optional) PEM encoded client certificate key file.
#   Defaults to undef
#
# [*watcher_client_auth_type*]
#   (Optional) Authentication type to load.
#   Defaults to undef
#
class watcher::api (
  $package_ensure                     = 'present',
  $enabled                            = true,
  $manage_service                     = true,
  $port                               = $::os_service_default,
  $max_limit                          = $::os_service_default,
  $bind_host                          = $::os_service_default,
  $workers                            = $::os_workers,
  $enable_ssl_api                     = $::os_service_default,
  $service_name                       = $::watcher::params::api_service_name,
  $create_db_schema                   = false,
  $upgrade_db                         = false,
  $auth_strategy                      = 'keystone',
  # DEPRECATED PARAMETERS
  $validate                           = undef,
  $validation_options                 = undef,
  $watcher_client_auth_uri            = undef,
  $watcher_client_default_domain_name = undef,
  $watcher_client_password            = undef,
  $watcher_client_username            = undef,
  $watcher_client_auth_url            = undef,
  $watcher_client_project_name        = undef,
  $watcher_client_certfile            = undef,
  $watcher_client_cafile              = undef,
  $watcher_client_project_domain_name = undef,
  $watcher_client_user_domain_name    = undef,
  $watcher_client_insecure            = undef,
  $watcher_client_keyfile             = undef,
  $watcher_client_auth_type           = undef,
) inherits watcher::params {

  include watcher::policy
  include watcher::deps

  if $validate != undef {
    warning('The watcher::api::validate parameter has been deprecated and has no effect')
  }
  if $validation_options != undef {
    warning('The watcher::api::validation_options parameter has been deprecated and has no effect')
  }

  if $auth_strategy == 'keystone' {
    include watcher::keystone::authtoken
  }

  package { 'watcher-api':
    ensure => $package_ensure,
    name   => $::watcher::params::api_package_name,
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

    if $service_name == $::watcher::params::api_service_name {
      # NOTE(danpawlik) Watcher doesn't support db_sync command.
      service { 'watcher-api':
        ensure     => $service_ensure,
        name       => $::watcher::params::api_service_name,
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
        name   => $::watcher::params::api_service_name,
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

  if $watcher_client_auth_uri != undef {
    warning('The watcher_client_auth_uri is deprecated and has no effect.')
  }
  watcher_config {
    'watcher_clients_auth/auth_uri': ensure => absent;
  }

  if $watcher_client_default_domain_name != undef {
    warning('The watcher_client_default_domain_name parameter is deprecated and has no effect.')
  }

  [ 'password', 'auth_url', 'username', 'project_name', 'project_domain_name',
    'user_domain_anme', 'auth_type', 'insecure', 'keyfile', 'certfile',
    'cafile' ].each |String $client_opt|{
    if getvar("watcher_client_${client_opt}") != undef {
      warning("The watcher_client_${client_opt} parameter is deprecated. \
Use the watcher_clients_auth class instead.")
    }
    include watcher::watcher_clients_auth
  }

}
