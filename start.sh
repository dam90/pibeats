#! /bin/bash
# Enablge nginx filebeat module
./filebeat modules enable nginx;
# Start filebeat
./filebeat -v -e;