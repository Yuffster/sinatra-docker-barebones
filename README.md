# Barebones Docker Example

This repository stores a barebones example of using a Docker image to serve a Ruby app.  Useful for making sure that you're running Docker correctly.

This README plus the documentation on [how to structure a Dockerfile](https://docs.docker.com/reference/builder/) should be all you need to get started with automated builds using Docker.

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

## Create an app-specific user

It's a good idea to run each different application as its own user.  This makes it harder for exploited vulnerabilities in one application to escalate to root level attacks on the entire system.

First we create a user named `sinatra`, because this is a [Sinatra](http://www.sinatrarb.com/) application.  This isn't a fully-fledged user, so we don't need to create a home directory or a password or add extra info.

```
adduser sinatra --no-create-home --disabled-password --gecos ""
```

Then we add the new user to the `docker` group (in order to allow it to use docker).

```
usermod -a -G docker sinatra
```

Now, we can type `su sinatra` to switch to that user instead of running as root.

## Run the docker container

We'll name it "hello-server" so we know what to call it later, though we could also leave this out and just use the hash that gets displayed when we type `docker ps`.


**Make sure you don't run this command as the root user.**

```
docker run --name hello-server -d -P --restart=always -p 80:8080 hello-world
```

### Argument explanation

`-p` maps the host port 80 to the container port 8080 (which is exposed in our Dockerfile).  Since 80 is the default web port, this means we'll be able to hit our server's IP in the browser directly without having to specify port 8080.

Then we use `-P` to publish this service to external computers.  If you **don't** want your container's services to be available to external connections, leave out the `-P` flag.

The `-d` flag just means that the process will run in the background, instead of spamming your terminal.

`--restart=always` is magic.  Anytime the app crashes (which it will 20% of the time), Docker will automatically restart the container.  The container will also be restarted if the server reboots.


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

...or...

> "Random failure, crashing."

This is also fine, as the webapp is designed to crash 20% of the time in order to demonstrate its crash recovery.  If you refresh the page after a crash, you should see the page again.

If you type `docker logs hello-server`, you should see the web server's log.

Normal functioning web requests...

```
74.89.000.0 - - [25/Aug/2015:13:21:51 +0000] "GET / HTTP/1.1" 200 14 0.0017
74.89.000.0 - - [25/Aug/2015:13:21:53 +0000] "GET / HTTP/1.1" 200 14 0.0017
74.89.000.0 - - [25/Aug/2015:13:21:55 +0000] "GET / HTTP/1.1" 200 14 0.0036
```

Followed by an intentional crash...

```
I, [2015-08-25T13:21:56.270690 #8]  INFO -- : Randomly crashing the server in order to demonstrate adversity.
74.89.000.0 - - [25/Aug/2015:13:21:56 +0000] "GET / HTTP/1.1" 200 25 0.0028
[2015-08-25 13:21:57] INFO  going to shutdown ...
```

Followed by a reboot...

```
[2015-08-25 13:21:57] INFO  WEBrick::HTTPServer#start done.
[2015-08-25 13:21:58] INFO  WEBrick 1.3.1
[2015-08-25 13:21:58] INFO  ruby 2.2.0 (2014-12-25) [x86_64-linux]
[2015-08-25 13:21:58] INFO  WEBrick::HTTPServer#start: pid=8 port=8080
```

Followed by normal functioning requests again...

```
74.89.000.0 - - [25/Aug/2015:13:21:07 +0000] "GET / HTTP/1.1" 200 14 0.0019
74.89.000.0 - - [25/Aug/2015:13:21:58 +0000] "GET / HTTP/1.1" 200 14 0.0247
74.89.000.0 - - [25/Aug/2015:13:21:58 +0000] "GET / HTTP/1.1" 200 14 0.0017
74.89.000.0 - - [25/Aug/2015:13:21:59 +0000] "GET / HTTP/1.1" 200 14 0.0012
74.89.000.0 - - [25/Aug/2015:13:21:59 +0000] "GET / HTTP/1.1" 200 14 0.0019
74.89.000.0 - - [25/Aug/2015:13:22:00 +0000] "GET / HTTP/1.1" 200 14 0.0015
```