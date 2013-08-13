class jenkins::service {
  service { 'jenkins':
    ensure     => running,
    enable     => true,
    restart    => '/usr/sbin/service jenkins restart; export ret=$?; sleep 5; exit $?',
    hasstatus  => true,
    hasrestart => true,
  }
}
