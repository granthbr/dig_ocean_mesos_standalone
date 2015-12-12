#!/bin/bash  
# store IP address 
IP=`wget http://ipecho.net/plain -O - -q ; echo` 
# java key
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EB9B1D8886F44E2A
# mesos key
apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF  
# docker key
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')  
CODENAME=$(lsb_release -cs)  
echo  "deb http://repos.mesosphere.io/ubuntu trusty main" | tee /etc/apt/sources.list.d/mesosphere.list  
echo "deb http://ppa.launchpad.net/openjdk-r/ppa/ubuntu trusty main" | tee /etc/apt/sources.list.d/openjdk-r-ppa-trusty.list
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | tee /etc/apt/sources.list.d/docker.list
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
apt-get -y update 
apt-get purge lxc-docker
# removed the sudo.. should be unecessary
apt-get -y install oracle-java8-installer linux-image-extra-$(uname -r)
apt-get -y install docker-engine marathon mesos  
dpkg --configure -a 
echo 'docker,mesos' > /etc/mesos-slave/containerizers
echo '5mins' > /etc/mesos-slave/executor_registration_timeout 
echo $IP |  tee /etc/mesos-master/hostname  
echo $IP |  tee /etc/mesos-master/ip  
echo Cluster01 |  tee /etc/mesos-master/cluster  
echo 1 |  tee /etc/mesos-master/quorum  
echo $IP |  tee /etc/mesos-slave/hostname  
echo $IP |  tee /etc/mesos-slave/ip  
echo "cgroups/cpu,cgroups/mem" |  tee /etc/mesos-slave/isolation  
echo zk://$IP:2181/mesos | tee /etc/mesos/zk  
echo 1 |  tee /etc/zookeeper/conf/myid  
reboot