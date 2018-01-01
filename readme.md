
To build an ARM-compatible binary, see the build script.  It's taken from https://discuss.elastic.co/t/how-to-install-filebeat-on-a-arm-based-sbc-eg-raspberry-pi-3/103670/3

Once the ARM tar is on the pi, I'm choosing to run my beat shipper in docker.

To get docker rpi use:
curl -sSL https://get.docker.com | sh
sudo usermod -aG docker $user

Log out, and then back in.

Install pip, then docker-compose

sudo apt-get install python-pip
sudo pip install docker-compose

