jboss7-standalone with self signed SSL certificate
========================


## Prereqs

Install the following applications on your local machine first:

 * [Vagrant](http://vagrantup.com)
 * [Vagrant openstack plugin] (https://github.com/ggiamarchi/vagrant-openstack-provider)
 * [Ansible](http://ansibleworks.com)
 

Enter your credentials ENV[OS_XXX] in the Vagrantfile

Update the hosts file with your public @ip of your vm.

Then  > vagrant up --provider=openstack


NB: Coming war deployment with ansible 
