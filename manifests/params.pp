# Parameters for puppet-watcher
#
class watcher::params {
  include ::openstacklib::defaults

  if ($::os_package_type == 'debian') or ($::os['name'] == 'Fedora') or
    ($::os['family'] == 'RedHat' and Integer.new($::os['release']['major']) > 7) {
    $pyvers = '3'
  } else {
    $pyvers = ''
  }

  $client_package_name = "python${pyvers}-watcherclient"
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
      $watcher_wsgi_script_source   = '/usr/lib/python2.7/site-packages/watcher/api/app.wsgi'
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
      if ($::os_package_type == 'debian') {
        $watcher_wsgi_script_source = '/usr/share/watcher-common/app.wsgi'
      } else {
        $watcher_wsgi_script_source = '/usr/lib/python2.7/dist-packages/watcher/api/app.wsgi'
      }
      $watcher_wsgi_script_path     = '/usr/lib/cgi-bin/watcher'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  } # Case $::osfamily
}
