#!/bin/bash

apt update
apt upgrade

install -y g++ freeglut3-dev build-essential libx11-dev libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev

apt-get remove --purge nvidia-*
apt-get install nvidia-driver-535
reboot now
