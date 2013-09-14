# == Class: sophos::update
#
# This class updates Sophos Mac Home edition definitions.
#
# === Authors
#
# Ryan Skoblenick <ryan@skoblenick.com>
#
# === Copyright
#
# Copyright 2013 Ryan Skoblenick.
#
class sophos::update {

  $update = $sophos::update

  exec {"sophos-update":
    command => 'sophosupdate',
    path => '/usr/bin',
    onlyif => "${update}",
  }

}