# Profile::Timekeepers: Stipulate use of chrony in Ubuntu & Rocky, ntpd for all others
class profile::timekeepers{
  case $facts['os']['name'] {
    'Ubuntu', 'Rocky', 'OracleLinux': {
      service{'ntpd':
        ensure => stopped,
        enable => false,
      }
      include chrony
    }
    default: {
      service{'chrony':
        ensure => stopped,
        enable => false,
      }
      include ntpd
    }
  }
}
