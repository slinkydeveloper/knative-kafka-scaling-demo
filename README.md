# Knative Kafka scaling demo

## Introduction

This demo is composed by four elements:

1. Producer script that generates a load of Kafka messages linearly increasing
2. Kafka cluster configuration and Kafka topic configuration using Strimzii
3. Knative `KafkaSource` configuration
4. Event display Knative service

## Dependencies

On your dev machine you need:

* [kafkacat](https://github.com/edenhill/kafkacat)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [ko]()

## Run
