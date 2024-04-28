#
class profile::local_scripts (
  Stdlib::Absolutepath $btmpdir = lookup('local_scripts::btmpdir', { default_value => '/opt/local_scripts/bolt_tmpdir' }),
  String[1] $blogin_group = lookup('local_scripts::blogin', { default_value => 'boltadmins' }),
) {
  $pserver = $facts['puppet_server']
  $_readme_content = @("rmc")
      ---
  Placeholder for /opt/local_scripts specifically for nodes managed by
  ${pserver}
  | rmc

  file { '/opt/local_scripts':
    ensure => directory,
    mode   => '0755',
  }
  -> file { '/opt/local_scripts/fact_scripts':
    ensure => directory,
    mode   => '0750',
  }
  -> file { '/opt/local_scripts/fact_scripts/main_interface.py':
    content => template('profile/local_scripts/fact_scripts/main_interface_py.epp'),
    mode    => '0750',
  }
  -> file { '/opt/local_scripts/fact_scripts/luks_dev.sh':
    source => 'puppet:///modules/profile/local_scripts/fact_scripts/luks_dev.sh',
    mode   => '0750',
  }
  -> file { '/opt/local_scripts/fact_scripts/mac_address.sh':
    source => 'puppet:///modules/profile/local_scripts/fact_scripts/mac_address.sh',
    mode   => '0750',
  }
  file { $btmpdir:
    ensure => directory,
    owner  => 'root',
    group  => $blogin_group,
    mode   => '0770',
  }
  file { '/opt/local_scripts/README.md':
    content => $_readme_content,
    mode    => '0644',
  }
}
