
To build an ARM-compatible binary, see the build script.  It's taken from this thread:
https://discuss.elastic.co/t/how-to-install-filebeat-on-a-arm-based-sbc-eg-raspberry-pi-3/103670/3

I put that ARM binary into a docker image, see the Dockerfile.

See docker-compose.yml for how I configured the pibeats container work with nginx on the rpi.

