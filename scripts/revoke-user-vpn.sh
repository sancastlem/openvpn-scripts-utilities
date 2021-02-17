#!/bin/bash
## VARS
USER=$1
RSA="/path/to/EasyRSA" ## Path to EasyRSA folder
USERVPNSERVER="cn-vpnserver" ## CN VPN Server
USERS=(`grep -v '$USERVPNSERVER\|R' $RSA/pki/index.txt | awk '{print $5}'`) ## List valids CNs
FLAG=0 ## Flag for if user exists or not

## CHECKS
# if user is empty, print error
if [[ $USER == "" ]];then

	echo "ERROR. Insert the name of the user that you want to revoke."
	exit 0
fi

# Revoke if users exists, if not show error
for i in ${USERS[*]};
do

    if [[ $i == '/CN='$USER ]];then

		echo "User to revoke: " $USER

		# Revocamos el certificado del usuario
		cd $RSA
		./easyrsa --batch revoke $USER
		echo -e "Certificate revoked.\n"

		# Update CRL file
		./easyrsa gen-crl
		echo -e "CRL generated.\n"

		# Delete ovpn file
		rm -rf ~/openvpn-clients/$USER.ovpn
		echo -e "OVPN file deleted. User revoked correctly.\n"

		# Active and revoke users list
		echo -e "Active and revoke users list:\n"
		cat pki/index.txt

		# Create reboot_service_vpn with value 1
		echo -e 1 > pki/reboot_service_vpn

		# Create update_active_users with value 1 for upgrade active users list saved in /etc/openvpn
		echo -e 1 > pki/update_active_users
		exit 0

	else

		FLAG=1

	fi

done

if [[ $FLAG -eq 1 ]];then

	echo "ERROR. The user not exists."
	exit 0

fi
