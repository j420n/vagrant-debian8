#!/bin/bash
set -e

#Set Hostname
hostname debian8-xen.local.ghost

#Install some dependencies
echo >&2 "Installing git-core.";
apt-get install git-core -y

#Clone our control repo or pull any updates.
if [ -d /etc/puppet/silex-puppet-control ];
then
    echo >&2 "Updating Silex Puppet control.";
    cd /etc/puppet/silex-puppet-control
    git pull origin master
fi
if [ ! -d /etc/puppet/silex-puppet-control ];
then
    echo >&2 "Cloning the 'Control Repo'";
    if [ ! -d /etc/puppet ];
      then
        mkdir /etc/puppet
    fi
    cd /etc/puppet
    git clone https://github.com/j420n/silex-puppet-control.git
    echo >&2 "Checking out 'MASTER' environment branch.";
    cd /etc/puppet/silex-puppet-control
    git checkout master
fi

echo >&2 "Provisioning the base system.";
chmod u+x ./provision.sh
./provision.sh


