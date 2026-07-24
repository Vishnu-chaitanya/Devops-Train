#!/bin/bash

# NOTE: Run this script as your normal user (e.g., ec2-user). 
# Do NOT run the script itself with sudo!

echo "=== 1. System Updates & Installs ==="
sudo apt update
sudo apt install openjdk-17-jdk -y
sudo apt install maven -y
sudo apt install git -y

echo "=== 2. Downloading & Extracting Artifactory (as root) ==="
# 'sudo bash -c' runs this specific block as root, replacing 'sudo su -'
sudo bash -c '
cd /opt
wget https://releases.jfrog.io/artifactory/bintray-artifactory/org/artifactory/oss/jfrog-artifactory-oss/7.68.22/jfrog-artifactory-oss-7.68.22-linux.tar.gz
tar -xzvf jfrog-artifactory-oss-7.68.22-linux.tar.gz
mv artifactory-oss-7.68.22 artifactory
rm -rf jfrog-artifactory-oss-7.68.22-linux.tar.gz
cd /opt/artifactory/app/bin
./artifactory.sh start
'

echo "Waiting 20 seconds for JFrog Artifactory to start..."
sleep 20

echo "=== 3. Testing JFrog Artifactory ==="
if curl -s http://localhost:8081/artifactory/api/system/ping > /dev/null || curl -s http://localhost:8082/router/api/v1/system/health > /dev/null; then
    echo "SUCCESS: JFrog Artifactory is running!"
else
    echo "ERROR: JFrog Artifactory is not responding."
    exit 1
fi

echo "=== 4. Downloading & Extracting Tomcat (as root) ==="
sudo bash -c '
cd /opt
wget https://dlcdn.apache.org/tomcat/tomcat-11/v11.0.24/bin/apache-tomcat-11.0.24.tar.gz
tar -xzvf apache-tomcat-11.0.24.tar.gz
mv apache-tomcat-11.0.24 tomcat
rm -rf apache-tomcat-11.0.24.tar.gz
'

echo "=== 5. Cloning and Building App (as normal user) ==="
# Script naturally acts as your normal user here (matches your 'exit' command)
cd ~
git clone https://github.com/Azure-Samples/tomcat10-jakartaee9.git
cd tomcat10-jakartaee9
mvn clean install

if [ -f "target/helloworld.war" ]; then
    echo "SUCCESS: App built successfully."
else
    echo "ERROR: Maven build failed."
    exit 1
fi

echo "=== 6. Deploying War & Starting Tomcat (as root) ==="
cd ~/tomcat10-jakartaee9/target
sudo cp helloworld.war /opt/tomcat/webapps/

sudo bash -c '
cd /opt/tomcat/bin
./startup.sh
'

echo "Waiting 10 seconds for Tomcat application to deploy..."
sleep 10

echo "=== 7. Testing Tomcat Application ==="
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/helloworld/)

if [ "$HTTP_CODE" -eq 200 ]; then
    echo "SUCCESS: App is running at http://localhost:8080/helloworld/"
else
    echo "ERROR: Tomcat app is NOT running properly. HTTP Status Code: $HTTP_CODE"
    exit 1
fi
