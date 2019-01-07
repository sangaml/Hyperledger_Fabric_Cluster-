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
#sleep 6m
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
sleep 3m
wget https://blockchain21.blob.core.windows.net/blockchainkey/Build-Multi-Host-Network-Hyperledger.tar.gz
tar -xzvf Build-Multi-Host-Network-Hyperledger.tar.gz
cd Build-Multi-Host-Network-Hyperledger

docker run -d --rm -it --network="my-net" --name couchdb1 -p 6984:5984 \
-e COUCHDB_USER= -e COUCHDB_PASSWORD= -e CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=my-net hyperledger/fabric-couchdb 
sleep 1m

docker run -d --rm -it --network="my-net" --link orderer.example.com:orderer.example.com \
--link peer0.org1.example.com:peer0.org1.example.com --name peer1.org1.example.com -p 9051:7051 \
-p 9053:7053 -e CORE_LEDGER_STATE_STATEDATABASE=CouchDB -e CORE_LEDGER_STATE_COUCHDBCONFIG_COUCHDBADDRESS=couchdb1:5984 \
-e CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME=admin123 -e CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD=Password@123 \
-e CORE_PEER_ADDRESSAUTODETECT=true -e CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock \
-e CORE_LOGGING_LEVEL=DEBUG -e CORE_PEER_NETWORKID=peer1.org1.example.com \
-e CORE_NEXT=true -e CORE_PEER_ENDORSER_ENABLED=true -e CORE_PEER_ID=peer1.org1.example.com \
-e CORE_PEER_PROFILE_ENABLED=true -e CORE_PEER_COMMITTER_LEDGER_ORDERER=orderer.example.com:7050 \
-e CORE_PEER_GOSSIP_ORGLEADER=true -e CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer1.org1.example.com:7051 \
-e CORE_PEER_GOSSIP_IGNORESECURITY=true -e CORE_PEER_LOCALMSPID=Org1MSP \
-e CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=my-net -e CORE_PEER_GOSSIP_BOOTSTRAP=peer0.org1.example.com:7051 \
-e CORE_PEER_GOSSIP_USELEADERELECTION=false -e CORE_PEER_TLS_ENABLED=false -v /var/run/:/host/var/run/ \
-v $(pwd)/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/msp:/etc/hyperledger/fabric/msp \
-w /opt/gopath/src/github.com/hyperledger/fabric/peer hyperledger/fabric-peer peer node start 

sleep 1m

docker run -d --rm -it --network="my-net" --name cli --link orderer.example.com:orderer.example.com \
--link peer0.org1.example.com:peer0.org1.example.com --link peer1.org1.example.com:peer1.org1.example.com \
-p 12051:7051 -p 12053:7053 -e GOPATH=/opt/gopath -e CORE_PEER_LOCALMSPID=Org1MSP \
-e CORE_PEER_TLS_ENABLED=false -e CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock -e CORE_LOGGING_LEVEL=DEBUG \
-e CORE_PEER_ID=cli -e CORE_PEER_ADDRESS=peer0.org1.example.com:7051 -e CORE_PEER_NETWORKID=cli \
-e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp \
-e CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=my-net  \
-v /var/run/:/host/var/run/ -v $(pwd)/chaincode/:/opt/gopath/src/github.com/hyperledger/fabric/examples/chaincode/go \
-v $(pwd)/crypto-config:/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ \
-v $(pwd)/scripts:/opt/gopath/src/github.com/hyperledger/fabric/peer/scripts/ \
-v $(pwd)/channel-artifacts:/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts \
-w /opt/gopath/src/github.com/hyperledger/fabric/peer hyperledger/fabric-tools /bin/bash -c './scripts/script.sh'
