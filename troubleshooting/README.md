<html>
<header>
<h2> Report Table:</h2>
</header>
<body>
<table fontsize="5" text-align="left" border="1">
<tr>
  <td width="15$%" align="center"><b>Issue</b></td>
  <td align="center"><b>How to find</b</td>
  <td align="center"><b>Time to find</b</td>
  <td align="center"><b>How to fix</b</td>
  <td align="center"><b>Time to fix</b</td>
 </tr>
<tr> 
  <td>Apache doesnt work on default address and redirect on http://mntlab</td>
  <td>- used curl -IL 192.168.56.10 from local and global hosts and got different response
- used tail -f acces.log
</td>
  <td>2 min</td>
  <td>Used apachectl -S to check syntax. 
Result: Configuration has two vitrualhosts. One of them in httpd.conf and another one in vhost.conf 
Then opened these two files and tried to find incorrect syntax.
I made the following changes:
- in httpd.conf:
removed virtualhosts which redirects to mntlab
- in vhosts.conf changed vhost from mntlab to *:80
- apachectl restart and then 
- used curl -IL 192.168.56.10 from both hosts
Result: got error 503 from application server
</td>
  <td>30 min</td>
</tr>
<tr>
  <td>Tomcat is not running</td>
  <td>- ps -ef | grep tomcat
Tomcat is not running  
- service tomcat start
then also ps -ef | grep tomcat
Tomcat is not running
Checked /etc/init.d/tomcat
- try to start
/opt/apache/tomcat//current/bin/startup.sh"
- used tail -f catalina.out
</td>
  <td>5 min</td>
  <td>Went to /etc/init.d/ and removed /dev/null 
Tried to start tomcat service. Then I got error “can’t find setclasspath.sh”. I tried to found this string in tomcat configs. And found incorrect variables in bashrc and commented them.
- Then I tried to start tomcat again and got error about java, checked logs, checked current version of java and configured alternatives --config java 1
- service tomcat start
Tomcat is starting
netstat -natupl | grep java. Port is listening. 
curl -IL 192.168.56.10:8080 and got response
</td>
  <td>30 min</td>
</tr>
<tr>
  <td>Workers doesn't work</td>
  <td>tail -f /var/log/httpd/mod_jk
cat /etc/httpd/conf.d/workers.properties
</td>
  <td>5 min</td>
  <td>I opened modjk log. This file had some errors with tomcat.worker. I opened workers.properties and fixed incorrect parameters for worker names and IP.
apachectl -k graceful
curl -IL 192.168.56.10
</td>
  <td>30 min</td>
</tr>
<tr>
  <td>iptables doesnt start </td>
  <td>iptables -L -n
service is not running
lsattr |grep iptables
</td>
  <td>10 min</td>
  <td>I checked iptables and restarted them.
It didn't start due to error in line with COMMIT.
Then I couldn't edit /etc/sysconfig/iptables from root. I found next command in google and checked this file with command lsattr |grep iptables and found that this file had immunity attribute. 
Then I used command chattr -i /etc/sysconfig/iptables, opened with vim and tried to rewrote line “commit”, and checked other lines. 
Added -A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT to open port 80. 
Found mistake in -A INPUT -m state --state RELATED -j ACCEPT and added ESTABLISHED after RELATED. Then restarted iptables. It started successful.
</td>
  <td>30 min</td>
</tr>
</table>

<p><b>Additional Questions:
<br>What java version is installed?</b></p>

[vagrant@mntlab ~]$ java -version
<br>java version "1.7.0_79"
<br>Java(TM) SE Runtime Environment (build 1.7.0_79-b15)
<br>Java HotSpot(TM) 64-Bit Server VM (build 24.79-b02, mixed mode)

<p><b>How was it installed and configured?</b></p>

It was installed in /opt/oracle/java/x64/ and configured with alternatives
<br>Also we can configured with JAVA_HOME

<p><b>Where are log files of tomcat and httpd?</b></p>

Httpd: /var/log/httpd/
<br>tomcat: /opt/apache/tomcat/7.0.62/logs/
<br>But we can make symbol link for tomcat logs to /var/logs/tomcat/. It more comfortable

<p><b>Where is JAVA_HOME and what is it?</b></p>
JAVA_HOME is a variables that helps to locate JDK and JRE to other applications.
In general located in user ~/.bash_profile

<p><b>Where is tomcat installed?</b></p>
Tomcat installed in /opt/apache/tomcat/7.0.62/

<p><b>What is CATALINA_HOME?</b></p>
It is home directory of tomcat: /opt/apache/tomcat/7.0.62/

<p><b>What users run httpd and tomcat processes? How is it configured?</b></p>
Httpd: user: apache, this user is configured in httpd.conf “User apache”
tomcat: su tomcat in /etc/init.d/tomcat

<p><b>What configuration files are used to make components work with each other?</b></p>
Httpd.conf, vhost.conf, workers.properties, server.xml
What does it mean: “load average: 1.18, 0.95, 0.83”?
one unit per one core

</body>
</html>









