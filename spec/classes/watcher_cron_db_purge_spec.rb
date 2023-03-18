require 'spec_helper'

describe 'watcher::cron::db_purge' do
  let :params do
    {
      :minute      => 1,
      :hour        => 0,
      :monthday    => '*',
      :month       => '*',
      :weekday     => '*',
      :user        => 'watcher',
      :age         => '30',
      :maxdelay    => 0,
      :destination => '/var/log/watcher/watcher-rowsflush.log'
    }
  end

  shared_examples 'watcher::cron::db_purge' do
    context 'with required parameters' do
      it { is_expected.to contain_cron('watcher-db-manage purge').with(
        :ensure      => :present,
        :command     => "watcher-db-manage purge -d #{params[:age]} >>#{params[:destination]} 2>&1",
        :environment => 'PATH=/bin:/usr/bin:/usr/sbin SHELL=/bin/sh',
        :user        => params[:user],
        :minute      => params[:minute],
        :hour        => params[:hour],
        :monthday    => params[:monthday],
        :month       => params[:month],
        :weekday     => params[:weekday],
        :require     => 'Anchor[watcher::db::upgrade::end]'
      )}
    end

    context 'with ensure set to absent' do
      before :each do
        params.merge!(
          :ensure => :absent
        )
      end

      it { should contain_cron('watcher-db-manage purge').with_ensure(:absent) }
    end

    context 'with required parameters with max delay enabled' do
      before :each do
        params.merge!(
          :maxdelay => 600
        )
      end

      it { should contain_cron('watcher-db-manage purge').with(
        :ensure      => :present,
        :command     => "sleep `expr ${RANDOM} \\% #{params[:maxdelay]}`; watcher-db-manage purge -d #{params[:age]} >>#{params[:destination]} 2>&1",
        :environment => 'PATH=/bin:/usr/bin:/usr/sbin SHELL=/bin/sh',
        :user        => params[:user],
        :minute      => params[:minute],
        :hour        => params[:hour],
        :monthday    => params[:monthday],
        :month       => params[:month],
        :weekday     => params[:weekday],
        :require     => 'Anchor[watcher::db::upgrade::end]'
      )}
    end

    context 'with additional parameters' do
      before :each do
        params.merge!(
          :exclude_orphans => true,
          :max_number      => 100,
        )
      end

      it { should contain_cron('watcher-db-manage purge').with(
        :ensure      => :present,
        :command     => "watcher-db-manage purge -d #{params[:age]} -e -n #{params[:max_number]} >>#{params[:destination]} 2>&1",
        :environment => 'PATH=/bin:/usr/bin:/usr/sbin SHELL=/bin/sh',
        :user        => params[:user],
        :minute      => params[:minute],
        :hour        => params[:hour],
        :monthday    => params[:monthday],
        :month       => params[:month],
        :weekday     => params[:weekday],
        :require     => 'Anchor[watcher::db::upgrade::end]'
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'watcher::cron::db_purge'
    end
  end
end
