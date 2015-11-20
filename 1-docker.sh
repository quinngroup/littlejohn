# This script is a generic attempt to initialize a newly-created head node
# as part of a Mesos-powered Hadoop-driven Dockerized cluster.
#
# This script should be run as ROOT.
#
# Installs on RHEL 6. Follow these instructions:
# https://docs.docker.com/v1.6/installation/rhel/#red-hat-enterprise-linux-6.5-installation
# 
# The stack is as follows:
# - Install evil EPEL packages
# - Install Docker and Rancher

# STEP 1: EPEL
# These packages allow installing "non-sanctioned" RH packages.
wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
rpm -ivh epel-release-latest-6.noarch.rpm
yum -y update
rm epel-release-latest-6.noarch.rpm

# STEP 2: Docker install and configuration
yum -y remove docker
yum -y install docker-io
yum -y update docker-io
service docker start
chkconfig docker on
