# Terraform Install

You should be able to deploy main.tf without any difficulty unless you do not have a public_key as ~/.ssh/id_rsa.pub. That should be the only thing you need to change in order to access the instances using public_key authentication.

```
terraform init
terraform plan
terraform apply
```

SSH into both instances with
```
ssh ubuntu@'hostnameofAWSEC2instance'
cd fabric-dev-servers-multipeer
```

On the machine 'ubuntu@10.142.0.2' run:
```
./startFabric.sh
```

On the machine 'ubuntu@10.142.0.3' run:
```
./startFabric-Peer2.sh
```

On the machine 'ubuntu@10.142.0.2' run:
```
./createPeerAdminCard.sh
nohup composer-playground -p 8181 &
cd ..
git clone https://github.com/InflatibleYoshi/blockchain-explorer
sudo apt install postgresql postgresql-contrib
cd blockchain-explorer
git checkout release-3
sudo -u postgres psql
\i app/db/explorerpg.sql
\q
npm install
cd app/test
npm install
npm run test
cd ../../client
npm install
npm test -- -u –coverage
npm run build
cd ..
./start.sh
```


You will find composer at the Hostname of the instance you ran composer playground on at hostnameofAWSEC2instance:8181 and blockchain explorer on port 8080

To run the Composer REST API:
```
npm install -g composer-rest-server@0.19.17
composer-rest-server

? Enter the name of the business network card to use: alice@trade-network
? Specify if you want namespaces in the generated REST API: always use namespace
s
? Specify if you want to enable authentication for the REST API using Passport: 
No
? Specify if you want to enable event publication over WebSockets: Yes
? Specify if you want to enable TLS security for the REST API: No

```
You will find the REST API at port 3000 of the AWS instance you created

