#!/bin/bash

function check() {
  #get return on Check_dependencies_and_os
  ./Check_Dependencies_and_OS.sh
  #set to CDAO
  local CDAO=$?
    if [  "${CDAO}" == 0 ]; then
      echo -e "\n"
        ./PMA.sh
      return 0
    else
      return 1
    fi
}
check
