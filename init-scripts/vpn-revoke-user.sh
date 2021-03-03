#!/bin/bash
# GLOBAL
INSTANCE='remote-instance-name'
HOME='/remote/path/to/folder/script'

## MAIN
# Call the main script that revokes certificates
ssh -o StrictHostKeyChecking=no $INSTANCE bash $HOME/revoke-user-vpn.sh $USER