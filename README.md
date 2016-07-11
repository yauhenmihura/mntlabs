# vagrant

Task 1. Vagrant

1. Install Virtualbox and Vagrant

![alt text](https://github.com/yauhenmihura/vagrant/blob/master/sources/pics/1.png "task1")
![alt text](https://github.com/yauhenmihura/vagrant/blob/master/sources/pics/11.png "task1")

2. Initialize new Vagrant project

![alt text](https://github.com/yauhenmihura/vagrant/blob/master/sources/pics/1.png "task2")

3. Update configuration to use specific vagrant box (sbeliakou/centos-6.7-x86_64)

cd mntlab
vagrant box add sbeliakou/centos-6.7-x86_64 /opt/sbeliakou-vagrant-centos-6.7-x86_64.box 

4. Configure multiple VM’s in single Vagrantfile (2 VM’s):
VM1: httpd, mod_jk installed, configured as web frontend for VM2
VM2: tomcat 8 (and all needed dependencies) installed

5. Customize VMs’ settings:
VM1: 512 MB RAM, 1 CPU
VM2: 1 GB RAM, CPU execution cap 35%

6. Mount host directories into VMs, specify ownerships

![alt text](https://github.com/yauhenmihura/vagrant/blob/master/sources/pics/mount.png "task6")

7. Define shell provisioners:
default provisioner (performs on both VMs)
web.sh script installs and configures httpd and mod_jk (VM1)
app.sh script installs and configures tomcat and its dependencies (VM2)

VagrantFile 
![alt text](https://github.com/yauhenmihura/vagrant/blob/master/sources/pics/Vagrantfile.png "task7")

web.conf
![alt text](https://github.com/yauhenmihura/vagrant/blob/master/sources/pics/web.png "task7")

app.conf
![alt text](https://github.com/yauhenmihura/vagrant/blob/master/sources/pics/app.png "task7")

Result
![alt text](https://github.com/yauhenmihura/vagrant/blob/master/sources/pics/result.png "task7")
