#!/usr/bin/env bash

# mysql2utf8 0.99 @ bitel dimon (dark_barker)
VER="mysql2utf8 0.99"

MUSER=''
MPASSWORD=''
MDB=''
MBIN='mysql'
MHOST='localhost'

while getopts "u:p:D:b:h:" optname; do
	case "$optname" in
		"u")
			MUSER=$OPTARG
		;;
		"p")
			MPASSWORD=$OPTARG
		;;
		"D")
			MDB=$OPTARG
		;;
		"b")
			MBIN=$OPTARG
		;;
		"h")
			MHOST=$OPTARG
		;;
		"x")
			echo "$VER"
			echo "u - mysql-user"
			echo "p - mysql-password"
			echo "D - mysql-database"
			echo "b - mysql-binary (default: mysql)"
			echo "h - mysql-host (default: localhost)"
			echo "example: mysql2utf8 -u root -p 666 -D bgbilling_test_utf8 -b /usr/bin/mysql -h 192.168.184.245"
			exit 0
		;;
	esac
done

do_mysql_command(){
	command="MYSQL_PWD=$MPASSWORD $MBIN --user=$MUSER --database=$MDB --host=$MHOST --silent -e \"$1\""
	eval $command
}

for t in $(do_mysql_command "SHOW TABLES;");
do
	echo -e "\033[1m=> table: $t\033[0m";
	tablestatus=$(do_mysql_command "SHOW TABLE STATUS FROM $MDB LIKE '$t';")
	if [ -z "${tablestatus##*utf8_unicode_ci*}" ] ;then
		echo " already in utf8, skip"
	else
		echo " convert $MDB.$t..."
		do_mysql_command "ALTER TABLE $t CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
	fi
done

echo -e "\033[1m=> database: $MDB\033[0m";
echo " convert $MDB..."
do_mysql_command "ALTER DATABASE $MDB CHARACTER SET utf8 COLLATE utf8_unicode_ci;"

