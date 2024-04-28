#
class profile::nac::network_scripts_mods(
  $priv_key_password = lookup('priv_key_password', {'default_value' => undef}),
){
  $iface = $facts['aero_interface']
  $shn   = $facts['short_hostname']

  case $facts['os']['family'] {
    'RedHat': {
      file_line  { 'KEY_MGMT_IEEE8021X':
        path  => "/etc/sysconfig/network-scripts/ifcfg-${iface}",
        line  => 'KEY_MGMT=IEEE8021X',
        match => '^KEY_MGMT=',
      }
      file_line  { 'IEEE_8021X_EAP_METHODS_TLS':
        path  => "/etc/sysconfig/network-scripts/ifcfg-${iface}",
        line  => 'IEEE_8021X_EAP_METHODS=TLS',
        match => '^IEEE_8021X_EAP_METHODS=',
      }
      file_line  { "IEEE_8021X_IDENTITY_${shn}":
        path  => "/etc/sysconfig/network-scripts/ifcfg-${iface}",
        line  => "IEEE_8021X_IDENTITY=${shn}",
        match => '^IEEE_8021X_IDENTITY=',
      }
      file_line  { "IEEE_8021X_CA_CERT_${shn}_pem":
        path  => "/etc/sysconfig/network-scripts/ifcfg-${iface}",
        line  => 'IEEE_8021X_CA_CERT=/etc/ssl/certs/ca-bundle.crt',
        match => '^IEEE_8021X_CA_CERT=',
      }
      file_line  { "IEEE_8021X_PRIVATE_KEY_${shn}_key":
        path  => "/etc/sysconfig/network-scripts/ifcfg-${iface}",
        line  => "IEEE_8021X_PRIVATE_KEY=/etc/ssl/certs/${shn}.key",
        match => '^IEEE_8021X_PRIVATE_KEY=',
      }
      file_line  { "IEEE_8021X_CLIENT_CERT_${shn}_pem":
        path  => "/etc/sysconfig/network-scripts/ifcfg-${iface}",
        line  => "IEEE_8021X_CLIENT_CERT=/etc/ssl/certs/${shn}.pem",
        match => '^IEEE_8021X_CLIENT_CERT=',
      }
      file { "/etc/sysconfig/network-scripts/keys-${iface}":
        mode    => '0600',
        owner   => root,
        group   => root,
        content => template('profile/nac/keys-interface.epp'),
      }
    }
    default: {
    }
  }
}
