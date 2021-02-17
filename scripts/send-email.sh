#!/bin/bash
## VARS
USER=$1
MAILTO=$2
PASSWORD=$3
MAILFROM="admin@example.com" ## Mail from
SUBJECT="Your subject" ## Subject
FILE="/path/to/openvpn-clients/$USER.ovpn" ## Path OVPN file
TEMPLATE="/path/to/email/template.html" ## Template mail

## SEND MAIL
# Import the password in the template
sed -i 's/$PASSWORD/'$PASSWORD'/g' $TEMPLATE

# Send email
cat $TEMPLATE | mutt -e "set content_type=text/html" -a $FILE -s "$SUBJECT" -- $MAILTO

# Template rollback
sed -i 's/'$PASSWORD'/$PASSWORD/g' $TEMPLATE
