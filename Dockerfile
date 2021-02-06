# Dockerfile for Zookeeper
# To build an image using this docker file, execute the following command
#
# $ docker build -t lgslm/zookeeper .
#
# To run a container and log into it execute the command
# 
# $ docker run --rm -it --name zookeeper lgslm/zookeeper bash
#
FROM openjdk:8

MAINTAINER Luigi Selmi <luigi@datiaperti.it>
COPY apache-zookeeper-3.6.2-bin.tar.gz /usr/local/apache-zookeeper-3.6.2-bin.tar.gz
WORKDIR /usr/local/
RUN tar xvf apache-zookeeper-3.6.2-bin.tar.gz
RUN rm apache-zookeeper-3.6.2-bin.tar.gz
ENV ZOOKEEPER_HOME=/usr/local/apache-zookeeper-3.6.2-bin

# Install  network tools (ifconfig, netstat, ping, ip)
RUN apt-get update && \
    apt-get install -y net-tools && \
    apt-get install -y iputils-ping && \
    apt-get install -y iproute2

# Install vi for editing
RUN apt-get update && \
    apt-get install -y vim

# Create a simbolinc link to Zookeeper
RUN ln -s $ZOOKEEPER_HOME /zookeeper

# Make a copy of zoo_sample.cfg
RUN cp $ZOOKEEPER_HOME/conf/zoo_sample.cfg $ZOOKEEPER_HOME/conf/zoo.cfg

# Copy the entrypoint script
COPY startup /startup

# Start Zookeeper
WORKDIR /
ENTRYPOINT ["./startup"]
