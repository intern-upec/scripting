#!/bin/sh

# setting  MYos variable
MYOS=$(hostnamectl | awk '/Operating/ { print $3 }')
OSVERSIONC=$(hostnamectl | awk '/Operating/ { print $5 }')
OSVERSIONU=$(hostnamectl | awk '/Operating/ { print $4 }'| cut -f1-2 -d".")
#check cpu virtualization status
egrep '^flags.*(vmx|svm)' /proc/cpuinfo || (echo Enable CPU virtualization support and try again && exit 9)



#### CentOS config
if [ $MYOS = "CentOS" ]
then
	if [ $OSVERSIONC = 7 ]	
	then	
		sudo rpm -Uvh https://yum.puppet.com/puppet5-release-el-7.noarch.rpm

	fi	
	if [ $OSVERSIONC = 6 ]	
	then
		sudo rpm -Uvh https://yum.puppet.com/puppet5-release-el-6.noarch.rpm
		
	fi
    if [ $OSVERSIONC = 5 ]
	then
		wget https://yum.puppet.com/puppet5-release-el-5.noarch.rpm
        sudo rpm -Uvh puppet5-release-el-5.noarch.rpm
		
	fi
	sudo yum update -y
	sudo yum install -y net-tools
	hostnamectl set-hostname "firstname-lastname-i"
	echo "192.168.1.1      puppetmaster.i" >> /etc/hosts
	ip=`ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'|head -1`
	echo $ip "     puppetmaster.i" >> /etc/hosts
    sudo yum install puppet-agent
	ln -s /opt/puppetlabs/bin/puppet /usr/bin/puppet
    puppet config set certname "firstname-lastname-i"
	puppet config set server "puppetmaster.i"
	systemctl start puppet
fi

### Ubuntu config
if [ $MYOS = "Ubuntu" ]
then
    if [ $OSVERSIONU = 18.04 ]
	then
		wget https://apt.puppetlabs.com/puppet5-release-bionic.deb
		sudo dpkg -i puppet5-release-bionic.deb
		sudo apt update 
		
	fi
	if [ $OSVERSIONU = 16.04 ]
	then
		wget https://apt.puppetlabs.com/puppet5-release-xenial.deb
		sudo dpkg -i puppet5-release-xenial.deb
		sudo apt update
		
	fi
	if [ $OSVERSIONU = 14.04 ]
	then
		wget https://apt.puppetlabs.com/puppet5-release-trusty.deb
		sudo dpkg -i puppet5-release-trusty.deb
		sudo apt-get update
		
	fi
	sudo apt-get update -y
	sudo apt-get install -y net-tools  
	hostnamectl set-hostname "firstname-lastname-i"
	ip=`ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'|head -1`
	echo $ip "     firstname-lastname-i" >> /etc/hosts
	echo "192.168.1.1     puppetmaster.i" >> /etc/hosts
	sudo apt-get install puppet-agent
	ln -s /opt/puppetlabs/bin/puppet /usr/bin/puppet
    puppet config set certname "firstname-lastname-i"
	puppet config set server "puppetmaster.i"
	systemctl start puppet
fi