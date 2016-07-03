require 'spec_helper'

describe 'watcher::db::upgrade' do

  shared_examples_for 'watcher-db-manage-upgrade' do

    it 'runs watcher-db-manage' do
      is_expected.to contain_exec('watcher-db-manage-upgrade').with(
        :command     => 'watcher-db-manage --config-file /etc/watcher/watcher.conf upgrade',
        :path        => '/usr/bin',
        :user        => 'watcher',
        :refreshonly => 'true',
      )
    end

    describe 'overriding extra_params' do
      let :params do
        {
          :extra_params => '--config-file /etc/watcher/watcher01.conf',
        }
      end

      it {
        is_expected.to contain_exec('watcher-db-manage-upgrade').with(
          :command     => 'watcher-db-manage --config-file /etc/watcher/watcher01.conf upgrade',
          :path        => '/usr/bin',
          :user        => 'watcher',
          :refreshonly => 'true',
        )
        }
      end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end
      it_configures 'watcher-db-manage-upgrade'
    end
  end

end
