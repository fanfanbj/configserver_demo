#!/bin/bash

#---------------------------------------------------------
# check environment parameter: config_uri and config_file
#---------------------------------------------------------
if [ ! $config_uri ] || [ ! $config_file ]; then 
	echo "no env for config_uri and config_file, please docker run to set those parameters";
	exist 1; 
fi

#---------------------------------------------------------
# download property file to local
#---------------------------------------------------------
curl $config_uri > $config_file

