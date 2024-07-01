#!/bin/bash

sudo apt-get install net-tools
sudo apt-get install -y openssh-server
sudo service ssh status
sudo service ssh start
sudo service ssh restart
