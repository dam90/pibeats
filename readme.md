# Elastic/Filebeat on my Raspberry Pi

## Background
I wanted to be able to ship log data from my raspberry pi to an ELK stack.  In my case, I'm using the pi as an NGINX proxy.  I liked the idea since my raspberry pis seem to always be on. They should be able to reliably log requests, even when downstream applications/servers are off-line.
## Build
A bit of googling makes you realize there's not currently an apt-get approach to get filebeat on the pi, so you have to build it.

To build an ARM-compatible binary, see the build script in this repo. It's taken from this thread: https://discuss.elastic.co/t/how-to-install-filebeat-on-a-arm-based-sbc-eg-raspberry-pi-3/103670/3

The overly-documented script dumps out tar.gz file which, when extracted on the pi, should run.
## Deploy

There's probably a bunch of ways to do this... I've been using docker a lot recently, so that's the path I chose.  First I created a base docker image (see Dockerfile), then I used docker compose to configure and run the base image for my needs.

If you look at the docker-compose.yml, in this case my needs were to use the built-in nginx module, provide access to the nginx logs, and persist the data.  I accomplish this without modifying the base image by using a startup script.  That's probably an anti-pattern or something, but I like it.

I got persistency by mounting the filebeat registry to the current directory.

I also had to mount the nginx log folder, and gave it read-only access... don't know if this matters really.