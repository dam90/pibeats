# Elastic/Filebeat on my Raspberry Pi

## Background
I wanted to be able to ship log data from my raspberry pi to an ELK stack.  In my case, I'm using the pi as an NGINX proxy.  I liked the idea since my raspberry pis seem to always be on. They should be able to reliably log requests, even when downstream applications/servers are off-line.
## Build
A bit of googling makes you realize there's not currently an apt-get approach to get filebeat on the pi, so you have to build it.

To build an ARM-compatible binary, see the build script in this repo. It's taken from this thread: https://discuss.elastic.co/t/how-to-install-filebeat-on-a-arm-based-sbc-eg-raspberry-pi-3/103670/3

The overly-documented script dumps out tar.gz file which, when extracted on the pi, should run.
## Configure and Deploy

There's probably a bunch of ways to do this... I've been using docker a lot recently, so that's the path I chose.  First I created a base docker image (see Dockerfile or https://hub.docker.com/r/dm90/pibeats/), then I used docker compose to configure and run the base image for my needs.

### Stuff I Did

If you look at the docker-compose.yml, you can pick apart some of what I did.  Some of it's probably bad practice, but below is an explanation for most of it.  I figure there's probably other folks like me who'd like to just get it up and running, and don't quite know what they're doing.

1) **Log Access:** I gave the container access to the NGINX logs by mounting /var/log/nginx to the identical location in the container.

2) **Filebeat Configuration:** I mounted my simple filebeat configuration file over the default /filebeat/filebeat.yml in the image.

3) **Peristence:** I got persistence by mounting the /filebeat/data directory to a folder on the host in the current directory called ./filebeat_data/.  For example, if I deleted ./filebeat_data and re-started the container, all the logs would be re-forwarded

4) **TLS Certs:** My elastic stack is the sbp/elk docker image.  It has some SSL/TLS stuff that it uses be default, so I have to provide the certificate for that.

5) **Hosts:** In order to get the certs mentioned above to work on my local network (which lacks DNS) I had the relevant host corresponding to my ELK stack to /etc/hosts on both my pi and the elk stack host machine.I then gave the container access to /etc/hosts.  There's probably a way better way of doing this... but this works for me.

6) **Startup Script:** Lastly I used a shell script as the entrypoint for my container.  It enables the nginx plugin for filebeat, then starts it up.

7) **Restart Unless Stopped:** This is a thing I love.  When the pi boots, this container will be runnning.  Unless I stopped it previously...
