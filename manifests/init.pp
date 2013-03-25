class openssh (
  $version = 'latest',
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

define openssh::key::private (
  $user,
  $keyfile,
  $home = "/home/${user}",
  $group = "$user"
  ) {
  file { "${home}/.ssh/id_${name}":
    mode => 600, owner => $user, group => $group,
    content => $keyfile,
  }
}

define openssh::key::authorized (
  $authfile,
  $publickey
  ) {
  concat::fragment { "openssh-key-authorized-${name}":
    target => $authfile,
    content => "${publickey}\n",
  }
}
