#!/bin/bash

#########Membernode############
#######Install Docker#############
dest1="https://blockchain21.blob.core.windows.net/blockchainkey/token"
key="jpD+jBm6V0GgYLbSyUECGIt9bFhwyJA3M8iguAdShbbj2tM+7wuDAp73LF3EOT8EfWT2TFkcq488rHPnyVWM+w=="
dest2="https://blockchain21.blob.core.windows.net/blockchainkey/Build-Multi-Host-Network-Hyperledger.tar.gz"
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
docker swarm init --advertise-addr 10.0.0.5 | sed -n 5p >> token

echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod/ xenial main" > azure.list
sudo cp ./azure.list /etc/apt/sources.list.d/
sudo apt-key adv --keyserver packages.microsoft.com --recv-keys EB3E94ADBE1229CF
sudo apt-get update -y
sudo apt-get install azcopy -y
azcopy --source token --destination $dest1 --dest-key $key 

##########Install and configure Node
wget https://nodejs.org/dist/v10.15.0/node-v10.15.0-linux-x64.tar.xz
tar -xvf node-v10.15.0-linux-x64.tar.xz
export NODEJS_HOME=$HOME/node-v10.15.0-linux-x64/bin
export PATH=$NODEJS_HOME:$PATH
.~/.profile
ln -s /var/lib/waagent/custom-script/download/0/node-v10.15.0-linux-x64/bin/node /usr/bin/node
ln -s /var/lib/waagent/custom-script/download/0/node-v10.15.0-linux-x64/bin/npm /usr/bin/npm
ln -s /var/lib/waagent/custom-script/download/0/node-v10.15.0-linux-x64/bin/npx /usr/bin/npx

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
ln -s /var/lib/waagent/custom-script/download/0/fabric-samples/bin /usr/bin/cryptogen
ln -s /var/lib/waagent/custom-script/download/0/fabric-samples/bin /usr/bin/configtxgen

cd Build-Multi-Host-Network-Hyperledger/
./bmhn.sh
cd ..

tar -czvf Build-Multi-Host-Network-Hyperledger.tar.gz Build-Multi-Host-Network-Hyperledger
azcopy --source Build-Multi-Host-Network-Hyperledger.tar.gz --destination $dest2 --dest-key $key
