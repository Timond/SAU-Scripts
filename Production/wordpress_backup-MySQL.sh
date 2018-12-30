#!/bin/bash
#Written by Tim Duncan - 2017
#SET DOCROOT
echo Enter the Wordpress docroot "(where wp-config.php is located)":
read -e DOCROOT
lastChar="$(echo "${DOCROOT: -1}")"
      #make sure the trailing / is on the directory string
      if [ ! "$lastChar" == "/" ]; then
          dir=$(echo $DOCROOT'/')
          DOCROOT=$dir
      fi
FILEPATH="$DOCROOT"wp-config.php
if [ ! -f "$FILEPATH" ]; then
        echo "$FILEPATH" does not exist - exiting.
        exit
fi
#END SET DOCROOT
#FUNCTIONS
#Function To Get The Value Inside Quotes In wp-config
function getValue {
	echo $2 | cut -d "'" -f2
}
#Function to set backup path
function setBackupPath {
echo Enter backup directory:
	read -e dir
	lastChar="$(echo "${dir: -1}")"
	#make sure the trailing / is on the directory string
	if [ ! "$lastChar" == "/" ]; then
        	dir=$(echo $dir'/')
	fi
	if [ ! -d "$dir" ]; then
        	#Dir doesn't exist - create it
	        echo Directory $dir does not exist. Creating $dir
	        mkdir -p $dir
	fi
	BACKUPPATH=$dir
	echo Backup Path Set To: $BACKUPPATH
}
#Function to backup database - #BACKUPPATH #DBHOST #DBUSER and $DBNAME must be set
function backupDatabase {
	# The $# variable = nuddmber of function arguments
	if [ ! $# -eq 0 ]; then
    		DBDUMPPATH="$1""$DBNAME"".sql"
	else
		DBDUMPPATH="$BACKUPPATH""$DBNAME"".sql"
	fi
		echo Dumping database to: "$DBDUMPPATH"
	mysqldump $DBNAME -u $DBUSER --password="$DBPASS" -h $DBHOST > $DBDUMPPATH
    	RES=$?
    	if [ ! "$RES" == "0" ]; then
        	echo 'DB backup failed with exit code: ' $RES
        	exit
	    fi
	echo Database dumped successfully to: $DBDUMPPATH
}
function backupDocroot {
	echo Please enter backup name "(without .tar.gz)":
	read BNAME
	cd $DOCROOT
	echo Creating Archive of: $(pwd)
	ARCHIVE="$BACKUPPATH""$BNAME"".tar"
	tar -cf $ARCHIVE .
	RES=$?
	if [ $RES == "0" ]; then
		echo Success! Archive Created: "$BACKUPPATH""$BNAME"".tar"
	else
		echo Failure! Exit Code: $RES
	fi
}

function addDbToArchive {
	ARCHIVE="$BACKUPPATH""$BNAME"".tar"
	if [ -f $ARCHIVE ]; then
		backupDatabase $BACKUPPATH
		cd $BACKUPPATH
		echo Adding MySQL Dump to archive.
		tar --append --file=$ARCHIVE "./""$DBNAME"".sql"	
		RES=$?
		if [ $RES == "0" ]; then
                	echo Success! $DBDUMPPATH was added to: $ARCHIVE
			echo Removing temporary DB: $DBDUMPPATH
			rm $DBDUMPPATH
        	else
                	echo Failure! Exit Code: $RES
		fi
	else
		echo $ARCHIVE Does not exist - aborting
		exit
	fi
}
function gzipArchive {
	echo Compressing Archive
	cd $BACKUPPATH
	gzip $ARCHIVE
	RES=$?
        if [ $RES == "0" ]; then
	        echo Backup Completed Successfully: $ARCHIVE".gz"
        else
        	echo Failure! Exit Code: $RES
        fi
}
#END FUNCTIONS
#GLOBAL VARIABLES
DBNAME=$(getValue $(grep DB_NAME $FILEPATH))
DBUSER=$(getValue $(grep DB_USER $FILEPATH))
DBPASS=$(getValue $(grep DB_PASSWORD $FILEPATH))
DBHOST=$(getValue $(grep DB_HOST $FILEPATH))
#END GLOBAL VARIABLES
#MAIN PROGRAM
#SHOW RESULTS OF PARSING THE WP-CONFIG FILE
echo Scanning: $FILEPATH

echo "
        Database Name: $DBNAME
        Database Username: $DBUSER
        Database Password: $DBPASS
        Database Host: $DBHOST
"

#MAIN MENU
	echo "	1. Backup database
	2. Backup document root & database
	3. Backup document root only
	4. Exit"

	read answer
	if [ "$answer" == "1" ] ; then
		setBackupPath
        	backupDatabase
        exit
	fi

	if [ "$answer" == "2" ] ; then
        	setBackupPath
		backupDocroot
		addDbToArchive
		gzipArchive
	        exit
	fi

    if [ "$answer" == "3" ] ; then
        setBackupPath
        backupDocroot
	gzipArchive
        exit
    fi

    exit
#END MAIN PROGRAM
