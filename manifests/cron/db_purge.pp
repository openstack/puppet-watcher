#
# Copyright (C) 2023 Red Hat Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# == Class: watcher::cron::db_purge
#
# Purge soft-deleted or orphaned records from database.
#
# === Parameters
#
#  [*ensure*]
#    (optional) Ensure cron jobs present or absent
#    Defaults to present.
#
#  [*minute*]
#    (optional) Defaults to '1'.
#
#  [*hour*]
#    (optional) Defaults to '0'.
#
#  [*monthday*]
#    (optional) Defaults to '*'.
#
#  [*month*]
#    (optional) Defaults to '*'.
#
#  [*weekday*]
#    (optional) Defaults to '*'.
#
#  [*user*]
#    (optional) User with access to watcher files.
#    Defaults to 'watcher'.
#
#  [*age*]
#    (optional) Number of days prior to today for deletion,
#    e.g. value 60 means to purge deleted rows that have the "deleted_at"
#    column greater than 60 days ago.
#    Defaults to 30
#
#  [*destination*]
#    (optional) Path to file to which rows should be archived
#    Defaults to '/var/log/watcher/watcher-rowsflush.log'.
#
#  [*maxdelay*]
#    (optional) In Seconds. Should be a positive integer.
#    Induces a random delay before running the cronjob to avoid running
#    all cron jobs at the same time on all hosts this job is configured.
#    Defaults to 0.
#
#  [*exclude_orphans*]
#    (optional) Flag to indicate whether orhans should be excluded from
#    deletion.
#    Defaults to false
#
#  [*max_number*]
#    (optional) Max number of objects expected to be deleted.
#    Defaults to undef
#
class watcher::cron::db_purge (
  Enum['present', 'absent'] $ensure = 'present',
  $minute                           = 1,
  $hour                             = 0,
  $monthday                         = '*',
  $month                            = '*',
  $weekday                          = '*',
  $user                             = $::watcher::params::user,
  $age                              = 30,
  $destination                      = '/var/log/watcher/watcher-rowsflush.log',
  Integer[0] $maxdelay              = 0,
  Boolean $exclude_orphans          = false,
  $max_number                       = undef,
) inherits watcher::params {

  include watcher::deps

  $sleep = $maxdelay ? {
    0       => '',
    default => "sleep `expr \${RANDOM} \\% ${maxdelay}`; ",
  }

  $exclude_orphans_opt = $exclude_orphans ? {
    true    => ' -e',
    default => '',
  }

  $max_number_opt =  $max_number ? {
    undef   => '',
    default => " -n ${max_number}",
  }

  cron { 'watcher-db-manage purge':
    ensure      => $ensure,
    command     => "${sleep}watcher-db-manage purge -d ${age}${exclude_orphans_opt}${max_number_opt} >>${destination} 2>&1",
    environment => 'PATH=/bin:/usr/bin:/usr/sbin SHELL=/bin/sh',
    user        => $user,
    minute      => $minute,
    hour        => $hour,
    monthday    => $monthday,
    month       => $month,
    weekday     => $weekday,
    require     => Anchor['watcher::db::upgrade::end'],
  }
}
