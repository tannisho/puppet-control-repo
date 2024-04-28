#
class profile::nac{

  include profile::rootcerts
  include profile::nac::apply_cert
  include profile::nac::network_scripts_mods
  Class['profile::nac::network_scripts_mods'] ~> Class['profile::nac::apply_cert']

}
