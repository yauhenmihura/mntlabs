Report Table:

| Issue         |  How to find  | Time to find  | How to fix | Time to fix  |
| ------------- | ------------- |:-------------:| ---------- |:------------:|
|Apache doesnt work on default address and redirect on http://mntlab |- used curl -IL 192.168.56.10 from local and global hosts and got different response - used tail -f acces.log|2 min|Used apachectl -S to check syntax. Result: Configuration has two vitrualhosts. One of them in httpd.conf and another one in vhost.conf. Then opened these two files and tried to find incorrect syntax.I made the following changes: - in httpd.conf: removed which redirects to mntlab - in vhosts.conf changhed to. - apachectl restart and then - used curl -IL 192.168.56.10 from both hosts. Result: got error 503 from application server|30 min|
|Tomcat is not running|- ps -ef ```|``` grep tomcat. Tomcat is not running. - service tomcat start. Then also ps -ef ```|``` grep tomcat. Tomcat is not running. Checked /etc/init.d/tomcat. - try to start /opt/apache/tomcat//current/bin/startup.sh".- used tail -f catalina.out|5 min|Went to /etc/init.d/ and removed /dev/null. Tried to start tomcat service. Then I got error “can’t find setclasspath.sh”. I tried to found this string in tomcat configs. And found incorrect variables in bashrc and commented them. - Then I tried to start tomcat again and got error about java, checked logs, checked current version of java and configured alternatives --config java 1. - service tomcat start. Tomcat is starting. netstat -natupl ```|``` grep java. Port is listening. curl -IL 192.168.56.10:8080 and got response|30 min|
|Workers doesn't work|tail -f /var/log/httpd/mod_jk. cat /etc/httpd/conf.d/workers.properties|5min|I opened modjk log. This file had some errors with tomcat.worker. I opened workers.properties and fixed incorrect parameters for worker names and IP. apachectl -k graceful curl -IL 192.168.56.10|30 min|
|iptables doesnt start|iptables -L -n. service is not running. lsattr ```|```grep iptables|10 min|I checked iptables and restarted them. It didn't start due to error in line with COMMIT. Then I couldn't edit /etc/sysconfig/iptables from root. I found next command in google and checked this file with command lsattr ```|```grep iptables and found that this file had immunity attribute. Then I used command chattr -i /etc/sysconfig/iptables, opened with vim and tried to rewrote line “commit”, and checked other lines. Added -A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT to open port 80. Found mistake in -A INPUT -m state --state RELATED -j ACCEPT and added ESTABLISHED after RELATED. Then restarted iptables. It started successful.|30 min|

Additional Questions:
What java version is installed?

[vagrant@mntlab ~]$ java -version
java version "1.7.0_79"
Java(TM) SE Runtime Environment (build 1.7.0_79-b15)
Java HotSpot(TM) 64-Bit Server VM (build 24.79-b02, mixed mode)

How was it installed and configured?

It was installed in /opt/oracle/java/x64/ and configured with alternatives
Also we can configured with JAVA_HOME

Where are log files of tomcat and httpd?
Httpd: /var/log/httpd/
tomcat: /opt/apache/tomcat/7.0.62/logs/
But we can make symbol link for tomcat logs to /var/logs/tomcat/. It more comfortable

Where is JAVA_HOME and what is it?
JAVA_HOME is a variables that helps to locate JDK and JRE to other applications.
In general located in user ~/.bash_profile

Where is tomcat installed?
Tomcat installed in /opt/apache/tomcat/7.0.62/

What is CATALINA_HOME?
It is home directory of tomcat: /opt/apache/tomcat/7.0.62/

What users run httpd and tomcat processes? How is it configured?
Httpd: user: apache, this user is configured in httpd.conf “User apache”
tomcat: su tomcat in /etc/init.d/tomcat

What configuration files are used to make components work with each other?
Httpd.conf, vhost.conf, workers.properties, server.xml
What does it mean: “load average: 1.18, 0.95, 0.83”?
one unit per one core












