# Builds out the base install for the LittleJohn cluster nodes. Pretty much
# just installs Java on top of base Ubuntu.

FROM ubuntu:14.04.2
MAINTAINER Shannon Quinn "magsol@gmail.com"

USER root
ENV DEBIAN_FRONTEND noninteractive

# Install the basic packages.
RUN apt-get update
RUN apt-get install -y wget rsync build-essential openjdk-7-jdk vim emacs