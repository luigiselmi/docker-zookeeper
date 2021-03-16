docker-zookeeper
================
## standalone mode
A docker image for [Zookeeper](https://zookeeper.apache.org/). ZooKeeper is a centralized naming and synchronization 
service used by some distributed applications such as Apache Kafka and Apache Solr. The image can be run alone or in 
a cluster. To build an image using the docker file, execute the following command

    $ docker build -t lgslm/zookeeper:v1.0.0 .

To run a container and log into it execute the command
 
    $ docker run --rm -it --name zookeeper lgslm/zookeeper:v1.0.0 bash

## quorum mode (cluster)
The official images of Zookeeper are available on [Docker Hub](https://hub.docker.com/_/zookeeper). A docker-compose 
file is also available to deploy a cluster of three Zookeeper servers using the Docker image. The images should be 
deployed in three different nodes, e.g. three Amazon EC2 instances. Docker Engine and docker-compose must be installed
on each node. Once Docker is installed the Zookeeper image must be installed manually on each instance by executing the
command

    $ docker pull zookeeper

  
