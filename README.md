This Vagrant setup is used to test the silex-puppet-control repo on a debian 8 virtual machine.

To test:
git clone <this repo>
cd <this repo>
vagrant up
vagrant ssh
git clone silex-puppet-control
cd silex-puppet-control
r10k deploy development 

