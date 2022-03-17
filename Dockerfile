FROM ubuntu:20.04

SHELL ["/bin/bash", "-c"] 

RUN apt-get update -y && apt -y upgrade && apt-get install vim -y && apt-get install wget -y && apt-get install ssh -y && apt-get install openjdk-8-jdk -y && apt-get install sudo -y && apt-get install python3-pip -y
RUN useradd -m hduser && echo "hduser:supergroup" | chpasswd && adduser hduser sudo && echo "hduser     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && cd /usr/bin/ && sudo ln -s python3 python

COPY ssh_config /etc/ssh/ssh_config

WORKDIR /home/hduser

USER hduser

# Hadoop

RUN wget -q https://downloads.apache.org/hadoop/common/hadoop-3.3.0/hadoop-3.3.0.tar.gz && tar zxvf hadoop-3.3.0.tar.gz && mv hadoop-3.3.0 hadoop && rm hadoop-3.3.0.tar.gz
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && chmod 0600 ~/.ssh/authorized_keys

ENV HDFS_NAMENODE_USER hduser
ENV HDFS_DATANODE_USER hduser
ENV HDFS_SECONDARYNAMENODE_USER hduser

ENV YARN_RESOURCEMANAGER_USER hduser
ENV YARN_NODEMANAGER_USER hduser

ENV HADOOP_HOME /home/hduser/hadoop
RUN echo "export JAVA_HOME=/usr" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh

ENV PATH $PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

# Spark

RUN wget https://dlcdn.apache.org/spark/spark-3.2.1/spark-3.2.1-bin-hadoop3.2.tgz && tar xzvf spark-3.2.1-bin-hadoop3.2.tgz && rm spark-3.2.1-bin-hadoop3.2.tgz && mv spark-3.2.1-bin-hadoop3.2 spark

ENV SPARK_HOME /home/hduser/spark
ENV HADOOP_CONF_DIR $HADOOP_HOME/etc/hadoop
ENV LD_LIBRARY_PATH $HADOOP_HOME/lib/native:LD_LIBRARY_PATH

ENV PATH $PATH:$SPARK_HOME/bin

# Install jupyter and sparktorch and pyspark

RUN sudo pip3 install numpy
RUN sudo pip3 install pyspark
RUN sudo pip3 install sparktorch
RUN sudo pip3 install jupyterlab
RUN sudo pip3 install matplotlib

# Add custom configs and other files

COPY docker-entrypoint.sh $HADOOP_HOME/etc/hadoop/

COPY spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf

COPY core-site.xml $HADOOP_HOME/etc/hadoop/
COPY hdfs-site.xml $HADOOP_HOME/etc/hadoop/
COPY yarn-site.xml $HADOOP_HOME/etc/hadoop/

ADD mnist/ mnist/

ADD examples/ examples/
RUN sudo chown -R hduser:hduser examples/

EXPOSE 9870 9864 8088 18080 8888

ENTRYPOINT ["/home/hduser/hadoop/etc/hadoop/docker-entrypoint.sh"]
