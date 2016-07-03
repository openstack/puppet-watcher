#
# Class to execute watcher-db-manage create_schema
#
# == Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the watcher-db-manage create_schema command.
#   Defaults to '--config-file /etc/watcher/watcher.conf'
#
class watcher::db::create_schema(
  $extra_params  = '--config-file /etc/watcher/watcher.conf',
) {
  exec { 'watcher-db-manage-create_schema':
    command     => "watcher-db-manage ${extra_params} create_schema",
    path        => '/usr/bin',
    user        => 'watcher',
    refreshonly => true,
    subscribe   => [
      Package['watcher'],
      Watcher_config['database/connection'],
      Anchor['watcher::install::end'],
      Anchor['watcher::config::end'],
      Anchor['watcher::db::create_schema::begin']
    ],
    notify      => Anchor['watcher::db::create_schema::end'],
  }

  Exec['watcher-db-manage-create_schema'] ~> Service<| title == 'watcher-db-manage-create_schema' |>
}
