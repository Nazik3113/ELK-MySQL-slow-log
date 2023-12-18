#!/bin/bash

filebeat modules enable logstash
service filebeat start
docker-entrypoint.sh mariadbd