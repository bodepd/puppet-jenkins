class jenkins::package (
  $version = 'installed',
) {
  package {
    'jenkins':
      ensure => $version,
  } ->
  user { 'jenkins':
    ensure => present,
  }
}
