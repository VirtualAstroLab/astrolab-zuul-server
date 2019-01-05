#!/usr/bin/env bash
#
# publish-server-mvn.sh - Build and push the docker image to dockerhub.
#
# Author: 	Rodrigo Alvares de Souza (rsouza01@gmail.com)
#
#
# IMPORTANT:
# Do not forget to enable docker
# Either by 
# *	adding your user to docker group or 
# * by running 'sudo chmod 777 /var/run/docker.sock'
#
# History:
# Version 0.1: 2019/01/03 (rsouza) - First version
#


_HEADER="========================================================================"
_USE_MESSAGE="
Usage: $(basename "$0") [OPTIONS]
OPTIONS:
  -h, --help            Show this help screen and exits.
  -V, --version         Show program version and exits.
"
_VERSION=$(grep '^# Version ' "$0" | tail -1 | cut -d : -f 1 | tr -d \#)

clear
echo $_HEADER
echo -n $(basename "$0")
echo " ${_VERSION}"
echo $_HEADER

#Command line arguments
case $1 in

		-h | --help)
			echo "$_USE_MESSAGE"
			exit 0
		;;

		-V | --version)
			echo -n $(basename "$0")
            echo " ${_VERSION}"
			exit 0
		;;
esac


MVN='/home/rsouza/Ontwikkeling/apache-maven-3.5.4/bin/mvn'
MAVEN_FLAGS='-f ../../../pom.xml -DskipTests'
MAVEN="$MVN $MAVEN_FLAGS"

echo "[INFO] ------------------------------------------------------------------------"
echo "[INFO] Importing settings."
echo "[INFO] ------------------------------------------------------------------------"

source ./publish-server-settings.sh

echo "[INFO] ------------------------------------------------------------------------"
echo "[INFO] Running maven for $SERVER_NAME."
echo "[INFO] ------------------------------------------------------------------------"

$MAVEN clean package

if [ $? -ne 0 ]; then
	echo "[ERROR] ------------------------------------------------------------------------"
	echo "[ERROR] Error running '$MAVEN clean package'."
	echo "[ERROR] ------------------------------------------------------------------------"
	exit -1
fi


echo "[INFO] ------------------------------------------------------------------------"
echo "[INFO] Dockerizing $ORG_NAME/$SERVER_NAME:$IMG_TAG."
echo "[INFO] ------------------------------------------------------------------------"

$MAVEN docker:build -e

if [ $? -ne 0 ]; then
	echo "[ERROR] ------------------------------------------------------------------------"
	echo "[ERROR] Error running '$MAVEN docker:build -e'."
	echo "[ERROR] ------------------------------------------------------------------------"
	exit -1
fi

echo "[INFO] ------------------------------------------------------------------------"
echo "[INFO] Sending $ORG_NAME/$SERVER_NAME:$IMG_TAG to Docker Hub"
echo "[INFO] ------------------------------------------------------------------------"

$MAVEN docker:push

if [ $? -ne 0 ]; then
	echo "[ERROR] ------------------------------------------------------------------------"
	echo "[ERROR] Error running '$MAVEN docker:push'."
	echo "[ERROR] ------------------------------------------------------------------------"
	exit -1
fi

echo "[INFO] ------------------------------------------------------------------------"
echo "[INFO] Done!"
echo "[INFO] ------------------------------------------------------------------------"
