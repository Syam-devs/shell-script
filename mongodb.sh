#!/bin/bah

ID=$(id -u)

R="\e[31"
G="\e[32"
R="\e[33"
N="\e[0"
Y="\e[33"

TIMESTAMP=$(date +%F-%H-%M-%S)

LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" &>> $LOGFILE

function VALIDATE() {
    if [ $1 -ne 0 ]
    then
        echo -e "error: $2 ... is $R FAILED $N" &>> $LOGFILE
        exit 1
    else
        echo -e "$2 .... is $G SUCCESS $N" &>> $LOGFILE
    fi
}

if [ ID -ne 0 ]
then
    echo -e "$R error: please run this script with root access $N"
    exit 1
else
    echo -e "you are $G root $N"
fi

cp mongo.repo /etc/yum.repos.d/mongo.rep &>> $LOGFILE

VALIDATE $? "copying mongo.repo file"

yum install mongodb-org -y &>> $LOGFILE

VALIDATE $? "installing mongodb-org"

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "enabling mongod service"

systemctl start mongod &>> $LOGFILE

VALIDATE $? "starting mongod service"

echo "mongodb installation completed"

# Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOGFILE

systemctl restart mongod

VALIDATE $? "restarting mongod service"

