jboss7-standalone with self signed SSL certificate
========================

 
Install Vagrant 1.4+

Install Vagrant Plugin openstack

Install Ansible

Enter your credentials ENV[OS_XXX] in the Vagrantfile

Update the hosts file with your public @ip of your vm.

    vagrant up --provider=openstack


NB: Coming war deployment with ansible 
