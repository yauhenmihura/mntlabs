#!/bin/bash

# Openning ports
sudo iptables -A INPUT -p tcp -m tcp --dport 8080 -j ACCEPT && echo "Opened port 8080"
sudo iptables-save && sudo service iptables restart &&  echo "Editing iptables"
sudo yum install java -y && echo "Installing Java"

# Installing Tomcat
cd /opt
sudo wget http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-8/v8.0.36/bin/apache-tomcat-8.0.36.tar.gz
sudo tar xvzf apache-tomcat-8.0.36.tar.gz
chmod +x /opt/apache-tomcat-8.0.36/bin/*.sh
/opt/apache-tomcat-8.0.36/bin/startup.sh && echo "Tomcat Started"
