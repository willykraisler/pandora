#!/bin/bash

set -e

N=$1
BASE=/home/pandora
VERSION=pandora/server:0.0.5

sudo chmod 777 $BASE/runs

sudo docker run --rm -p 48080:80 -e N=$N -v $BASE/runs:/usr/share/nginx/html -it $VERSION nginx

sudo umount $BASE/runs
dd if=/dev/zero of=$BASE/FS bs=1M count=1024
sudo mkfs.ext2 $BASE/FS
sudo mount $BASE/FS $BASE/runs
sudo chmod 777 -R $BASE/runs
