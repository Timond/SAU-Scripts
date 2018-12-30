#!/bin/bash
if [ -f vm.list.temp ]; then
	echo Removing temp file vm.list.temp
	rm -f vm.list.temp
fi
if [ -f vm.list ]; then
	echo Removing old vm.list
	rm -f vm.list
fi

function getvmlist() {
	echo Attempting to get VM list from "$servername" on IP "$ip"
	(ssh -p22 root@"$ip" "ls -lah /home/xen/") >> vm.list.temp
	if [ "$?" -eq "0" ]; then
		echo Success
	else
		echo Failure
		echo Removing temp files
		rm -f vm.list.temp
		exit 1
	fi
}

servername="xen7"
ip="27.50.83.252"
getvmlist

servername="xen8"
ip="27.50.86.250"
getvmlist

servername="xen9"
ip="27.50.86.249"
getvmlist

servername="xen12new"
ip="27.50.83.249"
getvmlist

servername="xen-ssd-1"
ip="27.50.86.248"
getvmlist

servername="xen-ssd-2"
ip="27.50.83.246"
getvmlist

servername="xen-ssd-3"
ip="27.50.89.247"
getvmlist

servername="xen-ssd-4"
ip="27.50.86.254"
getvmlist

echo Extracting VM list from temporary file, saving to vm.list
awk '{print $9}' vm.list.temp | grep vm | grep -v back > vm.list

echo Removing temporary file vm.list.temp
rm -f vm.list.temp

echo Uploading vm.list to root@221.121.128.27:/mnt/xen-storage/ "(virt-ftp-1-1.servercontrol.com.au)" on port 4041
scp -P4041 vm.list "root@221.121.128.27:/mnt/xen-storage/"

if [ "$?" -eq "0" ]; then
	echo Success
else
	echo Failure
	exit 1
fi

#echo Running "scan.sh" on 221.121.128.27 "(virt-ftp-1-1.servercontrol.com.au)" and saving output to scan.csv

#ssh -p4041 "root@221.121.128.27" "/bin/sh /mnt/xen-storage/scan.sh"

#if [ "$?" -eq "0" ]; then
#        echo Success
#else
#        echo Failure
#        exit 1
#fi

#echo Copying scan.csv to current local directory
#scp -P4041 "root@221.121.128.27:/mnt/xen-storage/scan.csv" .
#
#if [ "$?" -eq "0" ]; then
#        echo Success
#else
#        echo Failure
#        exit 1
#fi
