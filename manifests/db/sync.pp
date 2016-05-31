#
# Class to execute watcher-manage db_sync
#
# == Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the watcher-dbsync command.
#   Defaults to undef
#
class watcher::db::sync(
  $extra_params  = undef,
) {
  exec { 'watcher-db-sync':
    command     => "watcher-manage db_sync ${extra_params}",
    path        => '/usr/bin',
    user        => 'watcher',
    refreshonly => true,
    subscribe   => [Package['watcher'], Watcher_config['database/connection']],
  }

  Exec['watcher-manage db_sync'] ~> Service<| title == 'watcher' |>
}
