# == Class: sophos::install
#
# This class is used to install Sophos Mac Home edition.
#
# === Authors
#
# Ryan Skoblenick <ryan@skoblenick.com>
#
# === Copyright
#
# Copyright 2013 Ryan Skoblenick.
#
class sophos::install {

  $version = $sophos::version

  if "${version}" == '8' {
    # Sophos 8.0 uses an appdmg
    package {"sophos-${version}":
      ensure => installed,
      source => "http://downloads.sophos.com/home-edition/savosx_${version}0_he.dmg",
      provider => pkgdmg,
    }
  } elsif "${version}" == '9' {
    # Sophos 9.0 uses an app installation
    $cookie = "/var/db/.puppet_app_installed_sophos-${version}.0"
    $source = "http://downloads.sophos.com/home-edition/savosx_${version}0_he.zip"

    Exec {
      cwd => '/tmp',
      onlyif => "test ! -f ${cookie}",
      path => '/usr/bin:/bin',
    }

    exec {'sophos-download':
      command => "curl -o savosx_${version}0_he.zip -C - -k -L -s --url ${source}",
    }
    ->
    exec {'sophos-extract':
      command => "unzip savosx_${version}0_he.zip",
    }
    ->
    exec {'sophos-install':
      command => './InstallationDeployer --install',
      cwd => '/tmp/Sophos Anti-Virus Home Edition.app/Contents/MacOS',
      user => 'root',
      path => '/tmp/Sophos Anti-Virus Home Edition.app/Contents/MacOS:/usr/bin:/bin',
    }
    ->
    file {"${cookie}":
      ensure => present,
      content => "name:'sophos'\nsource:'${url}'",
      owner => 'root',
      group => 'wheel',
      mode => '0644',
    }
    ->
    file {'/tmp/Sophos Anti-Virus Home Edition.app':
      ensure => absent,
      force => true,
      recurse => true,
    }
    ->
    file {'/tmp/savosx_${version}0_he.zip':
      ensure => absent,
      force => true,
    }
  } else {
    fail("Unrecognized version ${version}")
  }

}