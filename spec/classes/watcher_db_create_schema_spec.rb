require 'spec_helper'

describe 'watcher::db::create_schema' do

  shared_examples_for 'watcher-db-manage-create_schema' do

    it 'runs watcher-db-manage' do
      is_expected.to contain_exec('watcher-db-manage-create_schema').with(
        :command     => 'watcher-db-manage --config-file /etc/watcher/watcher.conf create_schema',
        :path        => '/usr/bin',
        :user        => 'watcher',
        :refreshonly => 'true',
        :subscribe   => [
          'Anchor[watcher::install::end]',
          'Anchor[watcher::config::end]',
          'Anchor[watcher::db::create_schema::begin]'
        ],
        :notify      => 'Anchor[watcher::db::create_schema::end]',
      )
    end

    describe 'overriding extra_params' do
      let :params do
        {
          :extra_params => '--config-file /etc/watcher/watcher01.conf',
        }
      end

      it {
        is_expected.to contain_exec('watcher-db-manage-create_schema').with(
          :command     => 'watcher-db-manage --config-file /etc/watcher/watcher01.conf create_schema',
          :path        => '/usr/bin',
          :user        => 'watcher',
          :refreshonly => 'true',
          :subscribe   => [
            'Anchor[watcher::install::end]',
            'Anchor[watcher::config::end]',
            'Anchor[watcher::db::create_schema::begin]'
          ],
          :notify      => 'Anchor[watcher::db::create_schema::end]',
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
      it_configures 'watcher-db-manage-create_schema'
    end
  end

end
