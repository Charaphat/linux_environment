#!/bin/bash
set -e

# Update package list
sudo apt update

# Install essential tools and utilities
sudo apt-get -y install build-essential
sudo apt-get -y install openssh-server net-tools preload curl wget
sudo systemctl enable ssh
sudo systemctl start ssh

# Install dependencies for Python 3.12.3
sudo apt-get -y install libffi-dev libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev

# Install Python 3.12.3 from source
cd /tmp
wget https://www.python.org/ftp/python/3.12.3/Python-3.12.3.tgz
tar -xf Python-3.12.3.tgz
cd Python-3.12.3
./configure --enable-optimizations
make -j$(nproc)
sudo make altinstall

# Set Python 3.12.3 as the default python3 and pip3
sudo update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.12 1
sudo update-alternatives --install /usr/bin/pip3 pip3 /usr/local/bin/pip3.12 1

# Install and enable Cockpit and Podman
sudo apt-get -y install cockpit cockpit-podman
sudo systemctl start cockpit
sudo systemctl enable cockpit

# Install and enable XRDP
sudo apt-get -y install xrdp
sudo systemctl enable xrdp
sudo systemctl start xrdp

# Download and install Miniconda
cd /tmp
curl -O https://repo.anaconda.com/miniconda/Miniconda3-py312_24.5.0-0-Linux-x86_64.sh
chmod +x Miniconda3-py312_24.5.0-0-Linux-x86_64.sh
bash Miniconda3-py312_24.5.0-0-Linux-x86_64.sh
source ~/.bashrc

# Configure Conda
conda config --set auto_activate_base false

# Add the Nvidia PPA and install Nvidia driver 535
sudo add-apt-repository ppa:graphics-drivers/ppa -y
sudo apt update
sudo apt-get install -y nvidia-driver-535

# Reboot the system to apply changes
sudo reboot
