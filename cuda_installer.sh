#!/bin/bash

set -e

echo "

Types: deb
URIs: http://archive.ubuntu.com/ubuntu/
Suites: lunar
Components: universe
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg" | sudo tee -a /etc/apt/sources.list.d/ubuntu.sources > /dev/null

sudo apt -y update

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.4.0/local_installers/cuda-repo-ubuntu2204-12-4-local_12.4.0-550.54.14-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2204-12-4-local_12.4.0-550.54.14-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2204-12-4-local/cuda-*-keyring.gpg /usr/share/keyrings/

sudo apt-get -y update
sudo apt-get -y install cuda

echo '# set PATH for cuda 12.4 installation' >> ~/.bashrc
echo 'if [ -d "/usr/local/cuda-12.4/bin/" ]; then' >> ~/.bashrc
echo '    export PATH=/usr/local/cuda-12.4/bin${PATH:+:${PATH}}' >> ~/.bashrc
echo '    export LD_LIBRARY_PATH=/usr/local/cuda-12.4/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
echo 'fi' >> ~/.bashrc

source ~/.bashrc

sudo apt -y autoremove

CUDNN_TAR_FILE="cudnn-linux-x86_64-9.2.0.82_cuda12-archive.tar.xz"
wget https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/$CUDNN_TAR_FILE

tar -xvf $CUDNN_TAR_FILE

sudo cp -P cuda/include/cudnn*.h /usr/local/cuda-12.4/include
sudo cp -P cuda/lib/libcudnn* /usr/local/cuda-12.4/lib64/
sudo chmod a+r /usr/local/cuda-12.4/include/cudnn*.h /usr/local/cuda-12.4/lib64/libcudnn*

sudo rm $CUDNN_TAR_FILE

sudo apt-get -y update

git clone https://github.com/NVIDIA/cuda-samples.git
cd ./cuda-samples/
git checkout v12.4
cd ./Samples/1_Utilities/deviceQuery/
make -j$(nproc)
./deviceQuery

