#Gather the signed request
if [ "$2" = "wc" ]
then SIGNED_REQUEST="`ssh qe@qa-tools.sjc.kixeye.com php /home/qe/QEWebInterface/scripts/AuthTool.php -u $4 -p $6 -n wardevel -e qae@kixeye.com -l log.log`"
sed -i "s/JSON.decode(.*)/JSON.decode(${SIGNED_REQUEST})/g" $8
fi
