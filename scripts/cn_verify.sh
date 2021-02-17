#!/bin/sh
######################## [ INSTRUCTIONS ] ########################
# Before you need to insert the option tls-verify in your 
# server.conf file. To call the script, write 
# cn_verify.sh </etc/openvpn/<file-with-active-users.txt> $2 $3
######################### [ ARGUMENTS ] ##########################
# $1 -> Active users list. Must be in /etc/openvpn folder.
# $2 -> certificate_depth. Value 0 if is server, 1 if is client. 
# This argument's insert automatically.
# $3 -> Client CN or common-name. This argument's insert 
# automatically.
##################################################################

# Check if we're insert every arguments. Show error if not.
[ $# -eq 3 ] || { echo "ERROR: Fault any argument." ; exit 255 ; }

# Check if client CN is valid. If not, show error
if [ $2 -eq 0 ] ; then

	grep -R $3 $1 && exit 0
        exit 1

fi

exit 0
