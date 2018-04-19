#!/bin/bash

set -e
sqlname=$1
sqlpass=$2
echo "Starting mysql container..."
if docker run -tid --name $sqlname -p 3306:3306 -e MYSQL_ROOT_PASSWORD=passwd -v "$PWD:/tmp" mysql:5.7 ; then
    echo "$sqlname container created"
else
    docker stop $sqlname && docker rm $sqlname && \
        docker run -tid --name $sqlname -p 3306:3306 -e MYSQL_ROOT_PASSWORD=passwd -v "$PWD:/tmp" mysql:5.7
fi


sleep 5
#sqlip=$(docker inspect $sqlname --format "{{ .NetworkSettings.Networks.bridge.IPAddress  }}")
sqlip="127.0.0.1"
echo "Container IP = $sqlname"
echo "Loading the fake database..."

set -x
echo "Creating the database..."
mysql -h "$sqlip" -u root -p"$sqlpass" -Bse "create database employees;"
echo "Importing the fake data..."
mysql -h "$sqlip" -u root -p"$sqlpass" "employees" < "employees.sql"
set +x
echo "DONE!"
