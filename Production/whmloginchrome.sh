#!/bin/bash
if [ -z $2 ]; then
	echo No Port Set - connecting on default SSH port
	URL=$(ssh $1 whmapi1 create_user_session user=root service=whostmgrd | grep url | cut -d ':' -f2-4); open -a "Google Chrome" $URL
else
	echo Connecting on port $2
	URL=$(ssh -p$2 $1 whmapi1 create_user_session user=root service=whostmgrd | grep url | cut -d ':' -f2-4); open -a "Google Chrome" $URL
fi
