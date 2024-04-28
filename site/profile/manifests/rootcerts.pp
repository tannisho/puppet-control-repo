#
class profile::rootcerts{
  file { '/usr/lib/firefox/distribution/':
    ensure  => 'directory',
    source  => 'puppet:///modules/profile/firefox',
    purge   => false,
    force   => false,
    recurse => true,
  }

  file { '/etc/pki/ca-trust/source/anchors/':
    ensure  => 'directory',
    source  => 'puppet:///modules/profile/rootcerts',
    purge   => false,
    force   => false,
    recurse => true,
    notify  => Exec[update-ca-trust],
  }

  exec { 'update-ca-trust':
    command     => '/usr/bin/update-ca-trust extract',
    refreshonly => true,
    timeout     => 0,
  }
}
