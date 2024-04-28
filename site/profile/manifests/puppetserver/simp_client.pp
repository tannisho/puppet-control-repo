#
class profile::puppetserver::simp_client(
  $mirrorserver = lookup('local_mirror', {'default_value' => 'mirror.test.local'}),
  $rpmpath = lookup('simp::client::simpserver::rpmpath', {'default_value' => undef}),
  $rpm = lookup('simp::client::simpserver::rpm', {'default_value' => undef}),
  $simpserver = lookup('simp::client::simpserver', {'default_value' => undef}),
  $simpserverlocal = lookup('simp::client::simpserver::local', {'default_value' => undef}),
  $simpserverprivip = lookup('simp::client::simpserver::privip', {'default_value' => undef}),
  Stdlib::Absolutepath $client_path = '/var/www/ks/simp-client.sh',
  Stdlib::Absolutepath $client_priv_path = '/var/www/ks/simp-client-priv.sh',
){

  file{ $client_path:
    mode    => '0640',
    owner   => root,
    group   => apache,
    content => template('profile/puppetserver/simp-client.sh.epp'),
  }

  file{ $client_priv_path:
    mode    => '0640',
    owner   => root,
    group   => apache,
    content => template('profile/puppetserver/simp-client-priv.sh.epp'),
  }

}
