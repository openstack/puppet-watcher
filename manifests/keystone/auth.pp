# == Class: watcher::keystone::auth
#
# Configures watcher user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (Required) Password for watcher user.
#
# [*auth_name*]
#   (Optional) Username for watcher service.
#   Defaults to 'watcher'.
#
# [*email*]
#   (Optional) Email for watcher user.
#   Defaults to 'watcher@localhost'.
#
# [*tenant*]
#   (Optional) Tenant for watcher user.
#   Defaults to 'services'.
#
# [*configure_endpoint*]
#   (Optional) Should watcher endpoint be configured?
#   Defaults to true.
#
# [*configure_user*]
#   (Optional) Should the service user be configured?
#   Defaults to true.
#
# [*configure_user_role*]
#   (Optional) Should the admin role be configured for the service user?
#   Defaults to true.
#
# [*service_type*]
#   (Optional) Type of service.
#   Defaults to 'infra-optim'.
#
# [*region*]
#   (Optional) Region for endpoint.
#   Defaults to 'RegionOne'.
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to the value of auth_name.
#
# [*service_description*]
#   (Optional) Description of the service.
#   Default to 'watcher API Service'
#
# [*public_url*]
#   (0ptional) The endpoint's public url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:9322'
#
# [*admin_url*]
#   (Optional) The endpoint's admin url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:9322'
#
# [*internal_url*]
#   (Optional) The endpoint's internal url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:9322'
#
class watcher::keystone::auth (
  $password,
  $auth_name           = 'watcher',
  $email               = 'watcher@localhost',
  $tenant              = 'services',
  $configure_endpoint  = true,
  $configure_user      = true,
  $configure_user_role = true,
  $service_name        = undef,
  $service_description = 'Infrastructure Optimization service',
  $service_type        = 'infra-optim',
  $region              = 'RegionOne',
  $public_url          = 'http://127.0.0.1:9322',
  $admin_url           = 'http://127.0.0.1:9322',
  $internal_url        = 'http://127.0.0.1:9322',
) {

  include watcher::deps

  $real_service_name = pick($service_name, $auth_name)

  if $configure_user_role {
    Keystone_user_role["${auth_name}@${tenant}"] ~> Anchor['watcher::service::end']
  }

  if $configure_endpoint {
    Keystone_endpoint["${region}/${real_service_name}::${service_type}"]  ~> Anchor['watcher::service::end']
  }

  keystone::resource::service_identity { 'watcher':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_name        => $real_service_name,
    service_type        => $service_type,
    service_description => $service_description,
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    public_url          => $public_url,
    internal_url        => $internal_url,
    admin_url           => $admin_url,
  }

}
