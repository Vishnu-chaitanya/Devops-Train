#!/bin/bash
echo "pwd"
cd ~
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-26.7.0.124771.zip?_gl=1*sp44lq*_gcl_au*MTk2MTI5NDg4NS4xNzg1NDgwMDg3Li0uLS4xNzg1NDgwMDg3LjI2NjkwNzEwMS4xNzg1NDgwMDg3LjE3ODU0ODAyNjg.*_ga*MTQwMDAxNzAxMS4xNzg1NDgwMDg3*_ga_9JZ0GZ5TC6*czE3ODU0ODAwODYkbzEkZzEkdDE3ODU0ODAyODgkajQwJGwwJGgw
mv sonarqube-26.7.0.124771.zip\?_gl\=1\*h6da8j\*_gcl_au\*MTk2MTI5NDg4NS4xNzg1NDgwMDg3Li0uLS4xNzg1NDgwMDg3LjI2NjkwNzEwMS4xNzg1NDgwMDg3LjE3ODU0ODAyNjg.\*_ga\*MTQwMDAxNzAxMS4xNzg1NDgwMDg3\*_ga_9JZ0GZ5TC6\*czE3ODU0ODwODYkbzEkZzEkdDE3ODU0ODAyODgkajQwJG sonarqube.zip
sudo apt install uzip -y
unzip sonarqube.zip
mv sonarqube-26.7.0.124771 sonarqube
cd ~/sonarqube/bin
./sonar.sh start
