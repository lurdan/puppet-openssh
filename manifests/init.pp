class openssh (
  $version = 'present',
  $client = true,
  $client_config = false,
  $server = true,
  $server_init_config = false
  ) {
  if $client {
    class { 'openssh::client':
      version => $version,
      client_config => $client_config,
    }
  }
  if $server {
    class { 'openssh::server':
      version => $version,
      active => $server,
    }
  }
}

define openssh::config::server (
  $changes,
  $onlyif = false
  ) {
  augeas { "/etc/ssh/sshd_config-$name":
    context => '/files/etc/ssh/sshd_config',
    changes => $changes,
    onlyif => $onlyif,
    require => Package['openssh-server'],
    notify => Service['openssh-server'],
  }
}

