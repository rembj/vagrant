# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANT_API_VERSION = '2'

Vagrant.configure(VAGRANT_API_VERSION) do |config|
  # Hostmanager https://github.com/smdahlen/vagrant-hostmanager
  config.hostmanager.enabled = true
  config.hostmanager.manage_guest = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = false

  config.vm.synced_folder '.', '/vagrant', disabled: true

  config.hostmanager.ip_resolver = proc do |machine|
    result = ""
    machine.communicate.execute("ip addr show eth1") do |type, data|
      result << data if type == :stdout
    end
    (ip = /inet (\d+\.\d+\.\d+\.\d+)/.match(result)) && ip[1]
  end

  # Using Vagrant's default ssh key
  config.ssh.insert_key = false
  # Your private key must be available to the local ssh-agent.
  # You can check with ssh-add -L
  # If your key is not listed add it with ssh-add ~/.ssh/id_rsa
  config.ssh.forward_agent = true

#  config.vm.provision "Fixing no TTY issue", type: "shell" do |s|
#    s.inline = "touch /root/.profile && sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
#  end

  vm_name = ENV['HOST_NAME']
  config.vm.define vm_name do |node|
    node.vm.hostname = vm_name
    node.vm.box = ENV['VAGRANT_BOX']


    node.vm.network "public_network", bridge: ENV['VAGRANT_NETWORK']

    config.vm.provider :virtualbox do |provider, override|
#      override.vm.network :public_network
      provider.memory = ENV['VAGRANT_HOST_RAM']
      provider.cpus = ENV['VAGRANT_HOST_CPUS']
      provider.name = vm_name
    end

    config.vm.provider :parallels do |provider, override|
      provider.memory = ENV['VAGRANT_HOST_RAM']
      provider.cpus = ENV['VAGRANT_HOST_CPUS']
      provider.name = vm_name
    end
  end
  config.trigger.after :up do |trigger|
    trigger.run = {inline: "vagrant hostmanager"}
  end
end
