# Knative Kafka scaling demo

## Introduction

This demo is composed by four elements:

* Producer script that generates a load of Kafka messages linearly increasing
* Kafka cluster configuration and Kafka topic configuration using Strimzii
* Knative `KafkaSource` configuration
* Event display Knative service

## Dependencies

On your dev machine you need:

* [kafkacat](https://github.com/edenhill/kafkacat)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

On your cluster you need:

* [Knative Serving & Eventing](https://knative.dev/)
* [Strimzi](https://strimzi.io/)

## Run

Create your kafka cluster:

```shell script
kubectl apply -n kafka -f kafka/1-kafka-cluster.yml
```

When the cluster is ready, create the topic `my-topic`:

```shell script
kubectl apply -n kafka -f kafka/2-topic.yml
```

Now deploy the Knative service that deploys the listening CloudEvent receiver:

```shell script
kubectl apply -f event-display/event-display.yml
``` 

Deploy the `KafkaSource` that will pick events from the topic `my-topic`:

```shell script
kubectl apply -f kafka-source/kafka-source.yml
``` 

Find the kafka cluster address before and then run the producer script:

```shell script
./producer/produce.sh [kafka url] my-topic
```
