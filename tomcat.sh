#!/bin/bash

# NOTE: Run this script as your normal user (e.g., ec2-user). 
# Do NOT run the script itself with sudo!

# Exit on any error
set -e

echo "=== 1. Configuration ==="
# Prompt for custom Tomcat port to avoid conflict with Jenkins (default: 8088)
read -p "Enter port for Tomcat [default: 8088]: " TOMCAT_PORT
TOMCAT_PORT=${TOMCAT_PORT:-8088}

echo "Tomcat will run on port: $TOMCAT_PORT"

echo "=== 2. System Updates & Installs ==="
sudo apt update
sudo apt install openjdk-21-jdk curl -y

echo "=== 3. Downloading & Extracting Tomcat (as root) ==="
sudo bash -c '
cd /opt
wget https://dlcdn.apache.org/tomcat/tomcat-11/v11.0.24/bin/apache-tomcat-11.0.24.tar.gz
tar -xzvf apache-tomcat-11.0.24.tar.gz
mv apache-tomcat-11.0.24 tomcat
rm -rf apache-tomcat-11.0.24.tar.gz
'

echo "=== 4. Updating Tomcat Port to $TOMCAT_PORT ==="
# Update default port 8080 to the user-specified port in Tomcat's server.xml
sudo sed -i "s/port=\"8080\"/port=\"$TOMCAT_PORT\"/g" /opt/tomcat/conf/server.xml

echo "=== 5. Starting Tomcat (as root) ==="
sudo bash -c '
cd /opt/tomcat/bin
./startup.sh
'

echo "Waiting 5 seconds for Tomcat to initialize..."
sleep 5

echo "=== 6. Testing Tomcat Service ==="
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:${TOMCAT_PORT}/")

if [ "$HTTP_CODE" -eq 200 ]; then
    echo "SUCCESS: Tomcat is running at http://localhost:${TOMCAT_PORT}/"
else
    echo "ERROR: Tomcat is NOT responding. HTTP Status Code: $HTTP_CODE"
    exit 1
fi
