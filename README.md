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
systemctl start docker.service
systemctl enable docker.service
```

## Clone this repo

```
git clone git@github.com:Yuffster/sinatra-docker-barebones.git
```

## Enter the repo directory and build the Docker image

```
docker build -t hello-world sinatra-docker-barebones/
```

## Run the docker container

We'll name it "hello-server" so we know what to call it later, though we could also leave this out and just use the hash that gets displayed when we type `docker ps`.

Then we use -P to publish this service to external connections and -p to map the host port 80 to the container port 8080 (which is exposed our Dockerfile).

If you **don't** want your container's services to be available to external connections, leave out the -P flag.

The -d flag just means that the process will run in the background, instead of spamming your terminal.

```
docker run --name hello-server -d -P -p 80:8080 hello-world
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

```
curl localhost:80
```

You should get:

> Hello, world!

If you connect to your server's IP address through your browser, you should also see the same message.

![Thumbs up](thumbsup.gif)