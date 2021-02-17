#!/bin/bash
## VARS
UPDATE="/path/to/update_active_users"
INDEX="/path/to/users-index-pki.txt"
ACTIVE_USERS_LIST="/etc/openvpn/active_users.txt"
VPNSERVER="vpnserver"

## MAIN
if [[ `cat $UPDATE` -eq 1 ]];then

	grep -R V $INDEX | grep -v $VPNSERVER | awk '{print $5}' > $ACTIVE_USERS_LIST
	echo 0 > $UPDATE

fi
