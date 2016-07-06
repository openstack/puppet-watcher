# == Class: watcher::api
#
# Configure Watcher API service.
#
# === Parameters:
#
# [*keystone_password*]
#   (required) Password to create for the service user
#
# [*keystone_username*]
#  (optional) The name of the auth user
#  Defaults to watcher.
#
# [*auth_uri*]
#  (Optional) Public Identity API endpoint.
#  Defaults to 'http://localhost:5000/'
#
# [*auth_url*]
#  Specifies the admin Identity URI for Watcher to use.
#  Default 'http://localhost:35357/'
#
# [*package_ensure*]
#  (Optional)Ensure state of the openstackclient package.
#  Defaults to 'present'.
#
# [*enabled*]
#  (Optional) Whether the watcher api service will be run
#  Defaults to true
#
# [*manage_service*]
#  (Optional) Whether the service should be managed by Puppet.
#  Defaults to true.
#
# [*validate*]
#  (Optional) Whether to validate the service is working after any service
#  refreshes
#  Defaults to false
#
# [*watcher_api_port*]
#  (Optional) The port on which the watcher API will listen.
#  Defaults to 9322.
#
# [*watcher_api_max_limit*]
#  (Optional)The maximum number of items returned in a single response from a
#  collection resource.
#  Defaults to $::os_service_default
#
# [*watcher_api_bind_host*]
#  (Optional) Listen IP for the watcher API server.
#  Defaults to '0.0.0.0'.
#
# [*keystone_project_name*]
#  (Optional) Service project name
#  Defaults to 'service'
#
# [*keystone_auth_version*]
#  (Optional) API version of the admin Identity API endpoint.
#  Defaults to $::os_service_default.
#
# [*keystone_auth_type*]
#  (Optional) Authentication type to load.
#  Defaults to 'password'.
#
# [*keystone_auth_section*]
#  (Optional) Config Section from which to load plugin specific options.
#  Defaults to $::os_service_default
#
# [*keystone_user_domain_name*]
#  (Optional) User's domain name
#  Defaults to $::os_service_default
#
# [*keystone_project_domain_name*]
#  (Optional) Name of domain for $project_name
#  Defaults to $::os_service_default.
#
# [*keystone_insecure*]
#  (Optional) Verify HTTPS connections.
#  Defaults to $::os_service_default
#
# [*keystone_cache*]
#  (Optional) Env key for the swift cache.
#  Defaults to $::os_service_default
#
# [*keystone_cafile*]
#  (Optional) A PEM encoded Certificate Authority to use when verifying HTTPs
#  connections.
#  Defaults to $::os_service_default
#
# [*keystone_certfile*]
#  (Optional) Required if identity server requires client certificate.
#  Defaults to $::os_service_default
#
# [*keystone_check_revocations_for_cached*]
#  (Optional) If true, the revocation list will be checked for cached tokens.
#  This requires that PKI tokens are configured on the identity server.
#  boolean value.
#  Defaults to $::os_service_default
#
# [*keystone_delay_auth_decision*]
#  (Optional) Do not handle authorization requests within the middleware, but
#  delegate the authorization decision to downstream WSGI components.
#  Defaults to $::os_service_default
#
# [*keystone_enforce_token_bind*]
#  (Optional) Used to control the use and type of token binding. Can be set
#  to: "disabled" to not check token binding. "permissive" (default) to
#  validate binding information if the bind type is of a form known to the
#  server and ignore it if not. "strict" like "permissive" but if the bind
#  type is unknown the token will be rejected. "required" any form of token
#  binding is needed to be allowed. Finally the name of a binding method that
#  must be present in tokens. String value.
#  Defaults to $::os_service_default
#
# [*keystone_hash_algorithms*]
#  (Optional) Hash algorithms to use for hashing PKI tokens.
#  Defaults to $::os_service_default
#
# [*keystone_http_connect_timeout*]
#  (Optional) Request timeout value for communicating with Identity API server.
#  Defaults to $::os_service_default
#
# [*keystone_http_request_max_retries*]
#  (Optional) How many times are we trying to reconnect when communicating with
#  Identity API Server.
#  Defaults to $::os_service_default
#
# [*keystone_include_service_catalog*]
#  (Optional) Indicate whether to set the X-Service-Catalog header. If False,
#  middleware will not ask for service catalog on token validation and will not
#  set the X-Service-Catalog header. Boolean value.
#  Defaults to $::os_service_default
#
# [*keystone_keyfile*]
#  (Optional)Required if identity server requires client certificate.
#  Defaults to $::os_service_default
#
# [*keystone_*memcache_pool_dead_retry*]
#  (Optional) Number of seconds memcached server is considered dead before it
#  is tried again. Integer value
#  Defaults to $::os_service_default.
#
# [*keystone_memcache_pool_dead_retry*]
#  (Optional) Number of seconds memcached server is considered dead before it
#  is tried again. Integer value
#  Defaults to $::os_service_default.
#
# [*keystone_memcache_pool_maxsize*]
#  (Optional) Maximum total number of open connections to every memcached
#  server. Integer value
#  Defaults to $::os_service_default.
#
# [*keystone_memcache_pool_socket_timeout*]
#  (Optional) Number of seconds a connection to memcached is held unused in the
#  pool before it is closed. Integer value
#  Defaults to $::os_service_default.
#
# [*keystone_memcache_pool_unused_timeout*]
#  (Optional) Number of seconds a connection to memcached is held unused in the
#  pool before it is closed. Integer value
#  Defaults to $::os_service_default.
#
# [*keystone_memcache_secret_key*]
#  (Optional, mandatory if memcache_security_strategy is defined) This string
#  is used for key derivation.
#  Defaults to $::os_service_default.
#
# [*keystone_memcache_security_strategy*]
#  (Optional) If defined, indicate whether token data should be authenticated or
#  authenticated and encrypted. If MAC, token data is authenticated (with HMAC)
#  in the cache. If ENCRYPT, token data is encrypted and authenticated in the
#  cache. If the value is not one of these options or empty, auth_token will
#  raise an exception on initialization.
#  Defaults to $::os_service_default.
#
# [*keystone_memcache_use_advanced_pool*]
#  (Optional)  Use the advanced (eventlet safe) memcached client pool. The
#  advanced pool will only work under python 2.x Boolean value
#  Defaults to $::os_service_default.
#
# [*keystone_memcached_servers*]
#  (Optional) Optionally specify a list of memcached server(s) to use for
#  caching. If left undefined, tokens will instead be cached in-process.
#  Defaults to $::os_service_default.
#
# [*keystone_region_name*]
#  (Optional) The keystone region name. Default is unset.
#  Defaults to $::os_service_default
#
# [*keystone_revocation_cache_time*]
#  (Optional) Determines the frequency at which the list of revoked tokens is
#  retrieved from the Identity service (in seconds). A high number of
#  revocation events combined with a low cache duration may significantly
#  reduce performance. Only valid for PKI tokens. Integer value
#  Defaults to $::os_service_default
#
# [*keystone_signing_dir*]
#  (Optional) Directory used to cache files related to PKI tokens.
#  Defaults to '/var/cache/watcher'
#
# [*keystone_token_cache_time*]
#  (Optional) In order to prevent excessive effort spent validating tokens,
#  the middleware caches previously-seen tokens for a configurable duration
#  (in seconds). Set to -1 to disable caching completely.
#  Defaults to $::os_service_default
#
# [*keystone_memcache_pool_conn_get_timeout*]
#  (Optional) Number of seconds that an operation will wait to get a memcached
#  client connection from the pool. Integer value
#  Defaults to $::os_service_default.
#
# [*watcher_client_default_domain_name*]
#  (Optional)domain name to use with v3 API and v2 parameters. It will
#  be used for both the user and project domain in v3 and ignored in v2
#  authentication.
#  Defaults to $::os_service_default
#
# [*watcher_client_project_name*]
#  (Optional) Service project name.
#  Defaults to undef
#
# [*watcher_client_certfile*]
#  (Optional) PEM encoded client certificate cert file.
#  Defaults to undef
#
# [*watcher_client_cafile*]
# (Optional)PEM encoded Certificate Authority to use when verifying HTTPs
#  connections.
#  Defaults to undef
#
# [*watcher_client_project_domain_name*]
#  (Optional) Domain name containing project.
#  Defaults to undef
#
# [*watcher_client_insecure*]
#  (Optional) Verify HTTPS connections.
#  Defaults to undef
#
# [*watcher_client_keyfile*]
#  (Optional) PEM encoded client certificate key file.
#  Defaults to undef
#
# [*watcher_client_auth_type*]
#  (Optional) Authentication type to load.
#  Defaults to undef
#
# [*watcher_client_username*]
#  (Optional) Keystone username for watcher client. Decision engine works on
#  this variable.
#  Defaults to undef
#
# [*watcher_client_password*]
#  (Optional) Keystone password for watcher client.
#  Defaults to undef
#
# [*validation_options*]
#  (Optional) Service validation options
#  Should be a hash of options defined in openstacklib::service_validation
#  If empty, defaults values are taken from openstacklib function.
#  Require validate set at True.
#  Defaults to {}
#
class watcher::api (
  $keystone_password,
  $keystone_username                       = 'watcher',
  $auth_uri                                = 'http://localhost:5000/',
  $auth_url                                = 'http://localhost:35357/',
  $package_ensure                          = 'present',
  $enabled                                 = true,
  $manage_service                          = true,
  $validate                                = false,
  $watcher_api_port                        = '9322',
  $watcher_api_max_limit                   = $::os_service_default,
  $watcher_api_bind_host                   = '0.0.0.0',
  $keystone_project_name                   = 'service',
  $keystone_auth_version                   = $::os_service_default,
  $keystone_auth_type                      = 'password',
  $keystone_auth_section                   = $::os_service_default,
  $keystone_user_domain_name               = $::os_service_default,
  $keystone_project_domain_name            = $::os_service_default,
  $keystone_insecure                       = $::os_service_default,
  $keystone_cache                          = $::os_service_default,
  $keystone_cafile                         = $::os_service_default,
  $keystone_certfile                       = $::os_service_default,
  $keystone_check_revocations_for_cached   = $::os_service_default,
  $keystone_delay_auth_decision            = $::os_service_default,
  $keystone_enforce_token_bind             = $::os_service_default,
  $keystone_hash_algorithms                = $::os_service_default,
  $keystone_http_connect_timeout           = $::os_service_default,
  $keystone_http_request_max_retries       = $::os_service_default,
  $keystone_include_service_catalog        = $::os_service_default,
  $keystone_keyfile                        = $::os_service_default,
  $keystone_memcache_pool_conn_get_timeout = $::os_service_default,
  $keystone_memcache_pool_dead_retry       = $::os_service_default,
  $keystone_memcache_pool_maxsize          = $::os_service_default,
  $keystone_memcache_pool_socket_timeout   = $::os_service_default,
  $keystone_memcache_secret_key            = $::os_service_default,
  $keystone_memcache_security_strategy     = $::os_service_default,
  $keystone_memcache_use_advanced_pool     = $::os_service_default,
  $keystone_memcache_pool_unused_timeout   = $::os_service_default,
  $keystone_memcached_servers              = $::os_service_default,
  $keystone_region_name                    = $::os_service_default,
  $keystone_revocation_cache_time          = $::os_service_default,
  $keystone_signing_dir                    = '/var/cache/watcher',
  $keystone_token_cache_time               = $::os_service_default,
  $watcher_client_default_domain_name      = $::os_service_default,
  $watcher_client_project_name             = undef,
  $watcher_client_certfile                 = undef,
  $watcher_client_cafile                   = undef,
  $watcher_client_project_domain_name      = undef,
  $watcher_client_insecure                 = undef,
  $watcher_client_keyfile                  = undef,
  $watcher_client_auth_type                = undef,
  $watcher_client_username                 = undef,
  $watcher_client_password                 = undef,
  $validation_options                      = {},
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

  if !is_service_default($keystone_memcached_servers) and !empty($keystone_memcached_servers){
    validate_array($keystone_memcached_servers)
    $keystone_memcached_servers_real = join($keystone_memcached_servers,',')
  }

  Watcher_config<||> ~> Service['watcher-api']
  Class['watcher::policy'] ~> Service['watcher-api']

  Package['watcher-api'] -> Service['watcher-api']
  package { 'watcher-api':
    ensure => $package_ensure,
    name   => $::watcher::params::api_package_name,
    tag    => ['openstack', 'watcher-package'],
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  # NOTE(danpawlik) Service tag for DB will be added after/with DB manifests.
  service { 'watcher-api':
    ensure     => $service_ensure,
    name       => $::watcher::params::api_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    require    => Class['watcher::db'],
    tag        => ['watcher-service'],
  }

  # NOTE(danpawlik): Service insurance that is runnig will be added later.
  # NOTE(danpawlik): db::create_schema and db::upgrade will be added later.
  if $enabled {
    watcher_config {
      'api/port':      value => $watcher_api_port;
      'api/max_limit': value => $watcher_api_max_limit;
      'api/host':      value => $watcher_api_bind_host;
    }
  }

  keystone::resource::authtoken { 'watcher_config':
    username                       => $keystone_username,
    password                       => $keystone_password,
    project_name                   => $keystone_project_name,
    auth_url                       => $auth_url,
    auth_uri                       => $auth_uri,
    auth_version                   => $keystone_auth_version,
    auth_type                      => $keystone_auth_type,
    auth_section                   => $keystone_auth_section,
    user_domain_name               => $keystone_user_domain_name,
    project_domain_name            => $keystone_project_domain_name,
    insecure                       => $keystone_insecure,
    cache                          => $keystone_cache,
    cafile                         => $keystone_cafile,
    certfile                       => $keystone_certfile,
    check_revocations_for_cached   => $keystone_check_revocations_for_cached,
    delay_auth_decision            => $keystone_delay_auth_decision,
    enforce_token_bind             => $keystone_enforce_token_bind,
    hash_algorithms                => $keystone_hash_algorithms,
    http_connect_timeout           => $keystone_http_connect_timeout,
    http_request_max_retries       => $keystone_http_request_max_retries,
    include_service_catalog        => $keystone_include_service_catalog,
    keyfile                        => $keystone_keyfile,
    memcache_pool_conn_get_timeout => $keystone_memcache_pool_conn_get_timeout,
    memcache_pool_dead_retry       => $keystone_memcache_pool_dead_retry,
    memcache_pool_maxsize          => $keystone_memcache_pool_maxsize,
    memcache_pool_socket_timeout   => $keystone_memcache_pool_socket_timeout,
    memcache_secret_key            => $keystone_memcache_secret_key,
    memcache_security_strategy     => $keystone_memcache_security_strategy,
    memcache_use_advanced_pool     => $keystone_memcache_use_advanced_pool,
    memcache_pool_unused_timeout   => $keystone_memcache_pool_unused_timeout,
    memcached_servers              => $keystone_memcached_servers_real,
    region_name                    => $keystone_region_name,
    revocation_cache_time          => $keystone_revocation_cache_time,
    signing_dir                    => $keystone_signing_dir,
    token_cache_time               => $keystone_token_cache_time,
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
        'command'  => "watcher --os-auth-url ${auth_uri} --os-project-name ${keystone_project_name} --os-username ${keystone_username} --os-password ${keystone_password} goal list",
      }
    }
    $validation_options_hash = merge($defaults, $validation_options)
    create_resources('openstacklib::service_validation', $validation_options_hash, {'subscribe' => 'Service[watcher-api]'})
  }

}
