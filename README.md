docker-zookeeper
================
A docker image for [Zookeeper](https://zookeeper.apache.org/). ZooKeeper is a centralized naming and synchronization service used by some distributed applications
such as Apache Kafka and Apache Solr. The image can be run alone or in a cluster.

To build an image using the docker file, execute the following command

    $ docker build -t lgslm/zookeeper:v1.0.0 .

To run a container and log into it execute the command
 
    $ docker run --rm -it --name zookeeper lgslm/zookeeper:v1.0.0 bash

