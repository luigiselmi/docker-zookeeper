docker-zookeeper
================
This repository contains a Docker file and a docker-compose file to deploy Zookeeper on a single node (standalone)
or in a cluster (quorum). [Zookeeper](https://zookeeper.apache.org/) is used to coordinate servers and tasks of many
distributed frameworks such as Apache Hbase, Apache Solr and Apache Kafka.
  
## standalone mode
A Docker file is available to build an image of Zookeeper from the binary file (version 3.6.2) to run in standalone mode. 
To build execute the following command

    $ docker build -t lgslm/zookeeper:v1.0.0 .

To run a container and log into it execute the command
 
    $ docker run --rm -it --name zookeeper lgslm/zookeeper:v1.0.0 bash

The container in standalone mode can be used to connect to a Zookeeper server in a cluster by using the zkClient to check
whether is running or not. The container must be member of the same cluster overlay network, e.g. kafka-clients-net

    $ docker run --rm -d -it --name zookeeper --network kafka-clients-net lgslm/zookeeper:v1.0.0 bash

Once the container is started connect to it by executing the command

    $ docker exec -it zookeeper bash

From the container you can connect to a Zookeeper server of the cluster, e.g. zoo1 listening port 2181 

    # zookeeper/bin/zkCli.sh -server zoo1:2181 

## quorum mode (cluster)
The official images of Zookeeper are available on [Docker Hub](https://hub.docker.com/_/zookeeper). A docker-compose 
file is also available to deploy a cluster of three Zookeeper servers using the Docker image. The images should be 
deployed in three different nodes, e.g. three Amazon EC2 instances. Docker Engine and docker-compose must be installed
on each node. Once Docker is installed the Zookeeper image must be installed manually on each instance by executing the
command

    $ docker pull zookeeper

  
Once we are done with this step we have to choose a node as the manager of the cluster while the other will have the role 
of worker nodes. The Docker engine in the manager node wil have to be switched to swarm mode and the worker will have join 
the swarm. How to create a docker swarm is described on the [Docker web site](https://docs.docker.com/engine/swarm/) and 
it's quite straightforward. The set up described in this section has been tested on a small cluster of three EC2 servers 
on the Amazon cloud. The following protocols and ports (inbound rules) must be allowed in the security group used by the 
EC2 servers so that the swarm master and workers can communicate

* TCP port 2377 for cluster management communications
* TCP and UDP port 7946 for communication among nodes
* UDP port 4789 for overlay network traffic

After the swarm has been created, with a manager and the workers, we can check that they are available and ready by executing 
the following command on the manager node

    $ docker node ls

All the containers in the cluster must be member of an overlay network in order to use a DNS and be able to use the host names 
instead of their IP addresses. We create the network, e.g. kafka-clients-net, from the manager node with the command

    $ docker network create -d overlay --attachable kafka-clients-net

The Zookeeper services in the docker-compose file are all members of the same network. The docker image used in the docker-compose 
file should be pulled automatically from Docker Hub from the master node and installed also in the worker nodes but it may fail in 
the worker nodes on the Amazon cloud. One easy way to bypass this potential problem is to manually pull the required images on each 
EC2 instance. When the Zookeeper image is available on each node we can deploy the stack of Zookeeper services on the swarm using 
the docker-compose file from the master node

    $ docker stack deploy --compose-file docker-compose-zookeeper-ensemble.yml zookeeper-stack

We name this stack zookeeper-stack. We can see the Zookeeper services started and also in which node they have been deployed using 
the command

    $ docker stack ps zookeeper-stack

The stack of Zookeeper services can be removed from the swarm and the Zookeeper servers stopped using the command

    $ docker stack rm zookeeper-stack

