#!/bin/bash
ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
R="\e[31m"
G="\e[32m"
N="\e[0m"
LOGFILE="/tmp/$0-$TIMESTAMP.log"
echo "script started at $TIMESTAMP" &>> $LOGFILE

VALIDATE() {
    if [ $? -ne 0 ]
    then 
        echo -e "error: $2 ... is $R FAILED $N"
        exit 1
    else    
        echo -e "$2 .... is $G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then    
    echo -e "$R error: please run this script with root access $N"
    exit 1
else
    echo -e "you are $G root $N"
fi

yum install mysql -y &>> $LOGFILE

VALIDATE $? "installing mysql"

yum install git -y &>> $LOGFILE

VALIDATE $? "installing git"

