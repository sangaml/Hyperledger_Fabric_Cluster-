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
sleep 6m
wget https://blockchainkey.blob.core.windows.net/blockchain/token
chmod +x token
./token

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
sleep 3m
wget https://blockchainkey.blob.core.windows.net/blockchain/Build-Multi-Host-Network-Hyperledger.tar.gz
tar -xzvf Build-Multi-Host-Network-Hyperledger.tar.gz
cd Build-Multi-Host-Network-Hyperledger

docker run -d --rm -it --network="my-net" --name couchdb0 -p 5984:5984 \
-e COUCHDB_USER= -e COUCHDB_PASSWORD= -e CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=my-net hyperledger/fabric-couchdb 

sleep 1m

docker run -d --rm -it --link orderer.example.com:orderer.example.com --network="my-net" --name peer0.org1.example.com \
-p 8051:7051 -p 8053:7053 -e CORE_LEDGER_STATE_STATEDATABASE=CouchDB \
-e CORE_LEDGER_STATE_COUCHDBCONFIG_COUCHDBADDRESS=couchdb0:5984 -e CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME=admin \
-e CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD=Password@123 -e CORE_PEER_ADDRESSAUTODETECT=true -e CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock \
-e CORE_LOGGING_LEVEL=DEBUG -e CORE_PEER_NETWORKID=peer0.org1.example.com -e CORE_NEXT=true \
-e CORE_PEER_ENDORSER_ENABLED=true -e CORE_PEER_ID=peer0.org1.example.com -e CORE_PEER_PROFILE_ENABLED=true \
-e CORE_PEER_COMMITTER_LEDGER_ORDERER=orderer.example.com:7050 -e CORE_PEER_GOSSIP_IGNORESECURITY=true \
-e CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=my-net -e CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer0.org1.example.com:7051 \
-e CORE_PEER_TLS_ENABLED=false -e CORE_PEER_GOSSIP_USELEADERELECTION=false \
-e CORE_PEER_GOSSIP_ORGLEADER=true -e CORE_PEER_LOCALMSPID=Org1MSP -v /var/run/:/host/var/run/ \
-v $(pwd)/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp:/etc/hyperledger/fabric/msp \
-w /opt/gopath/src/github.com/hyperledger/fabric/peer hyperledger/fabric-peer peer node start
