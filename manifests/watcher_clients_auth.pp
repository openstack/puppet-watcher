# == Class: watcher::watcher_clients_auth
#
# Configure the watcher_clients_auth options
#
# === Parameters
#
# [*password*]
#   (required) User's password
#
# [*auth_url*]
#   (optional) Specifies the admin Identity URI for Watcher to use.
#   Defaults to 'http://localhost:5000/'
#
# [*username*]
#   (optional) The name of the auth user
#   Defaults to watcher.
#
# [*project_name*]
#   (Optional) Service project name.
#   Defaults to 'services'
#
# [*project_domain_name*]
#   (Optional) Domain name containing project.
#   Defaults to 'Default'
#
# [*user_domain_name*]
#   (Optional) User Domain name.
#   Defaults to 'Default'
#
# [*system_scope*]
#   (Optional) Scope for system operations.
#   Defaults to $facts['os_service_default']
#
# [*auth_type*]
#   (Optional) Authentication type to load.
#   Defaults to 'password'
#
# [*insecure*]
#   (Optional) Verify HTTPS connections.
#   Defaults to $facts['os_service_default']
#
# [*keyfile*]
#   (Optional) PEM encoded client certificate key file.
#   Defaults to $facts['os_service_default']
#
# [*certfile*]
#   (Optional) PEM encoded client certificate cert file.
#   Defaults to $facts['os_service_default']
#
# [*cafile*]
#   (Optional)PEM encoded Certificate Authority to use when verifying HTTPs
#   connections.
#   Defaults to $facts['os_service_default']
#
class watcher::watcher_clients_auth (
  $password,
  $auth_url            = 'http://localhost:5000/',
  $username            = 'watcher',
  $project_name        = 'services',
  $project_domain_name = 'Default',
  $user_domain_name    = 'Default',
  $system_scope        = $facts['os_service_default'],
  $auth_type           = 'password',
  $insecure            = $facts['os_service_default'],
  $certfile            = $facts['os_service_default'],
  $cafile              = $facts['os_service_default'],
  $keyfile             = $facts['os_service_default'],
) {

  include watcher::deps

  if is_service_default($system_scope) {
    $project_name_real = $project_name
    $project_domain_name_real = $project_domain_name
  } else {
    $project_name_real = $facts['os_service_default']
    $project_domain_name_real = $facts['os_service_default']
  }

  watcher_config {
    'watcher_clients_auth/password':            value => $password, secret => true;
    'watcher_clients_auth/username':            value => $username;
    'watcher_clients_auth/auth_url':            value => $auth_url;
    'watcher_clients_auth/project_name':        value => $project_name_real;
    'watcher_clients_auth/project_domain_name': value => $project_domain_name_real;
    'watcher_clients_auth/user_domain_name':    value => $user_domain_name;
    'watcher_clients_auth/system_scope':        value => $system_scope;
    'watcher_clients_auth/insecure':            value => $insecure;
    'watcher_clients_auth/auth_type':           value => $auth_type;
    'watcher_clients_auth/cafile':              value => $cafile;
    'watcher_clients_auth/certfile':            value => $certfile;
    'watcher_clients_auth/keyfile':             value => $keyfile;
  }
}
