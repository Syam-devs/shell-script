#!/bin/bash
ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/TMP/$0-$TIMESTAMP.log"

VALIDATE(){
    if [ $? -ne 0]
then 
    echo "error: $1 ... is failed"
else    
    echo "$2 .... is success"
fi

}
if [ $ID -ne 0 ]
then    
    echo "error: please run this script with root access"
else
    echo "you are root"
fi

yum install mysql -y &>> $LOGFILE

VALIDATE $? "installing mysql"

yum install git -y &>> $LOGFILE

VALIDATE $? "installing git"

