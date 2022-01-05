require 'spec_helper'

describe 'watcher::wsgi::apache' do

  shared_examples_for 'apache serving watcher with mod_wsgi' do
    context 'with default parameters' do
      it { is_expected.to contain_class('watcher::params') }
      it { is_expected.to contain_openstacklib__wsgi__apache('watcher_wsgi').with(
        :bind_port                   => 9322,
        :group                       => 'watcher',
        :path                        => '/',
        :servername                  => facts[:fqdn],
        :ssl                         => true,
        :threads                     => 1,
        :user                        => 'watcher',
        :workers                     => facts[:os_workers],
        :wsgi_daemon_process         => 'watcher',
        :wsgi_process_group          => 'watcher',
        :wsgi_script_dir             => platform_params[:wsgi_script_path],
        :wsgi_script_file            => 'app',
        :wsgi_script_source          => platform_params[:wsgi_script_source],
        :access_log_file             => false,
        :access_log_format           => false,
        :custom_wsgi_process_options => {},
      )}
    end

    context 'when overriding parameters using different ports' do
      let :params do
        {
          :servername                  => 'dummy.host',
          :bind_host                   => '10.42.51.1',
          :port                        => 12345,
          :ssl                         => false,
          :wsgi_process_display_name   => 'watcher',
          :workers                     => 37,
          :access_log_file             => '/var/log/httpd/access_log',
          :access_log_format           => 'some format',
          :error_log_file              => '/var/log/httpd/error_log',
          :custom_wsgi_process_options => {
            'python_path' => '/my/python/path',
          },
        }
      end
      it { is_expected.to contain_class('watcher::params') }
      it { is_expected.to contain_openstacklib__wsgi__apache('watcher_wsgi').with(
        :bind_host                   => '10.42.51.1',
        :bind_port                   => 12345,
        :group                       => 'watcher',
        :path                        => '/',
        :servername                  => 'dummy.host',
        :ssl                         => false,
        :threads                     => 1,
        :user                        => 'watcher',
        :workers                     => 37,
        :wsgi_daemon_process         => 'watcher',
        :wsgi_process_display_name   => 'watcher',
        :wsgi_process_group          => 'watcher',
        :wsgi_script_dir             => platform_params[:wsgi_script_path],
        :wsgi_script_file            => 'app',
        :wsgi_script_source          => platform_params[:wsgi_script_source],
        :access_log_file             => '/var/log/httpd/access_log',
        :access_log_format           => 'some format',
        :error_log_file              => '/var/log/httpd/error_log',
        :custom_wsgi_process_options => {
          'python_path' => '/my/python/path',
        },
      )}
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :os_workers     => 42,
          :concat_basedir => '/var/lib/puppet/concat',
          :fqdn           => 'some.host.tld',
        }))
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          if facts[:operatingsystem] == 'Debian'
            {
              :wsgi_script_path   => '/usr/lib/cgi-bin/watcher',
              :wsgi_script_source => '/usr/share/watcher-common/app.wsgi'
            }
          else
            {
              :wsgi_script_path   => '/usr/lib/cgi-bin/watcher',
              :wsgi_script_source => '/usr/lib/python3/dist-packages/watcher/api/app.wsgi'
            }
          end
        when 'RedHat'
          {
            :wsgi_script_path   => '/var/www/cgi-bin/watcher',
            :wsgi_script_source => '/usr/lib/python3.6/site-packages/watcher/api/app.wsgi'
          }
        end
      end

      it_behaves_like 'apache serving watcher with mod_wsgi'
    end
  end
end
