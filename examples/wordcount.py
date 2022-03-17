import sys

from pyspark import SparkContext, SparkConf
import os

if __name__ == "__main__":

  from pyspark import SparkContext, SparkConf
  from pyspark.sql import SparkSession

  sparkConf = SparkConf()
  sparkConf.setMaster("yarn")
  sparkConf.setAppName("Word Count - Python")
  sparkConf.set("spark.hadoop.yarn.resourcemanager.address", "127.0.0.1:8032")

  spark = SparkSession.builder.config(conf=sparkConf).getOrCreate()
  sc = spark.sparkContext

  # read in text file and split each document into words
  words = sc.textFile("/user/hduser/input/wordcount.txt").flatMap(lambda line: line.split(" "))

  # count the occurrence of each word
  wordCounts = words.map(lambda word: (word, 1)).reduceByKey(lambda a,b:a +b)

  wordCounts.saveAsTextFile("/user/hduser/output/wordcount")
    
  sc.stop()