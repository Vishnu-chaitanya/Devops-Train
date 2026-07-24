#!/bin/bash

# 1. Ask the user for details one by one
echo "=== Maven & Artifactory Setup ==="
read -p "Enter User: " user
read -sp "Enter API Key: " APIKey
echo "" # Newline after hidden API Key prompt
read -p "Enter ID: " ID
read -p "Enter Repository Name: " reponame
read -p "Enter Public IP: " publicip
echo "---------------------------------"

# 2. Update pom.xml safely
cd ~/tomcat10-jakartaee9/ || exit 1

BLOCK="<distributionManagement>
    <snapshotRepository>
      <id>${ID}</id>
      <name>ip-172-31-39-96-snapshots</name>
      <url>http://${publicip}:8081/artifactory/${reponame}</url>
    </snapshotRepository>
  </distributionManagement>"

# Insert BLOCK right before </project> tag
sed -i "/<\/project>/i ${BLOCK//$'\n'/\\n}" pom.xml

# 4. Overwrite ~/.m2/settings.xml directly
cat <<EOF > ~/.m2/settings.xml
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.2.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.2.0 http://maven.apache.org/xsd/settings-1.2.0.xsd">
  <servers>
    <server>
      <id>${ID}</id>
      <username>${user}</username>
      <password>${APIKey}</password>
    </server>
  </servers>
</settings>
EOF

echo "Configuration applied successfully!"

# 5. Execute build & verify deployment
echo "Starting Maven build and deployment..."
mvn clean deploy

if [ $? -eq 0 ]; then
    echo "SUCCESS: Maven deployment to Artifactory succeeded!"
else
    echo "ERROR: Maven deployment failed. Check the logs above."
    exit 1
fi
