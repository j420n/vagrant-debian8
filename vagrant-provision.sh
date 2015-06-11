#!/bin/bash
set -e

#Install Puppet Labs repositories. DEBIAN
#SET hostname as vagrant will only set it to debian -> https://github.com/mitchellh/vagrant/issues/3271
hostname vps.radnetwork.co.uk
wget "https://apt.puppetlabs.com/puppetlabs-release-pc1-wheezy.deb"
sudo dpkg -i puppetlabs-release-pc1-wheezy.deb
sudo apt-get update

#Test for Puppet Master
command -v puppet master >/dev/null 2>&1 || {
                                      echo >&2 "Puppetmaster is required, but it is not installed.  Installing...";
                                      sudo apt-get -y -f install puppetmaster puppetmaster-common puppet-common;
                                     }

#Test for PuppetDB
if [ ! -d /etc/puppetdb ];
then
    echo >&2 "PuppetDB is required, but it is not installed.  Installing...";
    sudo apt-get -y install puppetdb;
    sudo apt-get -y install puppetdb-terminus;
    echo >&2 "PuppetDB is Installed.";
fi

#Clone our control repo
cd /vagrant
apt-get install git-core -y
rm -rf silex-puppet-control
git clone https://github.com/j420n/silex-puppet-control.git

#Install r10k from Debian repo.
apt-get install r10k -y

#Symlink hiera configuration to /etc/hiera.yaml
ln -sf /vagrant/silex-puppet-control/hiera.yaml /etc/hiera.yaml
ln -sf /vagrant/silex-puppet-control/r10k.yaml /etc/puppet/
ln -sf /vagrant/silex-puppet-control/puppet.conf /etc/puppet/
ln -sf /vagrant/silex-puppet-control/puppetdb.conf /etc/puppet/
ln -sf /vagrant/silex-puppet-control/environment.conf /etc/puppet/

if [ -d /etc/puppet ];
then
    echo >&2 "The local Puppet Master has been found. Welcome to the Puppet show.";
    sudo /etc/init.d/puppetdb restart;
    sudo /etc/init.d/puppetmaster restart;
    sudo /etc/init.d/puppetqd restart;
    puppet agent --enable
fi

