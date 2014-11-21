Provision jboss7-standalone with self signed SSL certificate + war deployment from github releases
========================


## Prereqs

Install the following applications on your local machine first:

 * [Vagrant](http://vagrantup.com)
 * [Vagrant openstack plugin] (https://github.com/ggiamarchi/vagrant-openstack-provider)
 * [Ansible](http://ansibleworks.com)
 
## Quick Start

After installing the applications above, the quickest way to get
started is to specify all the details manually within a `config.vm.provider`
block in the Vagrantfile

Reuse the Vagrantfile given, filling in your information
where necessary replacing each ENV['OS_XXXX'] according to your openstack provider account and credentials.


This Vagrantfile extract shows the needed configuration.

```ruby
require 'vagrant-openstack-provider'

Vagrant.configure("2") do |config|

  config.vm.box = "openstack"
  config.vm.box_url = "https://github.com/ggiamarchi/vagrant-openstack/raw/master/source/dummy.box"

  config.ssh.shell = "bash"
  config.ssh.username = "stack"

  config.vm.provider :openstack do |os|
    os.username = ENV['OS_USERNAME']
    os.password = ENV['OS_PASSWORD']
    os.tenant_name = ENV['OS_TENANT_NAME']
    os.openstack_auth_url = ENV['OS_AUTH_URL']
    os.openstack_compute_url = ENV['OS_COMPUTE_URL']
    os.openstack_network_url = ENV['OS_NETWORK_URL']    
  end

  config.vm.define 'test' do |test|
    test.vm.provider :openstack do |os|
      os.server_name = "test-jboss"
      os.floating_ip = ENV['OS_FLOATING_URL']
      os.flavor = ENV['OS_FLAVOR']
      os.image = ENV['OS_IMAGE']
      os.networks = [ENV['OS_NETWORK']]              
    end
  end

  # Install ansible  
  config.vm.provision "shell", path: "installAnsibleOnUbuntu.sh", privileged: "true"

  # update /etc/hosts with hostname @ip
  config.vm.provision "shell" do |s|
	s.inline = "echo $1 $2>> /etc/hosts"
	s.args = "127.0.0.1 'test-jboss'"
	s.privileged = "true"	
  end
```

Then run `vagrant up --provider=openstack`.


