# == Class: sophos
#
# This class is used to install Sophos Mac Home edition.
#
# === Parameters:
#
# [*version*] Version of Sophos
# [*update*] Trigger definition updates
#
# === Authors
#
# Ryan Skoblenick <ryan@skoblenick.com>
#
# === Copyright
#
# Copyright 2013 Ryan Skoblenick.
#
class sophos(
  $version = $sophos::params::version,
  $update  = $sophos::params::update
) inherits sophos::params {

  validate_bool($update)
  
  anchor {'sophos::begin': } ->
  class {'sophos::install': } ->
  class {'sophos::update': } ->
  anchor {'sophos::end': }

}