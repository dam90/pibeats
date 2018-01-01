#! /bin/bash

# -------------------------------------------------------------
# elastic/filebeat build for the raspberry pi
#
# Tested in a golang docker container...
# docker run -it --rm -v `pwd`:/build golang:latest /bin/bash
#
# References:
# https://discuss.elastic.co/t/how-to-install-filebeat-on-a-arm-based-sbc-eg-raspberry-pi-3/103670/3
# -------------------------------------------------------------

# -------------------------------------------------------------
# Step 1) Build
# NOTE: the git checkout version needs to match the elastic search API version
# -------------------------------------------------------------
elastic_version="6.1.1"

echo "--------------------------------"
echo "  $(date)"
echo "  Downloading source..."
echo "--------------------------------"
go get github.com/elastic/beats
cd /go/src/github.com/elastic/beats/filebeat/
git checkout "v${elastic_version}"
echo "--------------------------------"
echo "  $(date)"
echo "  Building source..."
echo "--------------------------------"
GOARCH=arm go build
cp filebeat /build
cd /build

# -------------------------------------------------------------
# Step 2) Download the tar
# The url contains the version number like this: "https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.1.1-linux-x86.tar.gz"
# -------------------------------------------------------------

# then download the linux tar from:
download_url="https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${elastic_version}-linux-x86.tar.gz"
echo "---------------------------------------"
echo "  $(date)"
echo "  Downloading filebeat tarball from:"
echo "  ${download_url}"
echo "---------------------------------------"
curl $download_url -o download.tar 

# -------------------------------------------------------------
# Step 3) Untar, modify, tar
# Drop the filebeat binary into the new tar....
# -------------------------------------------------------------
echo "--------------------------------------------"
echo "  $(date)"
echo "  Adding the filebeat binary to the tar..."
echo "--------------------------------------------"
mkdir workdir
tar -xf download.tar -C workdir --strip-components=1
cp filebeat workdir/filebeat
cd workdir
tar -zcf ../pibeats-${elastic_version}.tar.gz .
cd ..
echo "--------------------------------"
echo "  $(date)"
echo "  Clearning up..."
echo "--------------------------------"
rm -rf filebeat
rm -rf workdir
rm -rf download.tar

echo "-------------------------------------------------------------"
echo "  $(date)"
echo "  COMPLETE! Copy pibeats.tar.gz to raspberry pi!"
echo ""
echo "  Something like this?"
echo "  scp ./pibeats.tar.gz username@pi_address:/home/username/"
echo "-------------------------------------------------------------"

