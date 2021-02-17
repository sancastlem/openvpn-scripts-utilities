#!/bin/bash
## GLOBAL
USER=$1
EMAIL=$2
PASSWORD=$3
RSA="/path/to/EasyRSA"  ## Path to folder EasyRSA
VPNCLIENTS="/path/to/openvpn-clients" ## Path to folder where we save .ovpn files
USERVPNSERVER="cn-vpnserver" ## CN VPN Server
USERS=(`grep -v '$USERVPNSERVER\|R' $RSA/pki/index.txt | awk '{print $5}'`) ## List valids CNs

## CHECKS
# If password field is empty, then generate a new random password 
if [[ $PASSWORD == '' ]];then

        PASSWORD=`pwgen 16`

fi

# If field user or email is empty, show error
if [[ $USER == "" ]] || [[ $EMAIL == "" ]];then

	echo "ERROR. Field user or email is empty."
	exit 0

fi

# Check actually valid users. If exist, then show error
for i in ${USERS[*]};
do

	if [[ $i == '/CN='$USER ]];then

		echo "ERROR. This user is registered. If you've lost the config, revoke and generate it again."
		exit 0

	fi
done

# If everything is OK, then register it
# Generate user certificates
cd $RSA
./easyrsa --batch --passout=pass:$PASSWORD --req-cn=$USER gen-req $USER
echo -e "Certificate generated.\n"

(echo "yes") | ./easyrsa sign-req client $USER
echo -e "Certificate signed.\n"

# Build .ovpn file
cat $VPNCLIENTS/base.conf \
<(echo -e '<ca>') $RSA/pki/ca.crt <(echo -e '</ca>\n') \
<(echo -e '<cert>') $RSA/pki/issued/$USER.crt <(echo -e '</cert>\n') \
<(echo -e '<key>') $RSA/pki/private/$USER.key <(echo -e '</key>\n') \
<(echo -e '<tls-auth>') $RSA/ta.key <(echo -e '</tls-auth>') \
>> $VPNCLIENTS/$USER.ovpn
echo -e "OVPN file generated.\n"

# Send email with .ovpn file and password
bash email/send-email.sh $USER $EMAIL $PASSWORD
echo -e "Sent email.\n"

# List valid and revoked users
echo -e "Revoke and active user list:\n"
cat $RSA/pki/index.txt

# Create file update_active_users with value 1 to upgrade active users list
echo -e 1 > pki/update_active_users
exit 0