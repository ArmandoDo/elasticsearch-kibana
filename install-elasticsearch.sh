#!/bin/bash

## This script install the dockerize version of Elasticsearch in your
## local environment. Run the build script before start the installation
##
## Usage:
## ./install-elasticsearch.sh

## Container registry
export REGISTRY_NAME="development"
# Elasticsearch
export ELASTICSEARCH_APP_NAME="elasticsearch"
export ELASTICSEARCH_APP_TAG="8.6.2"
# Kibana
export KIBANA_APP_NAME="kibana"
export KIBANA_APP_TAG="8.6.2"

## Volume info
export ELASTICSEARCH_DATA_VOLUME_NAME="elasticsearch_data"

## Get the OS
OS_TYPE=$(uname)

## Install docker image on linux
install_on_linux() {
    source .env
    stop_container
    docker compose --file docker-compose.yml up --detach ${ELASTICSEARCH_APP_NAME}

}

### Stop docker container
stop_container() {
    docker compose --file docker-compose.yml stop ${ELASTICSEARCH_APP_NAME}
    docker compose --file docker-compose.yml rm --force ${ELASTICSEARCH_APP_NAME}
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

    echo "${ELASTICSEARCH_APP_NAME} docker image deployed on host..."
}

main