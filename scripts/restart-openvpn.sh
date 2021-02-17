#!/bin/bash
## VARS
REBOOT="/path/to/reboot_service_vpn"
CRL_SOURCE="/path/to/source/crl.pem"
CRL_TO="/path/to/destiny/crl.pem"

## MAIN
if [[ `cat $REBOOT` -eq 1 ]];then

	cp $CRL_SOURCE $CRL_TO
	sleep 2
	systemctl restart openvpn@server
	echo 0 > $REBOOT

fi
