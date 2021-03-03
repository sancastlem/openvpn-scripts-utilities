#!/bin/bash
# GLOBAL
INSTANCE='remote-instance-name'
HOME='/remote/path/to/folder/script'

# Print user and email inserted
echo "Usuario: " $USER
echo "Email: " $EMAIL

# Check if the password contains any special characters. If not, then call the main script that generate the certificates
# This check is important because bash doesn't interpreted correctly special characters in string, that interpreted like commands
if [[ $PASSWORD == *['!'@#\$%^\&*()_+]* ]];then

        echo "ERROR. This password must be containt only alphanumerics characters."
        exit 0

else
		
        ssh -o StrictHostKeyChecking=no $INSTANCE bash $HOME/add-user-vpn.sh $USER $EMAIL $PASSWORD

fi