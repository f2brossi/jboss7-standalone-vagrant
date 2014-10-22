require 'vagrant-openstack-provider'

Vagrant.configure("2") do |config|

  config.vm.box = "openstack"
  config.vm.box_url = "https://github.com/ggiamarchi/vagrant-openstack/raw/master/source/dummy.box"

  config.ssh.private_key_path = ENV['OS_KEYPAIR_PRIVATE_KEY']
  config.ssh.shell = "bash"

  config.vm.provider :openstack do |os|
    os.username = ENV['OS_USERNAME']
    os.password = ENV['OS_PASSWORD']
    os.openstack_auth_url = ENV['OS_AUTH_URL']
    os.openstack_compute_url = ENV['OS_COMPUTE_URL']
    os.openstack_network_url = ENV['OS_NETWORK_URL']
    os.tenant_name = ENV['OS_TENANT_NAME']
    os.keypair_name = ENV['OS_KEYPAIR_NAME']
  end

  config.vm.define 'test' do |test|
    test.vm.provider :openstack do |os|
      os.server_name = "test-jboss"
      os.floating_ip = ENV['OS_FLOATING_IP']"
      os.flavor = '4_vCPU_RAM_8G_HD_10G'
      os.image = 'ubuntu-12.04_x86-64_3.11-DEPRECATED'
      os.ssh_username = "stack"
      os.networks = ['net']
    end
  end

   # Install ansible  
  config.vm.provision "shell", path: "installAnsibleOnUbuntu.sh", privileged: "true"

 
  # update /etc/hosts with hostname @ip
  config.vm.provision "shell" do |s|
    s.inline = "echo $1 $2>> /etc/hosts"
    s.args = "'127.0.0.1' 'test-jboss'"
    s.privileged = "true"   
  end

  config.vm.provision :ansible do |ansible|
      ansible.playbook = "ansible-jboss/jboss.yml"
      ansible.verbose = "vv"
      ansible.limit = 'all'
      ansible.sudo = true 
  end

  config.vm.provision :ansible do |ansible|
      ansible.playbook = "ansible-jboss/jboss.yml"
  end

end
