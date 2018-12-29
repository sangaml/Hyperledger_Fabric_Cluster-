#!/bin/bash

#########Membernode############
#######Install Docker#############
wget https://blockchain21.blob.core.windows.net/blockchainkey/id_rsa
wget https://blockchain21.blob.core.windows.net/blockchainkey/id_rsa.pub
chmod 400 id_rsa
chmod 400 id_rsa.pub
cp id_rsa id_rsa.pub .ssh
echo "10.0.0.6 node2 
10.0.0.7 node3 
10.0.0.8 node4 " >> /etc/hosts

apt-get update -y
apt-get install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install docker-ce -y
apt install docker-compose -y
docker swarm init --advertise-addr 10.0.0.6 | sed -n 5p >> token
scp token admin123@node2:$HOME
scp token admin123@node3:$HOME
scp token admin123@node4:$HOME


##########Install and configure Node
wget https://nodejs.org/dist/v10.15.0/node-v10.15.0-linux-x64.tar.xz
tar -xvf node-v10.15.0-linux-x64.tar.xz
export NODEJS_HOME=$HOME/node-v10.15.0-linux-x64/bin
export PATH=$NODEJS_HOME:$PATH
.~/.profile
ln -s $HOME/node-v10.15.0-linux-x64/bin/node /usr/bin/node
ln -s $HOME/node-v10.15.0-linux-x64/bin/npm /usr/bin/npm
ln -s $HOME/node-v10.15.0-linux-x64/bin/npx /usr/bin/npx

#############Download and configure Golang#################
apt install golang-go -y

############Download and Install Python###############
npm install npm@5.6.0 -g
apt install npm -y
npm install npm@5.6.0 -g
apt-get install python -y

##########Downloading hyperledger fabric repo form git ##############
git clone https://github.com/sangaml/Build-Multi-Host-Network-Hyperledger.git
curl -sSL http://bit.ly/2ysbOFE | bash -s 1.4.0-rc2
export PATH=$HOME/fabric-samples/bin:$PATH
ln -s $HOME/fabric-samples/bin/cryptogen /usr/bin/cryptogen
ln -s $HOME/fabric-samples/bin/configtxgen /usr/bin/configtxgen

cd Build-Multi-Host-Network-Hyperledger/
./bmhn.sh
cd ..
scp -r Build-Multi-Host-Network-Hyperledger admin123@node2:$HOME
scp -r Build-Multi-Host-Network-Hyperledger admin123@node3:$HOME
scp -r Build-Multi-Host-Network-Hyperledger admin123@node4:$HOME
