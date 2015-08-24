# Barebones Docker Example

This repository stores a barebones example of using a Docker image to serve a Ruby app.  Useful for making sure that you're running Docker correctly.

Starting from a fresh **Ubuntu 15.04** (not **14.04** since we're using [systemd](https://www.digitalocean.com/community/tutorials/systemd-essentials-working-with-services-units-and-the-journal)) install...

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

## Clone this repo

```
git clone git@github.com:Yuffster/sinatra-docker-barebones.git
```

## Build the Docker image

```
docker build -t hello-world sinatra-docker-barebones/
```

This works because the sinatra-docker-barebones directory contains a filed named `Dockerfile`.

## Run the docker container

We'll name it "hello-server" so we know what to call it later, though we could also leave this out and just use the hash that gets displayed when we type `docker ps`.

`-p` maps the host port 80 to the container port 8080 (which is exposed in our Dockerfile).  Since 80 is the default web port, this means we'll be able to hit our server's IP in the browser directly without having to specify port 8080.

Then we use `-P` to publish this service to external computers.  If you **don't** want your container's services to be available to external connections, leave out the `-P` flag.

The `-d` flag just means that the process will run in the background, instead of spamming your terminal.

`--restart=always` is magic.  Anytime the app crashes (which it will 20% of the time), Docker will automatically restart the container.  The container will also be restarted if the server reboots.

```
docker run --name hello-server -d -P --restart=always -p 80:8080 hello-world
```

## Viewing the logs

If you want to see what's going on with the logs, you can view the server by using `docker logs`.

```
docker logs hello-server
```

Should return something like...

```
[2015-08-24 14:59:26] INFO  WEBrick 1.3.1
[2015-08-24 14:59:26] INFO  ruby 2.2.0 (2014-12-25) [x86_64-linux]
[2015-08-24 14:59:26] INFO  WEBrick::HTTPServer#start: pid=10 port=8080
172.17.42.1 - - [24/Aug/2015:14:59:29 +0000] "GET / HTTP/1.1" 200 14 0.0200
```

## Make a request to the running webserver

If you type `curl http://127.0.0.1` from the host computer, or visit the server's IP address from an external computer, you should get...

> Hello, world!

![Thumbs up](thumbsup.gif)