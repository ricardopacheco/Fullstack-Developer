<p align="center">
  <img src="https://cdn-icons-png.flaticon.com/512/3286/3286792.png" width="200" alt="Management">
</p>

[![CI](https://github.com/ricardopacheco/Fullstack-Developer/actions/workflows/ci.yml/badge.svg)](https://github.com/ricardopacheco/Fullstack-Developer/actions/workflows/ci.yml) [![Current Version](https://img.shields.io/badge/demo-online-green.svg)](https://github/com/ricardopacheco/Fullstack-Developer)

A small app for user management.

---

## Table of Contents

- [Introduction](#introduction)
- [Getting started](#getting-started)
- [Setup with Host](#setup-with-host)
- [Setup with Docker](#setup-with-docker)
- [Useful commands](#useful-commands)
- [Troubleshouting](#troubleshouting)

---

## Introduction

This is sample code following best practices for a monolithic application. The code of this application has educational purposes and can be used freely. To run this project locally, you can choose "host" mode, where I use asdf to manage versions and Procfile to start processes correctly, or you can choose using Docker and compose. Both ways are well documented in this README.

---

## Getting started

Clone the project from github and prepare environment variables for dev/test.

```shell
git clone git@github.com:ricardopacheco/Fullstack-Developer.git management
cd management
cp lib/templates/.env.development.template .env.development.local
cp lib/templates/.env.test.template .env.test.local
```

---

## Setup with Host

> Read the asdf documentation [here](https://asdf-vm.com/#/core-manage-asdf). It contains the asdf setup process for your OS. Next steps considerind Once asdf has been installed and is working.

> [IMPORTANT] By default, environment variables are set to initial values for docker. You need to change the values to that of your host.

Run the command below, it will setup ruby and support services using asdf plugins, as well as installing necessary operating system packages.

```shell
devops/development/setup
```

Now, let's create a bucket for development with minio service:

```shell
overmind s -l minio -D
mc alias set minio-dev http://127.0.0.1:9000 minioadmin minioadmin
mc mb ~/buckets/management/development --region="br-east-1"
mc anonymous set public minio-dev/development
overmind quit
```

> [Careful] We set this policy option for practical reasons of agility in the workflow. In production, this is strictly prohibited and the policy must be set up focused exclusively on performance and security.

After that, let's start the database service and create database for application:

```shell
overmind s -l database -D
bundle exec rails db:create db:setup
overmind quit
```

You can start application with `overmind start`. The application will be available at the address `http://localhost:3000`

## Setup with Docker

You will need to have `docker` and `docker-compose` installed to run the project correctly. Install according to your OS's official documentation:

- [`docker`](https://docs.docker.com/engine/install/)
- [`docker-compose`](https://docs.docker.com/compose/install/)

> Consider running docker without using sudo in linux (with your default user) via this documentation. [documentation](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user)

To verify that docker is working correctly, run the `docker --version` and `docker compose --version` commands. If the output of the command is the same like `Docker version 20.10.23, build 7155243` and `Docker Compose version v2.15.1` your installation should be ok.

| WARNING: **After that, edit `.env.development.local` and `.env.test.local` files with docker values if needed.** |
| ---------------------------------------------------------------------------------------------------------------- |

Now let's configure a bucket for the application using minio:

```shell
docker compose up minio -d
docker run -it --name mc --net management_default --env-file "./.env" --entrypoint=/bin/sh minio/mc
mc alias set minio-dev http://minio:9000 minioadmin minioadmin
mc mb minio-dev/management --region="br-east-1"
mc anonymous set public minio-dev/management
exit

docker compose stop
docker rm -f $(docker ps -a -q)
```

> If error "mc: <ERROR> Unable to make bucket `minio-dev/management/development`. Your previous request to create > the named bucket succeeded and you already own it." occours when `mc mb minio-dev/management/development --region="br-east-1"` **just ignored it**.


With the bucket created, we can follow the normal setup of a rails application with docker:

```shell
# This command may take a while depending on your internet speed.
# This will create an intermediate container that will open a bash for us
docker compose run --rm app bin/setup
dockero compose down
```

Now just start your full stack using `docker compose up`. You should be able to see the application running [locally](http://localhost:3000)


> To run the test suite, run the commands below:

```
docker compose run --rm $(awk '!/^#/ && NF > 0 {print "-e", $1}' .env.test.local) app bundle exec rails db:create
docker compose run --rm $(awk '!/^#/ && NF > 0 {print "-e", $1}' .env.test.local) app bundle exec rails spec
```

## Useful commands

This is actually a cheat-sheet we find useful! Nothing too specific to our apps.

```shell
# Debugging container with pry: connect to the `app` process to be able to input commands:
docker attach $(docker-compose ps -q app)
# Then disconnect by hitting [Ctrl+C].

# Restart a container without restarting all the other ones:
docker compose restart app

# Stop all containers with compose
docker compose stop

# Remove all containers with compose
docker compose rm

# Stop and remove all containers with compose
docker compose down

# Stop all containers (with or without compose). This is useful in case some
# unexpected container is running and disturbing the workflow.
docker stop -f $(docker ps -a -q)

# Remove all containers (with or without compose). This is useful in case some
# unexpected container is running and disturbing the workflow.
docker rm -f $(docker ps -a -q)

# Install ping tool (for debug network issues)
apt install iputils-ping

# Install ifconfig tool (for debug network issues)
apt install net-tools

# Running specified scripts. Using --rm option just remove app container.
# Linked dependencies (db,redis,etc) will continue to run. To stop them,
# use `docker compose down`
docker compose run --rm service_name [command]
```

---

## Troubleshouting

- "gem_name" is not yet checked out.

> Run a intermediate container and run bundle install (add gems in app cache volume) with `docker compose run --rm app bundle install`

- "docker endpoint for "default" not found"

> Remove ~/.docker if happen this error and try again build app image (`docker compose build app`)
