class ss_auditd::install inherits ::ss_auditd {

    package { 'auditd':
        ensure  => 'present',
        require => Class['::apt::update']
    }

}
