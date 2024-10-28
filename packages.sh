ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" &>> $LOGFILE
VALIDATE() {
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... is $R FAILED $N" | tee -a $LOGFILE
    else
        echo -e "$2 .... is $G SUCCESS $N" | tee -a $LOGFILE
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R error: please run this script with root access $N"
    exit 1      
else
    echo -e "you are $G root $N"
fi

for package in $@
do
    yum installed $package &>> $LOGFILE
    if [ $? -ne 0 ]
    then
        yum install $package &>> $LOGFILE
        VALIDATE $? "installing of $package"
    else
        echo -e "$package is already installed.... $Y skipping $N"
    fi

