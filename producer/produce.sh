#!/bin/bash

check_command_exists() {
  local CMD_NAME=$1
  command -v "$CMD_NAME" > /dev/null || {
    echo "Command $CMD_NAME not exists, please install it"
    exit 1
  }
}

start_producer()
{
  local pipe_name=$1
  local bootstrap_url=$2
  local topic=$3

  kafkacat -b "$bootstrap_url" -t "$topic" -P < "$pipe_name" &
}

produce()
{
  local pipe_name=$1
  local message_id=$2
  local load_gen_id=$3

  echo "{\"id\": \"${message_id}\", \"hostname\": \"$load_gen_id\", \"payload\": \"Hello!\"}" >> "$pipe_name"
}

do_math()
{
  local math_op=$1
  echo "scale=4; $math_op" | bc -l | awk '{printf "%.4f", $0}'
}

calculate_sleep_time()
{
  local exec_time=$1
  if [[ $exec_time -gt "1000" ]]; then
    thpt="max"
  else
    thpt=$(do_math "(9*${exec_time})+10")
  fi

  if [[ $thpt == "max" ]]; then
    echo "0"
  else
    do_math "1/${thpt}"
  fi
}

if [[ $# -le 2 ]]
then
  echo "Usage: $0 <kafka_url> <topic>"
  exit 1
fi

check_command_exists "kafkacat"

kafka_url=$1
topic=$2
load_gen_id=$([ -z "$HOSTNAME" ] && echo "someone" || echo $HOSTNAME)

id=1

pipe_name=$(mktemp -u)
mkfifo "$pipe_name"

# Kill bg process at the end
trap 'kill $(jobs -p)' EXIT

# Keep pipe open
sleep infinity > "$pipe_name" &

start_producer "$pipe_name" "$kafka_url" "$topic"

while :
do
  wait_time=$(calculate_sleep_time $SECONDS)
  #echo "Sleeping for ${wait_time}"
  sleep "${wait_time}s"
  produce "$pipe_name" "$id" "$load_gen_id"
  ((id++))
done