# Barebones Docker Example

This repository stores a barebones example of using a Docker image to serve a Ruby app.  Useful for making sure that you're running Docker correctly.

Starting from a fresh **Ubuntu 15.04** (not **14.04** since we're using systemd) install...

## Install dependencies (docker.io, git)

```
apt-get install docker.io
apt-get install git
```

## Start docker and enable on boot

```
systemctl start docker
systemctl enable docker
```

## Clone and enter this repo

```
git clone git@github.com:Yuffster/sinatra-docker-barebones.git
cd sinatra-docker-barebones/
```

## Run the docker container

```
docker run hello -p 8080:8080
```

## Make a request to the running webserver

```
curl localhost:8080
```

You should get:

> Hello, world!

![Thumbs up](thumbsup.gif)