# Elasticsearch and Kibana on a single node

This repo contains the scripts to build and install the dockerize
version of Elasticsearch and Kibana on a single node.

Requirements:
 - Ubuntu or MacOS
 - Docker Compose V2

## Set up the `.env` file
Copy the `.env.tmpl` file and modify your environment variables:

```bash
cp .env.tmpl .env
```

```bash
# Passsword for the "elastic" user
export ELASTIC_PASSWORD="elastic_password"
# Password for the "kibana_system" user
export KIBANA_USER_PASSWORD="kibana_password"
```

## Deploy Elasticsearch

### 1. Build the Dockerize version of Elasticsearch
Run the script to build the Docker image of Elasticsearch:

**Note:** Once the image is built, there's no need to run the script again.

```bash
./build-elasticsearch.sh
```

### 2. Install Elasticsearch
Run the script to install the Docker image of Elasticsearch:

```bash
./install-elasticsearch.sh
```

### 3. Verify the status of the Elasticsearch container
Take a look at the logs of Elasticsearch service with:

```bash
docker logs elasticsearch
```

## Deploy Kibana

### 1. Set up the Kibana system user
Set up the password kibana_system user. Run the script to set up the password:

**Note:** Once the password is set up, there's no need to run the script again.

```bash
./set-up-kibana-user.sh
```

### 2. Build the Dockerize version of Kibana
Run the script to build the Docker image of Kibana:

**Note:** Once the image is built, there's no need to run the script again.

```bash
./build-kibana.sh
```

### 3. Install Kibana
Run the script to install the Docker image of Kibana:

```bash
./install-kibana.sh
```

### 4. Verify the status of the Kibana container
Take a look at the logs of Kibana service with:

```bash
docker logs kibana
```