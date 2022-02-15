require 'spec_helper'

describe 'watcher::db::postgresql' do

  let :pre_condition do
    'include postgresql::server'
  end

  let :required_params do
    { :password => 'watcherpass' }
  end

  shared_examples_for 'watcher-db-postgresql' do
    context 'with only required parameters' do
      let :params do
        required_params
      end

      it { is_expected.to contain_class('watcher::deps') }

      it { is_expected.to contain_openstacklib__db__postgresql('watcher').with(
        :user       => 'watcher',
        :password   => 'watcherpass',
        :dbname     => 'watcher',
        :encoding   => nil,
        :privileges => 'ALL',
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({ :concat_basedir => '/var/lib/puppet/concat' }))
      end

      # TODO(tkajinam): Remove this once puppet-postgresql supports CentOS 9
      unless facts[:osfamily] == 'RedHat' and facts[:operatingsystemmajrelease].to_i >= 9
        it_behaves_like 'watcher-db-postgresql'
      end
    end
  end
end
