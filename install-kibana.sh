#!/bin/bash

## This script installs the dockerize version of Kibana in your
## local environment. Elasticsearch is a requirement for the Kibana
## installation.
##
## Usage:
## ./install-kibana.sh

## Container registry
export REGISTRY_NAME="development"
# Elasticsearch
export ELASTICSEARCH_APP_NAME="elasticsearch"
export ELASTICSEARCH_APP_TAG="8.6.2"
# Kibana
export KIBANA_APP_NAME="kibana"
export KIBANA_APP_TAG="8.6.2"

## Get the OS
OS_TYPE=$(uname)

## Install docker image on linux
install_on_linux() {
    source .env
    stop_container
    docker compose --file docker-compose.yml up ${KIBANA_APP_NAME}

}

### Stop docker container
stop_container() {
    docker compose --file docker-compose.yml stop ${KIBANA_APP_NAME}
    docker compose --file docker-compose.yml rm --force ${KIBANA_APP_NAME}
}

## Main function
main() {
    echo "${OS_TYPE} detected. Starting the installation..."
    # Verify the OS
    case "${OS_TYPE}" in
        "Darwin")
            echo "install_darwin"
            ;;
        "Linux")
            install_on_linux
            ;;
        *)
            echo "System isn't supported by this script: ${OS_TYPE}"
            echo "Please contact to the support team."
            exit 1
            ;;
    esac

    echo "${KIBANA_APP_NAME} docker image deployed on host..."
}

main