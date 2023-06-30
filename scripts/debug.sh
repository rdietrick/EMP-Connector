#!/bin/sh

echo
read -p "Enter Salesforce instance URL (e.g., https://github--uat.sandbox.my.salesforce.com/) or just press enter to use production: " INSTANCE_URL
if [ -z $INSTANCE_URL ]
then
    INSTANCE_URL="https://github.my.salesforce.com"
fi

npx sfdx-cli auth:device:login --instance-url $INSTANCE_URL -a org
PID=$!
wait $PID

ACCESS_TOKEN=$(npx sfdx-cli force:org:display --json -u org | jq -r '.result.accessToken')

echo
read -p "Enter the name of the channel you wish to subscribe to (e.g., /data/LeadChangeEvent): " CHANNEL

java -classpath target/emp-connector-0.0.1-SNAPSHOT-phat.jar com.salesforce.emp.connector.example.BearerTokenExample $INSTANCE_URL "${ACCESS_TOKEN}" $CHANNEL
