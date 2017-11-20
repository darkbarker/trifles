#!/usr/bin/env bash

# copymysql 0.99 @ bitel dimon (dark_barker)
VER="copymysql 0.99"

MUSER=''
MPASSWORD=''
MDB1=''
MDB2=''
MBIN='mysql'
MBIN2='mysqldump'
MHOST='localhost'

while getopts "u:p:D:b:B:h:" optname; do
	case "$optname" in
		"u")			MUSER=$OPTARG		;;
		"p")			MPASSWORD=$OPTARG	;;
		"D")			MDB=$OPTARG			;;
		"b")			MBIN=$OPTARG		;;
		"B")			MBIN2=$OPTARG		;;
		"h")			MHOST=$OPTARG		;;
		"x")
			echo "$VER"
			echo "u - mysql-user"
			echo "p - mysql-password"
			echo "D - mysql-database"
			echo "b - mysql-binary (default: mysql)"
			echo "B - mysqldump-binary (default: mysqldump)"
			echo "h - mysql-host (default: localhost)"
			echo "example: copymysql -u root -p 666 -b /usr/bin/mysql -B /usr/bin/mysqldump -h 192.168.184.245 db_bgbilling_from db_bgbilling_to"
			exit 0
		;;
	esac
done

MDB1=${@:$OPTIND:1}
MDB2=${@:$OPTIND+1:1}

do_mysql_command(){
	command="MYSQL_PWD=$MPASSWORD $MBIN --user=$MUSER --database=$MDB --host=$MHOST --silent -e \"$1\""
	eval $command
}

echo -e "\033[1m=> create database: $MDB2\033[0m";
do_mysql_command "CREATE DATABASE $MDB2"

echo -e "\033[1m=> copy from $MDB1 to $MDB2\033[0m";
command="MYSQL_PWD=$MPASSWORD $MBIN2 --user=$MUSER --host=$MHOST $MDB1 | $MBIN --user=$MUSER --database=$MDB2 --host=$MHOST"
#echo $command
eval $command
