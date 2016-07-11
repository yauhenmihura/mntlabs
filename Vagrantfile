# Vagrant conf.

Vagrant.configure("2") do |config|
  
  config.vm.synced_folder "/opt/vagrant/mntlab", "/mnt", 
  owner: "vagrant", group: "vagrant", 
  create: true  

# First virtual machine with httpd, mod_jk 

  config.vm.define "web", primary:true do |web|
    web.vm.box = "sbeliakou/centos-6.7-x86_64"
    web.vm.hostname = "web"
    web.vm.network "private_network", ip: "192.168.25.10"
    web.vm.provider "virtualbox" do |machine|
      machine.name = "web-fronted"
      machine.memory = "512"    
      machine.cpus = 1
    end
    web.vm.provision "shell", path: "/sources/web.sh" 
  end

# Second virtual machine with tomcat

  config.vm.define "db" do |db|
    db.vm.box = "sbeliakou/centos-6.7-x86_64"
    db.vm.hostname = "db"
    db.vm.network "private_network", ip: "192.168.25.11"
    db.vm.provider "virtualbox" do |machine|
       machine.name = "db-backend"
       machine.memory = "1024"
       machine.customize ["modifyvm", :id, "--cpuexecutioncap", "35"]    
       end  
    db.vm.provision "shell", path: "/sources/app.sh"
  end
end
