# !/bin/bash
# CSI Installation – Main Program
# Version : December 25, 2023
# Author : mariefdu45@gmail.com
#
source govc.env
source variables.env

if [[ $1 == "install" ]]
then
    source ./configuration/csi_user_configuration
    source ./configuration/cpi_configuration
    source ./configuration/csi_configuration
elif [[ $1 == "uninstall" ]] 
then
    source ./configuration/csi_removing
    source ./configuration/cpi_removing
	source ./configuration/csi_user_removing
else
    echo "Error. Usage: main.sh install|uninstall"
fi
