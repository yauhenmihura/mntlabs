#!/bin/bash

# Restore httpd.conf and vhost.conf
sed -i '/^[ \t]*<VirtualHost*/,/<\/VirtualHost>/s/^/#/g' /etc/httpd/conf/httpd.conf 
sed -i 's/<VirtualHost mntlab\:80>/<VirtualHost \*:80>/g' /etc/httpd/conf.d/vhost.conf 
sed -i '5a\ServerName 192\.168\.56\.10\' /etc/httpd/conf/httpd.conf
apachectl restart

# Restore init.d  tomcat
sed -i 's/> \/dev\/null//g' /etc/init.d/tomcat
sed -i '/success/d' /etc/init.d/tomcat
chkconfig tomcat on

# Restore tomcat configuration
sed -i '/^[ \t]*export*/s/^/#/g' /home/tomcat/.bashrc
source /home/tomcat/.bashrc
chown -R  tomcat:tomcat /opt/apache/tomcat/7.0.62/logs/

# Restore mod_jk in workers.properties
sed -i 's/template/tomcat\.worker/g' /etc/httpd/conf.d/workers.properties
sed -i 's/worker\-jk\@ppname/tomcat\.worker/g' /etc/httpd/conf.d/workers.properties
sed -i '/reference/d' /etc/httpd/conf.d/workers.properties
sed -i 's/192.168.56.100/192.168.56.10/g' /etc/httpd/conf.d/workers.properties

# Restore iptables
chattr -i /etc/sysconfig/iptables
echo '' >> /etc/sysconfig/iptables
sed -i 's/RELATED/RELATED,ESTABLISHED/' /etc/sysconfig/iptables 
sed -i '9a\-A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT\' /etc/sysconfig/iptables
service iptables start

# Add alternatives
alternatives --config java <<<1

# Starting services
service tomcat start
apachectl restart 






