# OpenVPN Utilities
Bash scripts utilities and examples configs files to manage OpenVPN Server.

## Use

### Examples Configs

In the folder **configs** you'll see two confs files, like an example to setup an OpenVPN Server like an OpenVPN Client.

**Server config** example is related to setup a server with:

 - Allow only bussiness access through VPN and the rest of the traffic is passing through the local LAN (your LAN home, for example).
 - Validate connection only for certainly users, with the directive **tls-verify**. An example case of use is, if you have another VPN Server, and you want to connect to it only certainly users (or only the users you'll have added in these instance), then use this directive. This directive need a script in format **/bin/sh**, that do this check. This script is allocated in the folder **scripts**, with the name **cn_verify.sh**.
 - Validate revokes users with the directive **crl-verify**. When you revokes a client certificate, OpenVPN needs this file to know which certificates are revoked.

**Client config** example is valid for any client in Linux, Windows or MacOS and the server example config before. Also, you need to insert the CA, Client Cert and Key and TA content in the .ovpn resultant.

### Manage Users

For this, we use scripts that allocated in the folder **init-scripts** and **scripts**. This scripts are use to add new users (and send a mail with its .ovpn file and password) and revoke users.

#### Add Users

- **vpn-add-user.sh**: init script that call **add-user-vpn.sh**. This script is inserted like command bash in a Jenkins job, where previously, check the password for if any user that inserted any special character, if not launch the next script. Also you need create vars USER, EMAIL and PASSWORD.
- **add-user-vpn.sh**: script that generate the certificate  and .ovpn file and call the script **send-email.sh**.
- **send-email.sh**: script that send a mail with the .ovpn generated previosly and password, using the command **mutt**. To setup correctly mutt, see the content from *.muttrc*. This file must be saved in the home users.

#### Revoke Users

- **vpn-revoke-user.sh**: init script that call **revoke-user-vpn.sh**. Like vpn-add-user.sh, this script is inserted like command bash in a Jenkins job. Also, you need create the var USER.
- **revoke-user-vpn.sh**: script that revokes the certificate from the user inserted in the before script and generate crl file.

#### Auxiliars scripts

- **restart-openvpn.sh**: cron script that need an auxiliar file that indicate if launch or not (with 0 or 1). This script copy the crl file generate in the revoke process and restart the openvpn service server.
- **update_active_users.sh**: cron script that need an auxiliar file that indicate if launch or not (with 0 or 1). This script copy validated users in the pki index to an another file allocated in /etc/openvpn. It's not necessary restart the OpenVPN Server to apply this update. This script is prepared to launch when a new user is added or revoked.

*Note: Both script must be necessary to declare like a crontab task.*

### Linux Client

Script that use to connect to the VPN Server in Linux Systems.

*Note: In all scripts (except cn_verify.sh), you need to change some variables commented (paths, name for the VPN user Server, mail from and subject...) every is commented in the same scripts.*
