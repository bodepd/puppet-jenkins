define jenkins::server (
  $version = 'installed',
  $site_alias = undef,
) {
  if ($site_alias) {
    $real_site_alias = $site_alias
  }
  else {
    $real_site_alias = $::fqdn
  }

  include jenkins::repo
  class { 'jenkins::package':
    version => $version,
  }

  include jenkins::service
  }

  # Collect agents associated with this server
  Jenkins_agent <<| server == $real_site_alias |>>
  if ($real_site_alias != $::fqdn) {
    Jenkins_agent <<| server == $::fqdn |>>
  }

  Class['jenkins::repo'] ->
  Class['jenkins::package'] ->
  Class['jenkins::service'] ->
}
