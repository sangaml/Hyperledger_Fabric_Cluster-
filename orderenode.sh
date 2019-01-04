#!/bin/bash

#######Install Docker#############

apt-get update -y
apt-get install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install docker-ce -y
apt install docker-compose -y
#sleep 5m
#wget https://blockchain21.blob.core.windows.net/blockchainkey/token
#chmod +x token
#./token

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
#sleep 2m
#wget https://blockchain21.blob.core.windows.net/blockchainkey/Build-Multi-Host-Network-Hyperledger.tar.gz
#tar -xzvf Build-Multi-Host-Network-Hyperledger.tar.gz
#cd Build-Multi-Host-Network-Hyperledger

#docker run -d --rm -it --network="my-net" --name orderer.example.com -p 7050:7050 \
#-e ORDERER_GENERAL_LOGLEVEL=debug -e ORDERER_GENERAL_LISTENADDRESS=0.0.0.0 -e ORDERER_GENERAL_LISTENPORT=7050 \
#-e ORDERER_GENERAL_GENESISMETHOD=file -e ORDERER_GENERAL_GENESISFILE=/var/hyperledger/orderer/orderer.genesis.block \
#-e ORDERER_GENERAL_LOCALMSPID=OrdererMSP -e ORDERER_GENERAL_LOCALMSPDIR=/var/hyperledger/orderer/msp \
#-e ORDERER_GENERAL_TLS_ENABLED=false -e CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=my-net \
#-v $(pwd)/channel-artifacts/genesis.block:/var/hyperledger/orderer/orderer.genesis.block \
#-v $(pwd)/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp:/var/hyperledger/orderer/msp \
#-w /opt/gopath/src/github.com/hyperledger/fabric hyperledger/fabric-orderer orderer
