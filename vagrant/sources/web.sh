#!/bin/bash

# Installing libraries 
sudo yum install httpd-devel php-devel php-pear apr apr-devel apr-util apr-util-devel gcc gcc-c++ make autoconf libtool -y

# Openning ports
sudo iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT && echo "Opened port 80" 
sudo iptables-save && echo "Saving this data"
sudo service iptables restart && echo "Restarting iptables" 

# Installing httpd
sudo yum install httpd -y && echo "Httpd installed"
sudo chkconfig httpd on && echo "Added to boot"
sudo service httpd start && echo "Started httpd"

# Installing mod_jk
cd /opt
sudo wget http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.41-src.tar.gz && echo "Downloading mod_jk"
sudo tar -xvzf tomcat-connectors-1.2.41-src.tar.gz
cd tomcat-connectors-1.2.41-src/native
sudo ./configure --with-apxs=/usr/sbin/apxs
sudo make
sudo make install
sudo cp /opt/tomcat-connectors-1.2.41-src/native/apache-2.0/mod_jk.so /etc/httpd/modules/
echo "Installed mod_jk"

# Configuring mod_jk
sudo chmod /etc/httpd/conf/httpd.conf
sudo echo $'JkWorkersFile /etc/httpd/conf/workers.properties
JkLogFile /var/log/httpd/mod_jk.log
JkLogLevel info
JkLogStampFormat "[%a %b %d %H:%M:%S %Y]"
JkOptions +ForwardKeySize +ForwardURICompat -ForwardDirectories\n
JkRequestLogFormat "%w %V %T
LoadModule jk_module modules/mod_jk.so
<VirtualHost *:80>
 ServerName www.localhost.com
 ServerAlias localhost.com
JkMount / tomcat
JkMount /* tomcat
</VirtualHost>' >> /etc/httpd/conf/httpd.conf && echo "Editing httpd.conf"
sudo echo $'worker.list=tomcat 
#Settings for Tomcat
worker.tomcat.port=8009
worker.tomcat.host=192.168.25.11
worker.tomcat.type=ajp13
worker.tomcat.lbfactor=1' > /etc/httpd/conf/workers.properties & echo "Creating workers.properties"

sudo service httpd restart















