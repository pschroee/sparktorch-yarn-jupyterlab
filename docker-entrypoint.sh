#!/bin/bash

sudo service ssh start

if [ ! -d "/tmp/hadoop-hduser/dfs/name" ]; then
        $HADOOP_HOME/bin/hdfs namenode -format
fi

$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh

hdfs dfs -mkdir /spark-logs
$SPARK_HOME/sbin/start-history-server.sh

hdfs dfs -mkdir /user
hdfs dfs -mkdir /user/hduser
hdfs dfs -mkdir /user/hduser/input
hdfs dfs -mkdir /user/hduser/models
hdfs dfs -put /home/hduser/mnist/* /user/hduser/input
hdfs dfs -put /home/hduser/examples/wordcount.txt /user/hduser/input

jupyter-lab examples/
