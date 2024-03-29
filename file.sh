#!/bin/sh

sudo apt update

# Installing Kitware APT Repository, recommended by FlexRIC team
sudo apt install -y gpg wget
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null
echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal main' | sudo tee /etc/apt/sources.list.d/kitware.list >/dev/null
sudo apt update
sudo rm /usr/share/keyrings/kitware-archive-keyring.gpg
sudo apt install -y kitware-archive-keyring
echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal-rc main' | sudo tee -a /etc/apt/sources.list.d/kitware.list >/dev/null

# Some applications and libraries needed to install FlexRIC
sudo apt update
sudo apt install -y cmake bison byacc g++
sudo apt install -y automake autoconf libz-dev libbz2-dev lbzip2 libreadline-dev
sudo apt install -y libsctp-dev cmake-curses-gui libpcre2-dev python3-dev
sudo apt install -y python3.8

# PCRE2 is a dependency to Swig
wget https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.42/pcre2-10.42.tar.bz2
tar -xf pcre2-10.42.tar.bz2
cd pcre2-10.42/
./configure --prefix=/usr --docdir=/usr/share/doc/pcre2-10.42 --enable-unicode --enable-jit --enable-pcre2-16 --enable-pcre2-32 --enable-pcre2grep-libz --enable-pcre2grep-libbz2 --enable-pcre2test-libreadline --disable-static
make
sudo make install
cd ..
sudo rm -r pcre2-10.42 pcre2-10.42.tar.bz2 

# Swig is a dependency to FlexRIC
git clone https://github.com/swig/swig.git
cd swig
./autogen.sh
./configure --prefix=/usr/
make
sudo make install
cd ..
sudo rm -r swig

# Cloning FlexRIC
git clone https://gitlab.eurecom.fr/mosaic5g/flexric.git
git checkout v2.0.0
cd flexric
mkdir build
cd build
cmake ..
make 
sudo make install
