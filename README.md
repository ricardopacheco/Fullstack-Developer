# README

This documentation focuses on the post-formatted setup environment for windows with the following settings:

- Ubuntu WSL2 22.04 LTS

## Getting started

Clone the project from github:

```
    user@host:~$ git clone git@github.com:ricardopacheco/Fullstack-Developer.git management
    user@host:~$ cd management
    user@host:~$ cp .env.development.template .env.development.local
    user@host:~$ cp .env.test.template .env.test.local
```

> You will configure environment variables according to your development and test environment.

> Use the initial credentials email `admin@email.com` and password `password` to first login in system.

## Setup in development environment in host mode [ASDF]

> Read the asdf documentation [here](https://asdf-vm.com/#/core-manage-asdf). It contains the asdf setup process for your OS. Once asdf has been installed and is working, navigate to the folder where you cloned the project and perform the following steps:

## OS dependencies

#### Nokogiri gem

```
    user@host:~$ sudo apt install zlib1g-dev liblzma-dev patch pkg-config libxml2-dev libxslt-dev
```

#### Shrinerb gem

```
    user@host:~$ sudo apt install imagemagick
```

## Database (PostgreSQL)

### Postgres

```
    user@host:~$ sudo apt install build-essential libssl-dev libreadline-dev zlib1g-dev libcurl4-openssl-dev uuid-dev
    user@host:~$ asdf plugin add postgres
    user@host:~$ asdf install postgres 15.1
    user@host:~$ rm -rf ~/.asdf/installs/postgres/15.1/data
    user@host:~$ initdb -D ~/.asdf/installs/postgres/15.1/data -U postgres
```

#### Ruby

```
    user@host:~$ sudo apt install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev
    user@host:~$ asdf plugin add ruby
    user@host:~$ asdf install ruby 3.2.0
    user@host:~$ gem install pg -v 1.4.5 --verbose -- --with-pg-config=$HOME/.asdf/installs/postgres/15.1/bin/pg_config # Fix pg_config
    user@host:~$ bundle install
```

### NodeJS

```
    user@host:~$ asdf plugin add nodejs
    user@host:~$ asdf install nodejs 19.6.0
    user@host:~$ npm install -g yarn@1.22.19
    user@host:~$ npm install -g maildev@latest
```

### Redis

```
    user@host:~$ sudo apt install build-essential
    user@host:~$ asdf plugin add redis
    user@host:~$ asdf install redis 7.0.8
```

#### Procfile manager (Optional, but recommended)

```
    user@host:~$ curl -O https://storage.googleapis.com/golang/go1.19.4.linux-amd64.tar.gz
    user@host:~$ tar -xvf go1.19.4.linux-amd64.tar.gz
    user@host:~$ sudo mv go /usr/local
    user@host:~$ mkdir $HOME/go
```

Add this config to shell config file (~/.bashrc, ~/.zshrc)

```
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
```

And run the commands above:

```
    user@host:~$ source ~/.zshrc # set to your shell config file
    user@host:~$ GO111MODULE=on go install github.com/DarthSim/overmind@v2
```

### Install minio server

> In this install, go lang is required if installed by source code. If not, you can read minio's official documentation to install the server and client according to your OS.

```
    user@host:~$ mkdir $HOME/minio_storage
    user@host:~$ GO111MODULE=on go install github.com/minio/minio@latest
    user@host:~$ GO111MODULE=on go install github.com/minio/mc@latest
    user@host:~$ minio server ~/minio_storage
```

Now, open the new tab in current directory, run the command below creating an alias for the client that will authenticate and connect to the minio deployment:

```
    user@host:~$ mc alias set minio-dev http://127.0.0.1:9000 minioadmin minioadmin
```

> Check that everything is working using the command `mc admin info minio-dev`.

After that, create a bucket for development purposes:

```
    user@host:~$ mc mb ~/minio_storage/development --region="br-east-1"
    user@host:~$ mc anonymous set public minio-dev/development
```

> We set this policy option for practical reasons of agility in the development workflow. In production, this is strictly prohibited and the policy must be set up focused exclusively on performance and security.

#### Create a development database

```
    user@host:~$ OVERMIND_PROCFILE=Procfile.dev overmind s -l database
    user@host:~$ bundle exec rails db:create db:migrate db:seed
```

> Give ctrl+c here to stop the database service, we will start it below along with the other dependent services.

#### Install git hooks

```
    user@host:~$ overcommit --install
    user@host:~$ overcommit --sign
    user@host:~$ overcommit --sign pre-commit
    user@host:~$ overcommit --sign post-commit
```

> We use git hooks to do code checking to avoid bad commits.

#### Start application

```
    user@host:~$ OVERMIND_PROCFILE=Procfile.dev overmind s
```

## Setup in development environment in container mode [Docker]

> Installation of docker and compose may vary by operating system and are updated quite frequently. With that, I suggest you see the installation documentation in the official documentation, follow the links (I'll put ubuntu because we're using it as a base, but change according to your OS).

- [Docker](https://docs.docker.com/engine/install/ubuntu/)
- [Docker compose](https://docs.docker.com/compose/install/)

> Consider running docker without using sudo (with your default user) via this documentation. [documentation](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user)

After that, edit `.env.development.local` and `.env.test.local` files with docker values if needed.

With that, we created an intermediate application container in order to make the first configurations. First, let's start a file upload server:

```
    user@host:~$ docker compose up minio
```

Now in another tab, let's set up a bucket for the file upload server:

```
    user@host:~$ docker run -it --name mc --net management_default --env-file "./.env.development.local" --entrypoint=/bin/sh minio/mc
    sh-4.4# mc alias set minio-dev http://minio:9000 minioadmin minioadmin
    sh-4.4# mc mb minio-dev/development --region="br-east-1"
    sh-4.4# mc anonymous set public minio-dev/development
    sh-4.4# exit
```

Now, Run the following commands below to add gems in cache volume, create a development/test database and kill containers to start all containers correctly:

```
    user@host:~$ docker compose build app
    user@host:~$ docker compose run app bash
    root@container-id:~$ bundle install
    root@container-id:~$ bundle exec rake db:create db:migrate db:seed
    root@container-id:~$ exit
    user@host:~$ docker rm -f $(docker ps -a -q)
```

#### Start application

```
    user@host:~$ docker compose up
```

## Troubleshouting

- "docker endpoint for "default" not found"

> Remove ~/.docker if happen this error and try again build app image

- "gem_name" is not yet checked out. Run `bundle install`

> Run a intermediate container and run bundle install (add gems in app cache volume).

```
    user@host:~$ docker compose run app bash
    root@container-id:~$ bundle install
```
