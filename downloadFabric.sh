#!/bin/bash

# Exit on first error, print all commands.
set -ev

# Set ARCH
ARCH=`uname -m`

# Grab the current directory.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Pull and tag the latest Hyperledger Fabric base image.

curl -sSL https://goo.gl/6wtTN5 | bash -s 1.1.0
docker pull hyperledger/fabric-ca:x86_64-1.1.0
docker pull hyperledger/fabric-couchdb:x86_64-0.4.6
docker pull hyperledger/fabric-zookeeper:x86_64-0.4.6
docker pull hyperledger/fabric-kafka:x86_64-0.4.6

