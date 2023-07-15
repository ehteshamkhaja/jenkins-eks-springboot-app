#!/bin/bash

# AUTHOR : KHAJA EHTESHAM

## THIS SCRIPT IS TO CONFIGURE JENKINS SERVER

sudo apt-get update -y
sudo apt-get install wget curl -y
sudo curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
sudo echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]  https://pkg.jenkins.io/debian binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install fontconfig openjdk-11-jre -y
sudo apt-get install jenkins -y

