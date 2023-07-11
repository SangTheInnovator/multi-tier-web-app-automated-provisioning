# Multi-tier Web Application Automated Provisioning

![diagram-picture](./picture/diagram.png)

<br>

## Pre-req

1. [Oracle VM Virtualbox](https://www.virtualbox.org/) - Allows you to create and run multiple virtual machines (VMs) on a single physical computer
2. [Vagrant](https://www.vagrantup.com/) -  Provides an easy way to set up and configure reproducible virtual machines or containers for development purposes.
3. [Vagrant plugins](https://github.com/devopsgroup-io/vagrant-hostmanager) - Vagrant-hostmanager is a Vagrant plugin that manages the host's file on guest machines (and optionally the host).
4. [Git bash](https://git-scm.com/downloads) -  Combines the power of Git, a widely-used version control system, with the command-line interface of Bash, a popular shell found in Unix-like operating systems.

## Provisioning services

1. Nginx:
   - Web Service
2. Tomcat Apache:
   - Application Service
3. RabbitMQ:
   - Message Broker
4. Memcached:
   - Database Caching
5. ElasticSearch:
   - Index/Search service
6. MySQL:
   - SQL Database
  
## Setup and Running locally
Firstly, we need to configure for the VMs by using Vagrantfile

**Vagrantfile**
```
Vagrant.configure("2") do |config|
    config.hostmanager.enabled = true 
    config.hostmanager.manage_host = true
    
    # Nginx VM 
    config.vm.define "web01" do |web01|
      web01.vm.box = "ubuntu/jammy64"
      web01.vm.hostname = "web01"
      web01.vm.network "private_network", ip: "192.168.56.11"
      web01.vm.provider "virtualbox" do |vb|
       vb.gui = true
       vb.memory = "800"
      end
      web01.vm.provision "shell", path: "nginx.sh"  
    end
    
    # Apache Tomcat VM
    config.vm.define "app01" do |app01|
      app01.vm.box = "eurolinux-vagrant/centos-stream-9"
      app01.vm.hostname = "app01"
      app01.vm.network "private_network", ip: "192.168.56.12"
      app01.vm.provision "shell", path: "tomcat.sh"  
      app01.vm.provider "virtualbox" do |vb|
       vb.memory = "800"
      end
    end

    # RabbitMQ VM
    config.vm.define "rmq01" do |rmq01|
      rmq01.vm.box = "eurolinux-vagrant/centos-stream-9"
    rmq01.vm.hostname = "rmq01"
      rmq01.vm.network "private_network", ip: "192.168.56.13"
      rmq01.vm.provider "virtualbox" do |vb|
       vb.memory = "600"
      end
      rmq01.vm.provision "shell", path: "rabbitmq.sh"  
    end

    # Memcached VM
    config.vm.define "mc01" do |mc01|
      mc01.vm.box = "eurolinux-vagrant/centos-stream-9"
      mc01.vm.hostname = "mc01"
      mc01.vm.network "private_network", ip: "192.168.56.14"
      mc01.vm.provider "virtualbox" do |vb|
       vb.memory = "600"
      end
      mc01.vm.provision "shell", path: "memcache.sh"  
    end
    
    # Database VM
    config.vm.define "db01" do |db01|
      db01.vm.box = "eurolinux-vagrant/centos-stream-9"
      db01.vm.hostname = "db01"
      db01.vm.network "private_network", ip: "192.168.56.15"
      db01.vm.provider "virtualbox" do |vb|
       vb.memory = "600"
      end
      db01.vm.provision "shell", path: "mysql.sh"  
    end

end
```


