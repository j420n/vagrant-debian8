# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. For a complete reference,
  # please see the online documentation at vagrantup.com.

  #Set VM hostname
  #You will need to create hieradata in Silex Puppet Control repo,
  #when you change the hostname to anything other than debian8-xen, dev or vps.
  config.vm.hostname = "debian8-xen"
  # Use a shell provisioner to Vagrant here which will use
  # rake inside the VM to run vagrant:provision
  # Put a custom vagrant.pp in this directory if you want to run your own manifest.
  config.vm.provision :shell, :path => "vagrant-provision.sh"

 # Use VBoxManage to customize the VM. For example to change memory:
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "debian-8"
  config.vm.box_url = "https://github.com/holms/vagrant-jessie-box/releases/download/Jessie-v0.1/Debian-jessie-amd64-netboot.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 9898

  # Create a public network, which generally matched to bridged network.
  config.vm.network "public_network"

  # Share an additional folder to the guest VM.
  config.vm.synced_folder "vagrant_synced", "/vagrant"


end
