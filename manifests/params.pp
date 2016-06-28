# Parameters for puppet-watcher
#
class watcher::params {

  case $::osfamily {
    'RedHat': {
      $api_service_name    = 'openstack-watcher-api'
      $api_package_name    = 'openstack-watcher-api'
      $common_package_name = 'openstack-watcher-common'
    }
    'Debian': {
      $api_service_name    = 'watcher-api'
      $api_package_name    = 'watcher-api'
      $common_package_name = 'watcher-common'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  } # Case $::osfamily
}
