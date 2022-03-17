# Hadoop Single Node Cluster mit Apache Spark, Sparktorch und Jupyter Lab

In dem Beispiel wird Aapache Spark mit einem Hadoop Single Node Cluster aufgesetzt. Aapache Spark nutzt dabei YARN als Resource Manager für die Spark Jobs. Die Daten für das Trainieren des neuronalen Netzes werden aus dem HDFS geladen. Das fertig trainierte Modell wird als Pipeline dann wieder im HDFS gespeichert. Die Pipeline kann anschließend aus dem HDFS wieder geladen werden und die Daten transformieren.

Das neuronale Netz soll trainiert werden, um handschriftliche Zahlen zu erkennen. Dazu wurde dass bekannte MNIST-Datenset verwendet. In [MNIST_Train.ipynb](examples/MNIST_Train.ipynb) wird das Modell trainiert und in [MNIST_Test.ipynb](examples/MNIST_Test.ipynb) wird die Pipeline angewendet.

Das MNIST Datenset wurde zur einfacheren Verarbeitung als CSV-Datei umgewandelt und wird beim Start des Docker Containers in das HDFS geladen.

Quellen:

- [https://pjreddie.com/projects/mnist-in-csv/](https://pjreddie.com/projects/mnist-in-csv/)
- [https://github.com/dmmiller612/sparktorch](https://github.com/dmmiller612/sparktorch)
- [https://bhashkarkunal.medium.com/sparktorch-a-high-performance-distributed-deep-learning-library-step-by-step-training-of-pytorch-9b58034fcf9c](https://bhashkarkunal.medium.com/sparktorch-a-high-performance-distributed-deep-learning-library-step-by-step-training-of-pytorch-9b58034fcf9c)

## Bauen des Docker Images

Die Dateien `mnist_train.csv` und `mnist_test.csv` müssen runtergeladen werden und in dem Ordner `mnist` kopiert werden. Die Dateien können [hier](https://www.kaggle.com/oddrationale/mnist-in-csv) heruntergeladen werden.

     $ docker build -t sparktorch .

## Erstellen des Docker Container

Starten vom fertig gebauten Image von DockerHub:

     $ docker run -it --name **container-name** -p 9864:9864 -p 9870:9870 -p 8088:8088 -p 18080:18080 -p 8042:8042 -p 8888:8888 --hostname **your-hostname** pschroee/sparktorch-yarn-jupyterlab

Starten vom lokal gebauten Image:

     $ docker run -it --name **container-name** -p 9864:9864 -p 9870:9870 -p 8088:8088 -p 18080:18080 -p 8042:8042 -p 8888:8888 --hostname **your-hostname** sparktorch

## URLS

- [DockerHub Image auf DockerHub](https://hub.docker.com/repository/docker/pschroee/sparktorch-yarn-jupyterlab)
- [JupyterLab (http://localhost:8888)](http://localhost:8888/)
- [Hadoop GUI (http://localhost:9870)](http://localhost:9870/)
- [Hadoop Cluster Overview (http://localhost:8088/cluster)](http://localhost:8088/cluster)
- [Hadoop Datanodes (http://localhost:9864/)](http://localhost:9864/)
- [Spark History Server (http://localhost:18080/)](http://localhost:18080/)
