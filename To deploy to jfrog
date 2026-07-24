#!/bin/bash

# 1. Validate argument count
if [ $# -ne 5 ]; then
    echo "Usage: $0 <user> <APIKey> <ID> <reponame> <publicip>"
    exit 1
fi

# 2. Assign positional arguments to variables
user="$1"
APIKey="$2"
ID="$3"
reponame="$4"
publicip="$5"

# 3. Update pom.xml safely
cd ~/tomcat10-jakartaee9/ || exit 1

BLOCK="<distributionManagement>
    <snapshotRepository>
      <id>${ID}</id>
      <name>ip-172-31-39-96-snapshots</name>
      <url>http://${publicip}:8081/artifactory/${reponame}</url>
    </snapshotRepository>
  </distributionManagement>"

# Insert BLOCK directly before </project> (the last line)
sed -i "/<\/project>/i ${BLOCK//$'\n'/\\n}" pom.xml

# 4. Overwrite ~/.m2/settings.xml
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

# 5. Execute build & test deployment success
echo "Starting Maven build and deployment..."
mvn clean deploy

if [ $? -eq 0 ]; then
    echo "SUCCESS: Maven deployment to Artifactory succeeded!"
else
    echo "ERROR: Maven deployment failed. Check the logs above."
    exit 1
fi
