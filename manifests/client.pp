class openssh::client (
  $version = 'present',
  $client_config = false
) {

  package { 'openssh-client':
    ensure => $version,
    name => $::operatingsystem ? {
      /(?i-mx:debian|ubuntu)/ => 'openssh-client',
      /(?i-mx:redhat|centos)/ => 'openssh-clients',
    },
  }
  if $client_config {
    file { '/etc/ssh/ssh_config':
      mode => 400,
      content => $client_config,
      require => Package['openssh-client'];
    }
  }
}
