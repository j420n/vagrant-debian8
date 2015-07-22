##Vagrant Development Environment
>This Vagrant setup is used to test the [silex-puppet-control] repo on a Debian 8 virtual machine.

>It is configured to be a puppet master and it is capable of hosting a xen linux system.

To test:

    git clone https://github.com/j420n/vagrant-debian8.git
    cd vagrant-debian8
    vagrant up
    vagrant ssh

Yes, it is that easy.

[silex-puppet-control]: https://github.com/j420n/silex-puppet-control.git
