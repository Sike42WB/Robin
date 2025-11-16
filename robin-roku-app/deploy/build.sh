#!/bin/bash
echo " >>> DEPLOYMENT SCRIPT STARTING... <<<"

ls
DEFAULT_IP="roku-reverse1.duckdns.org"
APPVERSION=`head ./ROBINHOOD/app_version.txt`
JENKINSPIPELINE = "673"

ls
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
LIST= $DIR
file=$DIR

if [[ $file == *673* ]];
then
    echo "Jenkins pipeline found!"
	cd ..
else
    echo "reg. dev env."
fi

echo -n "ENVIRONMENT:"
echo
echo "- staging"
echo "- preprod"
echo "* production (default)"
read environment
echo

echo -n "Enable Unit Testing?"
echo
echo "* false (default)"
echo "- true"
read enableUnitTesting
echo

echo -n "IP TO DEPLOY:"
echo
echo "* local $DEFAULT_IP (default)"
echo "- other (type your own)"
read IP
echo

if [[ "$environment" == "" ]]; then
	environment="production"
fi

if [[ "$enableUnitTesting" == "" ]]; then
	enableUnitTesting="false"
fi

if [[ "$app_to_launch" == "" ]]; then
	app_to_launch="5.0"
fi

if [[ "$IP" == "" ]]; then
	IP="$DEFAULT_IP"
fi

GITBRANCH=`git branch | grep \* | cut -d ' ' -f2 | tr / _`
GITCOMMIT=`git rev-parse --short HEAD`

echo "> WILL LAUNCH: $app_to_launch"
echo "> DEPLOYING TO: $IP"
echo "> API ENV: $environment"
echo "> GIT BRANCH: $GITBRANCH"
echo "> GIT COMMIT: $GITCOMMIT"
echo "> PHOENIX ENV: staging"
echo "> REGION: US"

ls

if [[ $file == *673* ]];
then
    echo "Jenkins pipeline found!"
	cd ..
else
    echo "reg. dev env."
fi

ls 

cd ROBINHOOD/ && \
	export ROKU_DEV_TARGET=$IP && \
	make ROBIN_ENV=$environment \
		ROBIN_MOCK=false \
		ROBIN_STAGE=gold \
		ROBIN_PROFILE=0 \
		ROBIN_GITCOMMIT=$GITCOMMIT \
		ROBIN_LAUNCH_APP=$app_to_launch \
		PHX_ENV=staging \
		ROBIN_REGION=US \
		ROBIN_UNITTESTING=$enableUnitTesting \
	install && cd ..

echo
echo ">>> DEPLOYMENT COMPLETE! <<<"
echo

# nc $IP 8085
