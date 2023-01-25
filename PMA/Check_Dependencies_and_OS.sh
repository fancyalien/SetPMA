#! /bin/bash

#colours
RED='\033[31;1m'
GREEN='\033[32;1m'
L_GREEN='\x1b[38;5;42m'
BLUE='\x1b[34;1m'
ORANGE='\033[33;1m'
PURPUEL='\033[35;1m'
NO_COLOR='\033[0m'

echo -e "\n ${L_GREEN}*********************************** Welcome ************************************${NO_COLOR} \n"

IS_THERE="${BLUE}Let's check if you have installed what script needs:${NO_COLOR}"

#os check loop
OS=( Kali Parrot Ubuntu )

#geting terminal output of distro
TERMINAL_OUTPUT=$(cat /etc/issue)

echo -e "${BLUE}Known compatible distros with this script:${NO_COLOR}
${PURPUEL}${OS[@]} ${NO_COLOR} \n "

#getOS
function getOS() {
  if [[ "${TERMINAL_OUTPUT}" == *"${OS}"* ]]; then
  	echo -e "Detecting system :${NO_COLOR} ${ORANGE}"$OS" linux${NO_COLOR} \n "
  else
    echo -e "This os is not support for the script"
    echo -e "Good bye!"
  fi
}
getOS

#check dependencies on mysql using dpkg
function checkDependencie_mysql() {
  echo -e "$IS_THERE \n"
  #STDOUT=1 & STDERROR=2
  if [ "$(dpkg-query -f='${Status:Want} ${Status}' -W "mariadb-server" 2>/dev/null)" ]; then
   		return 0
  else
   	 	return 1
  fi
}
#check dependencies on phpmyadmin using dpkg
function checkDependencie_phpmyadmin() {
    if [ "$(dpkg-query -f='${Status:Want} ${Status}' -W "phpmyadmin" 2>/dev/null)" ]; then
      return 0
    else
      return 1
    fi
}

#fix broken dependencies
function sayStatus() {
  checkDependencie_mysql
  local mysql_dependencies=$?
  checkDependencie_phpmyadmin
  local phpmyadmin_dependencies=$?

#mysql error handling
    if [ $mysql_dependencies == 0 ]; then
      echo -e "mariadb-server is ${GREEN}ok...${NO_COLOR}"
    else
      echo -e "mariadb-server is ${RED}not-installed...${NO_COLOR} \n"

      #install missing package for mysql
        ## Prompt the user
        read -p "Do you want to install missing libraries? [y/n]: " uInput
        ## Set the default value if no uInput was given
        uInput=${uInput:Y}
        ## If the uInput matches y or Y, install
        if [[ $uInput =~ [Yy] ]]; then
          sudo apt install mysql-server
        else
          echo "script close!"
        fi
      fi
      #phpmyadmin error handling
      if [ $phpmyadmin_dependencies == 0 ]; then
                echo -e "phpmyadmin is ${GREEN}ok...${NO_COLOR}"
            else
                echo -e "phpmyadmin is ${RED}not-installed...${NO_COLOR} \n "
                #install missing package for phpmyadmin
                ## Prompt the user
                read -p "Do you want to install missing libraries? [y/n]: " uInput
                uInput=${uInput:Y}
                if [[ $uInput =~ [Yy] ]]; then
                  sudo apt install -y phpmyadmin php-mbstring php-zip php-gd php-json php-curl
                else
                  echo "script close"
                fi
            fi

#set the return
if [ $[$phpmyadmin_dependencies | $mysql_dependencies] == 0 ]; then
  return 0
else
  return 1
fi
}

sayStatus
