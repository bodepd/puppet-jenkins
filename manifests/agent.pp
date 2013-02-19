#
#  used to configure an agent as a jenkins::agent
#
#  This define can be used to create agents that are authenticated with a
#  jenkins master.
#
# == Parameters
#   [name] name used to identify and connect to this agent.
#   [server] jenkins server.
#   [username] username used to authenticate with jenkins server.
#   [password] password used to authenticate with jenkins server.
#   [executors] number of jenkins jobs that can be run on this host at the same time.
#   [laucher] type of launcher to make this host. Accepts ssh and jnlp.
#     Optional. Defaults to ssh.
#   [homedir] Home directory of jenins jobs. Optional. Default to /home/jenkins.
#   [ssh_user] The user jenkins uses to communicate with agent.
#   [ssh_password] The password the master uses to authenticate with agent.
#     Required if a password is used for auth over ssh.
#   [ssh_key] Key users by the master to authenticate with agent.
#     Required if a key is used for auth over ssh.
#   [labes] Labels added to jenkins agent.
#   [create_user] If the ssh user should be created for auth on the agent.
define jenkins::agent (
  $server       = undef,
  $port         = 8080,

  $username     = undef,
  $password     = undef,

  $executors    = undef,
  $launcher     = 'ssh',
  $homedir      = '/home/jenkins',
  $ssh_user     = 'jenkins',
  $ssh_key      = undef,
  $ssh_password = undef,
  $labels       = undef,
  $create_user  = false
) {

  require 'java'

  if ($create_user) {
    User[$ssh_user] -> Jenkins_agent<| title == $name |>
    user { $ssh_user:
      shell      => '/bin/bash',
      home       => $homedir,
      managehome => true,
    }
    exec { 'update_jenkins_password':
      command     => "/bin/echo ${ssh_user}:${ssh_password} | /usr/sbin/chpasswd",
      refreshonly => true,
      subscribe   => User[$ssh_user],
      before      => Jenkins_agent[$name],
    }
  }

  if ($server) {
    jenkins_agent { $name:
      server       => $server,
      port         => $port,

      username     => $username,
      password     => $password,

      executors    => $executors,
      launcher     => $launcher,
      homedir      => $homedir,
      ssh_user     => $ssh_user,
      ssh_key      => $ssh_key,
      ssh_password => $ssh_password,
      labels       => $labels,
    }
  }

}
