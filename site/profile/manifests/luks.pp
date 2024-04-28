#
class profile::luks(
  $kspass       = lookup('luks::kspass', {'default_value' => undef} ),
  $szeropass    = lookup('luks::szeropass', {'default_value' => undef} ),
  $sonepass     = lookup('luks::sonepass', {'default_value' => undef} ),
  $tangservers  = lookup('luks::tangservers', {'default_value' => undef} ),
){
  unless $facts['luks_applied'] == 'true' {
    file {'/root/.pwf':
      ensure => directory,
      mode   => '0750',
    }
    ->  file {'/root/.pwf/setup_luks.sh':
          content => template('profile/luks/setup_luks_sh.epp'),
          mode    => '0750',
        }
    ->  exec {'run_setup_luks':
          command => '/root/.pwf/setup_luks.sh',
        }
    ->  exec {'remove_luks_files':
          command => 'rm -rf /root/.pwf',
        }
  }
  if $facts['luks_revert'] == 'true' {
    file {'/root/.pwf':
      ensure => directory,
      mode   => '0750',
    }
    ->  file {'/root/.pwf/revert_luks.sh':
          content => template('profile/luks/revert_luks_sh.epp'),
          mode    => '0750',
        }
    ->  exec {'run_revert_luks':
          command => '/root/.pwf/revert_luks.sh',
        }
    ->  exec {'remove_luks_files':
          command => 'rm -rf /root/.pwf',
        }
  }
}
