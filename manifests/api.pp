# == Class: watcher::api
#
# Configure Watcher API service.
#
# === Parameters:
#
# [*keystone_password*]
#   (required) Password to create for the service user
#
# [*keystone_tenant*]
#   (optional) The tenant of the auth user
#   Defaults to services
#
# [*keystone_username*]
#   (optional) The name of the auth user
#   Defaults to watcher.
#
# [*auth_uri*]
#   (Optional) Public Identity API endpoint.
#   Defaults to 'http://localhost:5000/'
#
# [*auth_url*]
#   Specifies the admin Identity URI for Watcher to use.
#   Default 'http://localhost:35357/'
#
# [*package_ensure*]
#   Ensure state of the openstackclient package.
#   Optional.
#   Defaults to 'present'.
#
# [*enabled*]
#   (optional) Whether the watcher api service will be run
#   Defaults to true
#
# [*validate*]
#   (optional) Whether to validate the service is working after any service
#   refreshes
#   Defaults to false
#
# [*watcher_api_port*]
#  (optional) The port on which the watcher API will listen.
#  Defaults to 9322.
#
# [*watcher_api_max_limit*]
#  (optional)The maximum number of items returned in a single response from a
#  collection resource.
#  Defaults to $::os_service_default
#
# [*watcher_api_bind_host*]
#  (optional) Listen IP for the watcher API server.
#  Defaults to '0.0.0.0'.
#
# [*keystone_auth_version*]
#   (optional) API version of the admin Identity API endpoint.
#   Defaults to '3'.
#
# [*keystone_project_name*]
#   (optional) Service project name
#   Defaults to 'service'
#
# [*keystone_project_domain_name*]
#   (optional) Name of domain for $project_name
#   Defaults to 'Default'.
#
# [*keystone_delay_auth_decision*]
#  (optional) Do not handle authorization requests within the middleware, but
#  delegate the authorization decision to downstream WSGI components.
#  Defaults to $::os_service_default
#
# [*keystone_http_connect_timeout*]
#  (optional) Request timeout value for communicating with Identity API server.
#  Defaults to $::os_service_default
#
# [*keystone_http_request_max_retries*]
#  (optional) How many times are we trying to reconnect when communicating with
#  Identity API Server.
#  Defaults to $::os_service_default
#
# [*keystone_swift_cache*]
#  (optional) Env key for the swift cache.
#  Defaults to $::os_service_default
#
# [*keystone_certfile*]
#  (optional) Required if identity server requires client certificate.
#  Defaults to $::os_service_default
#
# [*keystone_keyfile*]
#  (optional)Required if identity server requires client certificate.
#  Defaults to $::os_service_default
#
# [*keystone_cafile*]
#  (optional) A PEM encoded Certificate Authority to use when verifying HTTPs
#  connections.
#  Defaults to $::os_service_default
#
# [*keystone_auth_type*]
#  (optional) Authentication type to load.
#  Defaults to 'password'.
#
# [*keystone_insecure*]
#  (optional) Verify HTTPS connections.
#  Defaults to $::os_service_default
#
# [*keystone_region_name*]
#   (optional) The keystone region name. Default is unset.
#   Defaults to $::os_service_default
#
# [*keystone_signing_dir*]
#   (optional) Directory used to cache files related to PKI tokens.
#   Defaults to '/var/cache/watcher'
#
# [*keystone_hash_algorithms*]
#  (optional) Hash algorithms to use for hashing PKI tokens.
#  Defaults to $::os_service_default
#
# [*watcher_client_default_domain_name*]
#  (optional)domain name to use with v3 API and v2 parameters. It will
#  be used for both the user and project domain in v3 and ignored in v2
#  authentication.
#  Defaults to $::os_service_default
#
# [*watcher_client_project_name*]
#  (optional) Service project name.
#  Defaults to undef
#
# [*watcher_client_certfile*]
#  (optional) PEM encoded client certificate cert file.
#  Defaults to undef
#
# [*watcher_client_cafile*]
#  (optional)PEM encoded Certificate Authority to use when verifying HTTPs
#   connections.
#   Defaults to undef
#
# [*watcher_client_project_domain_name*]
#  (optional) Domain name containing project.
#  Defaults to undef
#
# [*watcher_client_insecure*]
#  (optional) Verify HTTPS connections.
#  Defaults to undef
#
# [*watcher_client_keyfile*]
#  (optional) PEM encoded client certificate key file.
#  Defaults to undef
#
# [*watcher_client_auth_type*]
#  (optional) Authentication type to load.
#  Defaults to undef
#
# [*watcher_client_username*]
#  (optional) Keystone username for watcher client. Decision engine works on
#  this variable.
#  Defaults to undef
#
# [*watcher_client_password*]
#  (optional) Keystone password for watcher client.
#  Defaults to undef
#
# [*validation_options*]
#   (optional) Service validation options
#   Should be a hash of options defined in openstacklib::service_validation
#   If empty, defaults values are taken from openstacklib function.
#   Require validate set at True.
#   Defaults to {}
#
class watcher::api (
  $keystone_password,
  $keystone_tenant                    = 'services',
  $keystone_username                  = 'watcher',
  $auth_uri                           = 'http://localhost:5000/',
  $auth_url                           = 'http://localhost:35357/',
  $package_ensure                     = 'present',
  $enabled                            = true,
  $validate                           = false,
  $watcher_api_port                   = '9322',
  $watcher_api_max_limit              = $::os_service_default,
  $watcher_api_bind_host              = '0.0.0.0',
  $keystone_auth_version              = '3',
  $keystone_project_name              = 'service',
  $keystone_project_domain_name       = 'Default',
  $keystone_delay_auth_decision       = $::os_service_default,
  $keystone_http_connect_timeout      = $::os_service_default,
  $keystone_http_request_max_retries  = $::os_service_default,
  $keystone_swift_cache               = $::os_service_default,
  $keystone_certfile                  = $::os_service_default,
  $keystone_keyfile                   = $::os_service_default,
  $keystone_cafile                    = $::os_service_default,
  $keystone_auth_type                 = 'password',
  $keystone_insecure                  = $::os_service_default,
  $keystone_region_name               = $::os_service_default,
  $keystone_signing_dir               = '/var/cache/watcher',
  $keystone_hash_algorithms           = $::os_service_default,
  $watcher_client_default_domain_name = $::os_service_default,
  $watcher_client_project_name        = undef,
  $watcher_client_certfile            = undef,
  $watcher_client_cafile              = undef,
  $watcher_client_project_domain_name = undef,
  $watcher_client_insecure            = undef,
  $watcher_client_keyfile             = undef,
  $watcher_client_auth_type           = undef,
  $watcher_client_username            = undef,
  $watcher_client_password            = undef,
  $validation_options                 = {},
) {

  include ::watcher::params
  include ::watcher::policy
  include ::watcher::deps


  $watcher_client_password_real = pick($watcher_client_password, $keystone_password)
  $watcher_client_username_real = pick($watcher_client_username, $keystone_username)
  $watcher_client_project_name_real = pick($watcher_client_project_name, $keystone_project_name)
  $watcher_client_project_domain_name_real = pick($watcher_client_project_domain_name, $keystone_project_domain_name)
  $watcher_client_insecure_real = pick($watcher_client_insecure, $keystone_insecure)
  $watcher_client_auth_type_real = pick($watcher_client_auth_type, $keystone_auth_type)
  $watcher_client_cafile_real = pick($watcher_client_cafile, $keystone_cafile)
  $watcher_client_certfile_real = pick($watcher_client_certfile, $keystone_certfile)
  $watcher_client_keyfile_real = pick($watcher_client_keyfile, $keystone_keyfile)

  validate_string($keystone_password)
  validate_string($watcher_client_password_real)

  # NOTE(danpawlik): Packages for RedHat family OS is not known.
  # Until that package installation has been removed from this file.

  # NOTE(danpawlik): Service insurance that is runnig will be added later.
  # NOTE(danpawlik): db::create_schema and db::upgrade will be added later.
  if $enabled {
    watcher_config {
      'api/port':      value => $watcher_api_port;
      'api/max_limit': value => $watcher_api_max_limit;
      'api/host':      value => $watcher_api_bind_host;
    }
  }

  # NOTE(danpawlik): Until bug:
  # https://bugs.launchpad.net/puppet-keystone/+bug/1590748 is not fixed,
  # only these parameters are managed by keystone::resource::authtoken
  keystone::resource::authtoken { 'watcher_config':
    username            => $keystone_username,
    password            => $keystone_password,
    auth_url            => $auth_url,
    project_name        => $keystone_project_name,
    project_domain_name => $keystone_project_domain_name,
    insecure            => $keystone_insecure,
  }

  # NOTE(danpawlik): Options required by Watcher API and are not available
  # in keystone::resource::authtoken
  watcher_config {
    'keystone_authtoken/auth_uri':     value => $auth_uri;
    'keystone_authtoken/auth_version': value => $keystone_auth_version;
    'keystone_authtoken/auth_type':    value => $keystone_auth_type;
    'keystone_authtoken/signing_dir':  value => $keystone_signing_dir;
    'keystone_authtoken/region_name':  value => $keystone_region_name;
    'keystone_authtoken/cafile':       value => $keystone_cafile;
    'keystone_authtoken/certfile':     value => $keystone_certfile;
    'keystone_authtoken/keyfile':      value => $keystone_keyfile;
  }

  watcher_config {
    'watcher_clients_auth/username':            value => $watcher_client_username_real;
    'watcher_clients_auth/password':            value => $watcher_client_password_real, secret => true;
    'watcher_clients_auth/auth_url':            value => $auth_url;
    'watcher_clients_auth/auth_uri':            value => $auth_uri;
    'watcher_clients_auth/project_name':        value => $watcher_client_project_name_real;
    'watcher_clients_auth/project_domain_name': value => $watcher_client_project_domain_name_real;
    'watcher_clients_auth/insecure':            value => $watcher_client_insecure_real;
    'watcher_clients_auth/auth_type':           value => $watcher_client_auth_type_real;
    'watcher_clients_auth/cafile':              value => $watcher_client_cafile_real;
    'watcher_clients_auth/certfile':            value => $watcher_client_certfile_real;
    'watcher_clients_auth/keyfile':             value => $watcher_client_keyfile_real;
  }

  if $validate {
    $defaults = {
      'watcher-api' => {
        'command'  => "watcher --os-auth-url ${auth_uri} --os-tenant-name ${keystone_tenant} --os-username ${keystone_username} --os-password ${keystone_password} goal list",
      }
    }
    $validation_options_hash = merge($defaults, $validation_options)
    create_resources('openstacklib::service_validation', $validation_options_hash, {'subscribe' => 'Service[watcher-api]'})
  }

}
