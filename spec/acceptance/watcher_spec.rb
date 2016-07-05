require 'spec_helper_acceptance'

describe 'basic watcher' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      include ::openstack_integration
      include ::openstack_integration::repos
      include ::openstack_integration::rabbitmq
      include ::openstack_integration::mysql
      include ::openstack_integration::keystone

      rabbitmq_user { 'watcher':
        admin    => true,
        password => 'my_secret',
        provider => 'rabbitmqctl',
        require  => Class['rabbitmq'],
      }

      rabbitmq_user_permissions { 'watcher@/':
        configure_permission => '.*',
        write_permission     => '.*',
        read_permission      => '.*',
        provider             => 'rabbitmqctl',
        require              => Class['rabbitmq'],
      }

      class { '::watcher::db::mysql':
        password => 'a_big_secret',
      }
      class { '::watcher::keystone::auth':
        password => 'a_big_secret',
      }

      # Watcher service is not packaged on Ubuntu platform, but is available
      # in Debian experimental repo. It will be safer if tests are going only
      # on RedHat osfamily. Ubuntu tests will be added later.
      if $::osfamily == 'RedHat' {
        class { '::watcher::db':
          database_connection => 'mysql+pymysql://watcher:a_big_secret@127.0.0.1/watcher?charset=utf8',
        }
        class { '::watcher::logging':
          debug => true,
        }
        class { '::watcher':
          rabbit_userid   => 'watcher',
          rabbit_password => 'my_secret',
          rabbit_host     => '127.0.0.1',
        }
        class { '::watcher::api':
          keystone_password => 'a_big_secret',
        }
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end

end
