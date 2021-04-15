#!/bin/sh

# setting  MYos variable
MYOS=$(hostnamectl | awk '/Operating/ { print $3 }')
OSVERSION=$(hostnamectl | awk '/Operating/ { print $5 }'| cut -f1-2 -d".")
#check cpu virtualization status
egrep '^flags.*(vmx|svm)' /proc/cpuinfo || (echo enable CPU virtualization support and try again && exit 9)



#### CentOS config
if [ $MYOS = "CentOS" ]
then
	if [ $OSVERSION = 7 ]
	then
		sudo rpm -Uvh https://yum.puppet.com/puppet5-release-el-7.noarch.rpm
		
	fi
	if [ $OSVERSION = 6 ]
	then
		sudo rpm -Uvh https://yum.puppet.com/puppet5-release-el-6.noarch.rpm
		
	fi
    if [ $OSVERSION = 5 ]
	then
		wget https://yum.puppet.com/puppet5-release-el-5.noarch.rpm
        sudo rpm -Uvh puppet5-release-el-5.noarch.rpm
		
	fi
    sudo yum install 

	
fi

### Ubuntu config
if [ $MYOS = "Ubuntu" ]
then
    if [ $OSVERSION = 18.04 ]
	then
		wget https://apt.puppetlabs.com/puppet5-release-bionic.deb
		sudo dpkg -i puppet5-release-bionic.deb
		sudo apt update
		
	fi
	if [ $OSVERSION = 16.04 ]
	then
		wget https://apt.puppetlabs.com/puppet5-release-xenial.deb
		sudo dpkg -i puppet5-release-xenial.deb
		sudo apt update
		
	fi
	if [ $OSVERSION = 14.04 ]
	then
		wget https://apt.puppetlabs.com/puppet5-release-trusty.deb
		sudo dpkg -i puppet5-release-trusty.deb
		sudo apt-get update
		
	fi
	sudo apt-get install puppet-agent
fi