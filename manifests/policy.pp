# == Class: watcher::policy
#
# Configure the watcher policies
#
# === Parameters
#
# [*policies*]
#   (Optional) Set of policies to configure for watcher
#   Example :
#     {
#       'watcher-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       'watcher-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (Optional) Path to the nova policy.yaml file
#   Defaults to /etc/watcher/policy.yaml
#
class watcher::policy (
  $policies    = {},
  $policy_path = '/etc/watcher/policy.yaml',
) {

  include watcher::deps
  include watcher::params

  validate_legacy(Hash, 'validate_hash', $policies)

  Openstacklib::Policy::Base {
    file_path   => $policy_path,
    file_user   => 'root',
    file_group  => $::watcher::params::group,
    file_format => 'yaml',
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'watcher_config': policy_file => $policy_path }
}
