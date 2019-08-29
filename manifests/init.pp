class ss_auditd (
) {
    class { 'ss_auditd::install': }
    -> class { 'ss_auditd::config': }
}
