#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)

LOGFILE="/tmp/$(basename $0)-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" | tee -a $LOGFILE

VALIDATE() {
    if [ $1 -ne 0 ]; then
        echo -e "error: $2 ... is ${R}FAILED${N}" | tee -a $LOGFILE
        exit 1
    else
        echo -e "$2 .... is ${G}SUCCESS${N}" | tee -a $LOGFILE
    fi
}

if [ $ID -ne 0 ]; then
    echo -e "${R}error: please run this script with root access${N}"
    exit 1
else
    echo -e "you are ${G}root${N}"
fi

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? "copying mongo.repo file"

yum install mongodb-org -y &>> $LOGFILE
VALIDATE $? "installing mongodb-org"

systemctl enable mongod &>> $LOGFILE
VALIDATE $? "enabling mongod service"

systemctl start mongod &>> $LOGFILE
VALIDATE $? "starting mongod service"

echo "mongodb installation completed" | tee -a $LOGFILE

# Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOGFILE

systemctl restart mongod &>> $LOGFILE
VALIDATE $? "restarting mongod service"
