class ss_auditd::config inherits ::ss_auditd {

  service { 'auditd':
    ensure     => true,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['auditd'],
  }

  file { '/etc/audit/auditd.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('ss_auditd/etc/audit/auditd.conf.erb'),
    require => Package['auditd'],
    notify  => Service['auditd'],
  }

  # we want to use the rules.d folder and the 'augenrules' to compile them into the config. This makes it possible
  # for other modules to drop their rules into the config folder and just restart the auditd service
  file { '/etc/audit/rules.d/audit.rules':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('ss_auditd/etc/audit/rules.d/audit.rules.erb'),
    require => Package['auditd'],
    notify  => Service['auditd'],
  }

  file { '/etc/systemd/system/auditd.service':
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('ss_auditd/etc/systemd/system/auditd.service'),
    require => File[ '/etc/audit/rules.d/audit.rules' ],
  }
  ~> exec { 'myservice-systemd-reload':
    command     => 'systemctl daemon-reload',
    path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    refreshonly => true,
  }

  # set same defaults so we dont get different behaviour between ubuntu and debian
  file { '/etc/default/auditd':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('ss_auditd/etc/default/auditd.erb'),
    require => Package['auditd'],
    notify  => Service['auditd'],
  }

  file { '/etc/rsyslog.d/auditd.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    source  => 'puppet:///modules/ss_auditd/rsyslogd.conf',
    require => Package['auditd'],
    notify  => Service['rsyslog'],
  }

}
