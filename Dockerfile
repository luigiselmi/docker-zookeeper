# Dockerfile for Zookeeper
# To build an image using this docker file, execute the following command
#
# $ docker build -t lgslm/zookeeper:v1.0.0 .
#
# To run a container and log into it execute the command
# 
# $ docker run --rm -it --name zookeeper lgslm/zookeeper:v1.0.0 bash
#
FROM openjdk:8

MAINTAINER Luigi Selmi <luigi@datiaperti.it>

# Install  network tools (ifconfig, netstat, ping, ip)
RUN apt-get update && \
    apt-get install -y net-tools && \
    apt-get install -y iputils-ping && \
    apt-get install -y iproute2

# Install vi for editing
RUN apt-get update && \
    apt-get install -y vim

# Install Zookeeper from a mirror
WORKDIR /usr/local/
RUN wget https://mirror.efect.ro/apache/zookeeper/zookeeper-3.6.2/apache-zookeeper-3.6.2-bin.tar.gz && \
    tar xvf apache-zookeeper-3.6.2-bin.tar.gz && \
    rm apache-zookeeper-3.6.2-bin.tar.gz

ENV ZOOKEEPER_HOME=/usr/local/apache-zookeeper-3.6.2-bin

# Create a simbolinc link to Zookeeper
RUN ln -s $ZOOKEEPER_HOME /zookeeper

# Make a copy of zoo_sample.cfg
RUN cp $ZOOKEEPER_HOME/conf/zoo_sample.cfg $ZOOKEEPER_HOME/conf/zoo.cfg
#COPY zoo.cfg $ZOOKEEPER_HOME/conf/zoo.cfg

# Copy the entrypoint script
COPY startup.sh /startup.sh

EXPOSE 2181

# Start Zookeeper
WORKDIR /
ENTRYPOINT ["./startup.sh"]
