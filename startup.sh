#!/bin/bash
ZOOKEEPER_DATA_DIR=/tmp/zookeeper
echo $MYID > $ZOOKEEPER_DATA_DIR/myid
cd /zookeeper/bin && ./zkServer.sh start-foreground
