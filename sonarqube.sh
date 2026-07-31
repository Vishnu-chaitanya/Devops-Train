#!/bin/bash
set -e

echo "Current Directory: $(pwd)"
cd ~

# 1. Update and install dependencies
sudo apt update -y
sudo apt install unzip -y

# 2. Download directly to sonarqube.zip (using a clean URL)
wget -O sonarqube.zip "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.4.1.88267.zip"

# 3. Unzip and rename
unzip sonarqube.zip
mv sonarqube-10.4.1.88267 sonarqube

# 4. Navigate to the correct architecture directory and start
cd ~/sonarqube/bin/linux-x86-64
./sonar.sh start
