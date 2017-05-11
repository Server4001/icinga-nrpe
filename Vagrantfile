# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "icinga" do |icinga|
    icinga.vm.box = "bento/centos-6.7"
    icinga.vm.box_version = "2.2.7"

    icinga.vm.network :private_network, ip: "192.168.38.10"

    icinga.vm.hostname = "dev.icinga.loc"
    icinga.vm.synced_folder "./", "/vagrant", mount_options: ["dmode=777,fmode=777"]

    icinga.vm.provision :shell, path: "provision/icinga.sh", privileged: true

    icinga.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      vb.customize ["modifyvm", :id, "--cpus", "1"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
  end

  (1..3).each do |i|
    config.vm.define "web#{i}" do |web|
      web.vm.box = "server4001/php71-centos"
      web.vm.box_version = "0.1.0"

      web.vm.network :private_network, ip: "192.168.38.1#{i}"

      web.vm.hostname = "dev.icinga-web#{i}.loc"
      web.vm.synced_folder "./", "/vagrant", mount_options: ["dmode=777,fmode=777"]

      web.vm.provision :shell, path: "provision/web.sh", privileged: true

      web.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--memory", "512"]
        vb.customize ["modifyvm", :id, "--cpus", "1"]
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      end
    end
  end

end
