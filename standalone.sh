#!/bin/bash  
IP=`wget http://ipecho.net/plain -O - -q ; echo` 
apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF  
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')  
CODENAME=$(lsb_release -cs)  
echo  "deb http://repos.mesosphere.io/ubuntu trusty main" | tee /etc/apt/sources.list.d/mesosphere.list  
apt-get -y update 
sudo apt-get -y install mesosphere  
sudo dpkg --configure -a  
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