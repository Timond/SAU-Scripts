#!/bin/bash
URLENCODE="/Users/network/tim.duncan/Scripts/urlencode.sh"
if [ -z $1 ]; then
	echo 'Usage is: whm_install_ssl [ip/hostname] [port(optional)]'
	exit 1
fi
if  [ -z $2 ]; then
	echo Using port 2929
	sshport="2929"
else
	echo "Using port $2"
	sshport="$2"
fi
	echo 'Before proceeding make sure you have both the certificate and private key. The CA bundle is downloaded by WHM automatically.'
	echo Enter domain name:
	read domainname

	echo Paste the Certificate file, then press ENTER, then press CTRL+D:
	rawcert=$(</dev/stdin)

#echo "$rawcert"
	echo Paste the Private Key, then press ENTER, then press CTRL+D:

	rawkey=$(</dev/stdin)
#echo "$rawkey"

	echo Urlencoding input...
	cert=$(sh "$URLENCODE" "$rawcert")
	key=$(sh "$URLENCODE" "$rawkey")

	echo UrlEncoded certificate:
	echo "$cert"
	
	echo UrlEncoded private key:
	echo "$key"

	domainusers=$(ssh "$1" -p "$sshport" cat /etc/userdomains | grep "$domainname")

	username=$(echo "$domainusers" | grep "$domainname" | cut -d ':' -f2 | head -1 | xargs)

	echo "
	cPanel username: "$username"
	Server: "$1"
	SSH port: "$sshport"
	Domain: "$domainname"
	Is this correct? y/n?"

	read answer

if [[ "$answer" == "y" ]]; then
	echo Installing certificate for "$domainname"
	ssh "$1" -p "$sshport" uapi --user="$username" SSL install_ssl domain="$domainname" cert="$cert" key="$key"
else
	echo "Cancelling"
	exit 0
fi

