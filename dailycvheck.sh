#! /bin/bash
#################################################################################
#     File Name           :     dailycvheck.sh
#     Created By          :     thieryl
#     Email               :
#     Creation Date       :     [Mon 11 Jun 2018 09:12:52 AM +04]
#     Last Modified       :     [Mon 11 Jun 2018 10:02:00 AM +04]
#     Description         :
#     Usage               :
#                         :
#################################################################################

URL=$1
SERVER=$2
MAGENTO_ROOT=$3

if  [ -z ${MAGENTO_ROOT} ]
then
    MAGENTO_ROOT="/var/www/magento/current"
else
    echo ${MAGENTO_ROOT}
fi

cat ${URL} |
while read line
do
    echo $line
    curl -sIl $line | grep HTTP
    echo "====================================="
done

# Check expose version
cat ${URL} | head -1 |
while read line
do
    echo "Web server version..."
    echo $line
    curl -sIl $line | egrep -i 'server|powered'
done


if [ -z ${SERVER} ]
then
    
    # Check Diskspace  => 75% Used and for sqldumps
    for line in $(cat ${SERVER})
    do
        echo "Check disk usage..."
        echo $line
        ssh -o loglevel=error $line df -h|grep "75%"
        echo "==================================="
        echo "Check for SQL dumps..."
        ssh -o loglevel=error $line sudo ls -lrt ${MAGENTO_ROOT}|grep sql;
        ssh -o loglevel=error $line sudo ls -lrt ${MAGENTO_ROOT}/htdocs/var/|grep sql;
        ssh -o loglevel=error $line sudo ls -lrt /tmp/|grep sql;
        echo "==================================="
    done
else
    echo "You need to check the disk space manually."
fi