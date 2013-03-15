#
# installs a jenkins server
#
# This module installs a basic jenkins server.
#
# == Parameters
#  [version] Version of jenkins to install. Optional. Defaults to installed
#      (meaning install the latest version if one is not already installed)
#  [site_alias]
#  [setup_auth] Determines if jenkins should be installed with some basic auth.
#    It setups jenkins to use its own user database, where logged in users can do
#    anything. It also creates a default user jenkins_user with password
#    jenkins_password. Optional. Defaults to false.
#  [home_dir] Home directory used to configure jenkins. Optional. Default to
#    /var/lib/jenkins
#
define jenkins::server (
  $version = 'installed',
  $site_alias = undef,
  $setup_auth = false,
  $home_dir   = '/var/lib/jenkins'
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

  File {
    owner   =>'jenkins',
    group   => 'nogroup',
  }

  if $setup_auth {
    file { "${home_dir}/config.xml":
      source => 'puppet:///modules/jenkins/config.xml',
      require => Class['jenkins::service'],
    }
    file { ["${home_dir}/users", "${home_dir}/users/jenkins_user"]:
      ensure => directory,
      require => Class['jenkins::service'],
    }
    file { "${home_dir}/users/jenkins_user/config.xml":
      source => 'puppet:///modules/jenkins/jenkins_user_config.xml',
      require => Class['jenkins::service'],
    }
    $jenkins_url  = 'http://127.0.0.1:8080/'
    $cli_jar_path = '/var/cache/jenkins/war/WEB-INF/jenkins-cli.jar'
    exec { 'reload_account_config':
      command     => "/usr/bin/java -jar ${cli_jar_path} -s ${jenkins_url} reload-configuration",
      refreshonly => true,
      # this seems to allways return 1, even when successful
      returns     => [0,1],
      subscribe   => File["${home_dir}/config.xml", "${home_dir}/users/jenkins_user/config.xml"]
    }
  }

  # Collect agents associated with this server
  Jenkins_agent <<| server == $real_site_alias |>>
  if ($real_site_alias != $::fqdn) {
    Jenkins_agent <<| server == $::fqdn |>>
  }

  Class['jenkins::repo'] ->
  Class['jenkins::package'] ->
  Class['jenkins::service']
}
