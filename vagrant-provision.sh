#!/bin/bash
set -e

#Set Hostname
hostname debian8-xen.radnetwork.co.uk

#Install Puppet Labs repositories.
if [ ! -f puppetlabs-release-pc1-wheezy.deb ];
then
  wget "https://apt.puppetlabs.com/puppetlabs-release-pc1-wheezy.deb"
  dpkg -i puppetlabs-release-pc1-wheezy.deb
fi
apt-get update

#Test for Puppet Master
command -v puppet master >/dev/null 2>&1 || {
                                      echo >&2 "Puppetmaster is required, but it is not installed.  Installing...";
                                      apt-get -y -f install puppetmaster puppetmaster-common puppet-common;
                                     }

#Test for PuppetDB
if [ ! -d /etc/puppetdb ];
then
    echo >&2 "PuppetDB is required, but it is not installed.  Installing...";
    apt-get -y install puppetdb;
    apt-get -y install puppetdb-terminus;
    echo >&2 "PuppetDB is Installed.";
fi

#Install some dependencies
echo >&2 "Installing git-core and deep_merge.";
apt-get install git-core hiera-eyaml -y
gem install deep_merge

#Clone our control repo or pull any updates.
if [ -d /vagrant/silex-puppet-control ];
then
    echo >&2 "Updating Silex Puppet control.";
    cd /vagrant/silex-puppet-control
    git pull origin xen
fi
if [ ! -d /vagrant/silex-puppet-control ];
then
    echo >&2 "Cloning the 'Control Repo'";
    cd /vagrant
    git clone https://github.com/j420n/silex-puppet-control.git
    echo >&2 "Checking out 'XEN' environment branch.";
    cd /vagrant/silex-puppet-control
    git checkout xen
fi

#Install r10k from Debian repo.
apt-get install r10k -y

echo >&2 "Deploying XEN environment...";
r10k deploy -c /vagrant/silex-puppet-control/r10k.yaml environment xen

#Symlink hiera and puppet configuration.
ln -sf /vagrant/silex-puppet-control/hiera.yaml /etc/puppet/
ln -sf /vagrant/silex-puppet-control/hiera.yaml /etc/
ln -sf /vagrant/silex-puppet-control/r10k.yaml /etc/puppet/
ln -sf /vagrant/silex-puppet-control/r10k.yaml /etc/
ln -sf /vagrant/silex-puppet-control/puppet.conf /etc/puppet/
ln -sf /vagrant/silex-puppet-control/puppetdb.conf /etc/puppet/

#Symlink manifest for profile::xen
mkdir -p /etc/puppet/environments/xen/site/profile/manifests
ln -sf /vagrant/silex-puppet-control/xen.pp /etc/puppet/environments/xen/site/profile/manifests/

#Configure Jetty host and port for puppetdb.
sed -i 's/# host = <host>/host = 127.0.1.1/g' /etc/puppetdb/conf.d/jetty.ini
sed -i 's/port = 8080/port = 8980/g' /etc/puppetdb/conf.d/jetty.ini
sed -i 's/# ssl-host = <host>/ssl-host = 0.0.0.0/g' /etc/puppetdb/conf.d/jetty.ini
sed -i 's/# ssl-port = <port>/ssl-port = 8981/g' /etc/puppetdb/conf.d/jetty.ini


if [ -f /etc/init.d/puppetmaster ];
then
    echo >&2 "The local Puppet Master has been found. Welcome to the Puppet show.";
    /etc/init.d/puppetdb restart;
    /etc/init.d/puppetmaster restart;
    /etc/init.d/puppetqd restart;
    puppet agent --enable
    puppetdb ssl-setup
fi

echo >&2 "Waiting 30 seconds for PuppetDB to start.";
until netstat -antpu | grep 8981;
  do sleep 30;
done

echo >&2 "Running Puppet Agent.";
puppet agent -t

