#
class profile::nac::apply_cert(
  $shn   = $facts['short_hostname'],
  String[1] $pem_key = lookup('pem_key', {'default_value' => undef}),
  String[1] $priv_key = lookup('priv_key', {'default_value' => undef}),
){
  case $facts['os']['family'] {
    'RedHat': {
      file { "/etc/ssl/certs/${shn}.pem":
        mode    => '0640',
        owner   => root,
        group   => root,
        content => template('profile/nac/pem_key.epp'),
      }
      file { "/etc/ssl/certs/${shn}.key":
        mode    => '0640',
        owner   => root,
        group   => root,
        content => template('profile/nac/priv_key.epp'),
      }
      -> exec { 'restart_nm':
        command     => '/bin/systemctl restart NetworkManager.service',
        refreshonly => true,
      }
    }
    default: {
    }
  }
}
