# Parameters for puppet-watcher
#
class watcher::params {
  include openstacklib::defaults

  $client_package_name = 'python3-watcherclient'
  $group               = 'watcher'

  case $::osfamily {
    'RedHat': {
      $api_service_name             = 'openstack-watcher-api'
      $api_package_name             = 'openstack-watcher-api'
      $common_package_name          = 'openstack-watcher-common'
      $applier_package_name         = 'openstack-watcher-applier'
      $applier_service_name         = 'openstack-watcher-applier'
      $decision_engine_package_name = 'openstack-watcher-decision-engine'
      $decision_engine_service_name = 'openstack-watcher-decision-engine'
      $watcher_wsgi_script_source   = '/usr/bin/watcher-api-wsgi'
      $watcher_wsgi_script_path     = '/var/www/cgi-bin/watcher'
    }
    'Debian': {
      $api_service_name             = 'watcher-api'
      $api_package_name             = 'watcher-api'
      $common_package_name          = 'watcher-common'
      $applier_package_name         = 'watcher-applier'
      $applier_service_name         = 'watcher-applier'
      $decision_engine_package_name = 'watcher-decision-engine'
      $decision_engine_service_name = 'watcher-decision-engine'
      $watcher_wsgi_script_source   = '/usr/bin/watcher-api-wsgi'
      $watcher_wsgi_script_path     = '/usr/lib/cgi-bin/watcher'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  } # Case $::osfamily
}
