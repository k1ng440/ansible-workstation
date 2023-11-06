# vim: set ft=ruby

Vagrant.configure("2") do |config|
  config.vm.hostname = 'ansible-test-vm'
  config.vm.synced_folder ".", "/vagrant", disabled: false

  config.vm.box = "generic/ubuntu2204"

  # config.vm.provider :docker do |docker, override|
  #   override.vm.box = "tknerr/baseimage-ubuntu-22.04"
  #   docker.image = "tknerr/baseimage-ubuntu-22.04:latest"
  #   docker.create_args = [
  #     # docker (in-docker) needs privileges for creating the docker socket
  #     "--cap-add=NET_ADMIN",
  #     # mount the X11 unix socket into the container
  #     "-v", "/tmp/.X11-unix:/tmp/.X11-unix:rw"
  #   ]
  # end

  config.vm.provider "virtualbox" do |vbox, override|
    vbox.cpus = 4
    vbox.memory = 4096
    vbox.customize ["modifyvm", :id, "--name", "Ansible Test VM"]
    vbox.customize ["modifyvm", :id, "--usb", "on"]
    vbox.customize ["modifyvm", :id, "--accelerate3d", "off"]
    vbox.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]
    vbox.customize ["modifyvm", :id, "--vrde", "off"]
  end

  config.vm.provider "vmware_desktop" do |vmware, override|
    vmware.vmx["displayname"] = "Ansible Test VM"
    vmware.vmx["numvcpus"] = "4"
    vmware.vmx["memsize"] = "4096"
    vmware.vmx["usb.present"] = "TRUE"
    vmware.vmx["usb.pcislotnumber"] = "33"
    vmware.vmx["usb_xhci.present"] = "TRUE"
  end

  config.vm.provision "shell", privileged: true, path: 'scripts/setup-vm-user.sh', args: "k1ng passwd"
  config.vm.provision "shell", privileged: true, keep_color: true, run: "always", inline: <<-EOF
    ls -alh /vagrant
    sudo -i -u k1ng ROLE_TAGS=#{ENV['ROLE_TAGS']} /vagrant/scripts/update-vm.sh
  EOF
end
