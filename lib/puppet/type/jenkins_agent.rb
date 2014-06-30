#
# This code came from an apache LICENCED Puppet Labs fork
#   https://github.com/sschneid/puppet-jenkins of
#   https://github.com/jenkinsci/puppet-jenkins
# which is apache licensed, so I think I'm good to go!
#
module Puppet
  newtype(:jenkins_agent) do
    ensurable do
      defaultvalues
      defaultto :present
    end

    newparam(:name) do
      desc "Hostname of the jenkins agent"
      isnamevar
    end

    newparam(:username) do
      desc "Username on the jenkins server"
      defaultto :false
    end

    newparam(:password) do
      desc "Password on the jenkins server"
      defaultto :false
    end

    newparam(:server) do
      desc "Hostname of the jenkins master"
    end

    newparam(:port) do
      desc 'port where jenkins server is hosted'
      defaultto 80
    end

    newparam(:executors) do
      desc "Number of executors"
      defaultto 5
    end

    newparam(:launcher) do
      desc "Type of connection. ssh or jnlp"
      newvalues :ssh, :jnlp
      defaultto :ssh
    end

    newparam(:homedir) do
      desc "Home directory of jenkins on this slave"
      defaultto "/home/jenkins"
    end

    newparam(:ssh_user) do
      desc "Username for the SSH launcher"
    end

    newparam(:ssh_key) do
      desc "Private key on the master for the SSH launcher"
    end

    newparam(:ssh_password) do
      desc 'Password to use on master for SSH Launcher'
    end

    newparam(:labels) do
      desc "Jenkins node labels"
    end
  end
end
