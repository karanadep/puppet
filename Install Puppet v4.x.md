# Installing Puppet v4.x in server-client model on CentOS release 6.2 (Final)

This page describes installation of puppet on CentOS release 6.2 and we are dowloading repo from [puppetlabs rpm repository](rpm -i https://yum.puppetlabs.com/puppetlabs-release-pc1-el-6.noarch.rpm)

## Prerequisites
1. Installing rpm to get puppetlabs repository
```
rpm -i https://yum.puppetlabs.com/puppetlabs-release-pc1-el-6.noarch.rpm
```
Check if repository is created using command: 'rpm -qi puppetlabs-release-pc1-1.0.0-1.el6.noarch'

## Installing and configuring Puppet server
1. Install puppet server package
```shell
yum install -y puppetserver  
```

2. Configure puppet server, edit the file: /etc/puppetlabs/puppet/puppet.conf
```shell
[main]
server = SERVER_FQDN
certname = SERVER_FQDN
environment = production
#
[master]
vardir = /opt/puppetlabs/server/data/puppetserver
logdir = /var/log/puppetlabs/puppetserver
rundir = /var/run/puppetlabs/puppetserver
pidfile = /var/run/puppetlabs/puppetserver/puppetserver.pid
codedir = /etc/puppetlabs/code
```
Replace SERVER_FQDN with your puppet server's fully qualified domain name

3. Configure puppet server's JVM settings, edit the file /etc/sysconfig/puppetserver
```
JAVA_ARGS="-Xms2g -Xmx2g -XX:MaxPermSize=256m"
```
Replace SERVER_FQDN with your puppet server's fully qualified domain name

4. Staring Puppet server
```shell
service puppetserver start
```

5. Setting up auto signing of certificates with in the domain (optional), if this step is not performed you have to manually sign the certificates for each individual agent that is accessing the puppet server. Edit the file /etc/puppetlabs/puppet/autosign.conf
```shell
172.17.3.217
```
Replace it will FQDN like *.cloudwick.com created by you for your private network of nodes

## Installing and configuring Puppet Agent
1. Installing puppet client package
```shell
yum -y install puppet
```

2. Configure puppet client, by editing the config file: /etc/puppetlabs/puppet/puppet.conf
```shell
server = SERVER_FQDN
environment = production
runinterval = 1h
```
Replace SERVER_FQDN with fqdn of the puppet server

3. Update Path variable to add puppet, so that you dont have to run scripts using entire path
```
PATH=$PATH:/opt/puppetlabs/bin/
```

4. Start puppet agent
```
service puppet start
```

## Configuring Puppet Certificate on Agent and Server
1. Request for certificate signing from server
```shell
/opt/puppetlabs/bin/puppet agent --waitforcert 30 --server 172.17.5.51
```

2. Useful command to list all Certificates
```shell
puppet cert print --all
```
Plus(+) will be added at the beginning of certificates which have already been signed

Thats it :v: