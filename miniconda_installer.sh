#!/bin/bash

set -e

sudo apt upadte

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /opt/miniconda-installer.sh

bash /opt/miniconda-installer.sh

source ~/.bashrc

sudo rm /opt/miniconda-installer.sh

conda info
