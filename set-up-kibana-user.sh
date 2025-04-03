#!/bin/bash

## This script sets up the Kibana system user.
## Usage:
## ./set-up-kibana-user.sh
#

if ! source .env; then
    echo "Missing .env file with the environment variables. Please create the .env file"
    exit 1
fi

echo "Setting password for the Kibana user"

curl -X POST \
    "http://elastic:${ELASTIC_PASSWORD}@localhost:9200/_security/user/kibana_system/_password" \
    -H "Content-Type: application/json" \
    -d '{ "password": "'${KIBANA_USER_PASSWORD}'" }'

echo " User: kibana_system, Password: ${KIBANA_USER_PASSWORD}"
echo "The Kibana password has been set up!"