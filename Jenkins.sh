#!/bin/bash

distribution=$(cat /etc/os-release | grep "^ID=" | cut -d "=" -f2 | sed 's/"//g')

if [ $distribution == "rhel" ]; then
    
    echo "The Distribution is RedHat"

    sudo yum install wget -y

    sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/rpm-stable/jenkins.repo

    sudo yum upgrade -y

    sudo yum install fontconfig java-21-openjdk -y
    
    sudo yum install jenkins -y

    sudo systemctl daemon-reload
    sudo systemctl restart jenkins

elif [ $distribution == "ubuntu" ]; then

    echo "The Distribution is Ubuntu"

    sudo apt install wget -y

    sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
    
    echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

    sudo apt update -y
    sudo apt install fontconfig openjdk-21-jre -y

    sudo apt install jenkins

    sudo systemctl daemon-reload
    sudo systemctl restart jenkins
else
    echo "The Distribution $distribution is not supported"
fi
