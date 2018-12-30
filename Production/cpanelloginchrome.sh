#!/bin/bash
if [ -z $2 ]; then
	echo No Port Set - connecting to $1 on default SSH port
	URL=$(ssh $1 'CPUSER=$(grep '^$1:' /etc/userdomains | cut -d ":" -f2 | xargs); whmapi1 create_user_session user="$CPUSER" service=cpaneld | grep url | cut -d ":" -f2-4'); open -a "Google Chrome" $URL
else
	echo Connecting to $1 on port $2
	URL=$(ssh $1 -p$2 'CPUSER=$(grep '^$1:' /etc/userdomains | cut -d ":" -f2 | xargs); whmapi1 create_user_session user="$CPUSER" service=cpaneld | grep url | cut -d ":" -f2-4'); open -a "Google Chrome" $URL
fi
