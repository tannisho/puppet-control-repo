#
class profile::lustre(
  $location = $facts['aero_location'],
  $default_storage_interface = $facts['storage_interface'],
  $storage_interface = lookup('lustre::storage_interface', {'default_value' => $default_storage_interface}),
  $storage_net_gateway = lookup('lustre::storage_net_gateway', {'default_value' => '10.240.0.1'}),
  $lustre_rpms_url = lookup('lustre::lustre_rpms_url', {'default_value' => 'http://repo.test.local/pub/aero/RedHat/8/x86_64'}),
  $lustre_rpm_dir = lookup('lustre::lustre_rpm_dir', {'default_value' => '/root/rpm_dir'}),
  $lustre_rpm = lookup('lustre::lustre_rpm', {'default_value' => undef}),
  $lustre_kernel_version_justnumber = lookup('lustre::lustre_kernel_version_justnumber', {'default_value' => '4.18.0-513.5.1.el8_9'}),
  $lustre_kernel_version = lookup('lustre::lustre_kernel_version', {'default_value' => 'kernel-4.18.0-513.5.1.el8_9'}),
  $lustre_kernel_core_version = lookup('lustre::lustre_kernel_core_version', {'default_value' => 'kernel-core-4.18.0-513.5.1.el8_9'}),
  $lustre_kernel_mods_version = lookup('lustre::lustre_kernel_mods_version', {'default_value' => 'kernel-modules-4.18.0-513.5.1.el8_9'}),
  $ip1 = lookup('lustre::ip1', {'default_value' => undef}),
  $ip2 = lookup('lustre::ip2', {'default_value' => undef}),
  $ip3 = lookup('lustre::ip3', {'default_value' => undef}),
  $ip4 = lookup('lustre::ip4', {'default_value' => undef}),
){
  file { $lustre_rpm_dir:
    ensure => directory,
  }
  $lustre_rpm.each | String $rpm| {
    exec {"download_rpm_${rpm}":
      command => "/usr/bin/wget ${lustre_rpms_url}/${rpm} --directory-prefix=${lustre_rpm_dir}",
      unless  => '/bin/cat /etc/facter/facts.d/type.txt|grep lustre_installed=true',
      require => File[$lustre_rpm_dir],
    }
    package { $rpm:
      ensure          => 'installed',
      source          => "${lustre_rpm_dir}/${rpm}",
      provider        => 'dnf',
      install_options => ['--nogpgcheck'],
      notify          => File_line['lustre_installed'],
    }
  }
  file_line { 'lustre_installed':
    path  => '/etc/facter/facts.d/type.txt',
    line  => 'lustre_installed=true',
    match => 'lustre_installed=true',
  }
  file { '/etc/modprobe.d/lustre.conf':
    mode    => '0644',
    owner   => root,
    group   => root,
    content => template('profile/lustre/lustre_conf.epp'),
  }
  file_line { 'fstab_lustre_entry':
    path  => '/etc/fstab',
    line  => "${ip1}@tcp:${ip2}@tcp:${ip3}@tcp:${ip4}@tcp:/pfs/hpc /hpc lustre defaults,_netdev,x-systemd.automount,x-systemd.requires=openibd.service,x-systemd.after=wait-for-ping.service 0 0", # lint:ignore:140chars
    match => "${ip1}@tcp:${ip2}@tcp:${ip3}@tcp:${ip4}@tcp",
  }
  -> mount { '/home':
    ensure => absent,
  }
  -> file { '/hpc':
    ensure => directory,
  }
  -> exec {'mount_a':
    command => '/bin/mount -a',
  }
  -> file { '/tcs':
    ensure => link,
    target => '/hpc',
  }
  -> file { '/home':
    ensure => link,
    force  => true,
    target => "/tcs/${location}/home",
  }
  package { 'python3-dnf-plugin-versionlock':
    ensure => 'installed',
  }
  -> file { '/etc/dnf/plugins/versionlock.list':
    mode    => '0644',
    owner   => root,
    group   => root,
    content => template('profile/lustre/versionlock_list.epp'),
  }
  file { '/etc/systemd/system/wait-for-ping.service':
    content => template('profile/lustre/wait_for_ping_service.epp'),
  }
  ~> service {'wait-for-ping':
    ensure => 'running',
    enable => true,
  }
}
