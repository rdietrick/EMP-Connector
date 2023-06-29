#!/bin/sh

echo
read -p "Enter Salesforce instance URL (e.g., https://github--uat.sandbox.my.salesforce.com/) or just press enter to use production: " INSTANCE_URL
if [ -z $INSTANCE_URL ]
then
    INSTANCE_URL="https://github.my.salesforce.com"
fi

npx sfdx auth:device:login --instanceurl $INSTANCE_URL -a org
PID=$!
wait $PID

ACCESS_TOKEN=$(npx sfdx force:org:display --json -u org | jq -r '.result.accessToken')

java -classpath target/emp-connector-0.0.1-SNAPSHOT-phat.jar com.salesforce.emp.connector.example.BearerTokenExample $INSTANCE_URL "${ACCESS_TOKEN}" /data/LeadChangeEvent
