class openssh::server (
  $version = 'present',
  $active = true
  ) {

  package { 'openssh-server':
    ensure => $version,
  }

  if $openssh::server_init_config {
    case $::osfamily {
      'Debian': {
        sysvinit::init::config { 'ssh':
          changes => $openssh::server_init_config,
        }
      }
    }
  }

  service { 'openssh-server':
    name => $::osfamily ? {
      'Debian' => 'ssh',
      'RedHat' => 'sshd',
    },
    ensure => $active ? {
      true => running,
      default => stopped,
    },
    enable => $active,
    hasrestart => true,
    require => Package['openssh-server'],
  }
}

