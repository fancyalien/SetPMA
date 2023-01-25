#! /bin/bash

RED='\033[31;5m'
NOCOLOR='\033[0m'
GREEN='\033[32;5m'
FF='\033[34;1m'

MGREEN=${GREEN}'\033[32;1m'
MRED=${RED}'\033[31;1m'
MFF=${FF}'\033[34;1m'
USER=$(whoami)

#Press [Enter] key to continue...

# shellcheck disable=SC2046
if [ $(systemctl is-active mysql) = 'inactive' ]; then
		echo -e "⚪️mysql and apache2 services are ${MRED}Not Alive! ${NOCOLOR} \n"
else
		echo -e "⚪️mysql and apache2 service are ${MGREEN}are Aive ${NOCOLOR} \n"
fi

# shellcheck disable=SC2046
if [ $(systemctl is-active mysql) = 'inactive' ]; then
		sudo service mysql start
		sudo service apache2 start
		if [ $(systemctl is-active mysql) = 'active' ]; then
			echo -e "⚪️mysql and apache2 services are ${MGREEN}started ${NOCOLOR}:by ${USER}\n"
			echo -e "⚪${MFF}️firefox has been ${MGREEN}started ${NOCOLOR} \n"
			firefox localhost/phpmyadmin/ 2>/dev/null
			# shellcheck disable=SC2162
			read -t 3
		fi	

else
		sudo systemctl stop mysql 
		sudo systemctl stop apache2
		echo -e "⚪️mysql and apache2 services are ${MRED}stop! ${NOCOLOR}:by ${USER} \n"
		# shellcheck disable=SC2162
		read -t 5
fi
