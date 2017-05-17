#!/bin/bash 

#if [ "$EUID" -ne 0 ]; then 
#	echo "Please run as root (use sudo)"
#	exit
#fi

SETUP_DIR="$HOME/gpu-setup"
if [ ! -d $SETUP_DIR ]; then
	echo "Setup directory not found. Did you run part 1?"
	exit
fi
cd $SETUP_DIR

# install cudnn
wget http://developer.download.nvidia.com/compute/redist/cudnn/v5.1/cudnn-8.0-linux-x64-v5.1.tgz
if [ ! -f "cudnn-8.0-linux-x64-v5.1.tgz" ]; then
    echo "You need to download cudnn-8.0 manually! Specifically, place it at: $SETUP_DIR/cudnn-8.0-linux-x64-v5.1.tgz"
    exit
fi

echo "Installing CUDA toolkit and samples"
# install cuda toolkit
if [ ! -f "cuda_8.0.61_375.26_linux-run" ]; then
	echo "CUDA installation file not found. Did you run part 1?"
	exit
fi
sudo sh cuda_8.0.61_375.26_linux-run --silent --verbose --driver --toolkit

echo "Uncompressing cudnn"
tar xzvf cudnn-8.0-linux-x64-v5.1.tgz
sudo cp -P cuda/include/cudnn.h /usr/local/cuda/include/
sudo cp -P cuda/lib64/libcudnn* /usr/local/cuda/lib64/
sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*

# other Tensorflow dependencies
sudo apt-get -y install libcupti-dev

# upgrade pip
sudo pip install --upgrade pip

echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
curl https://bazel.build/bazel-release.pub.gpg | sudo apt-key add -
sudo apt-get update && sudo apt-get -y install bazel
sudo apt-get -y upgrade bazel

echo "Script done"

