# !/bin/bash
echo
echo "    ____             __           "
echo "   / __ \___  ____  / /___  __  __"
echo "  / / / / _ \/ __ \/ / __ \/ / / /"
echo " / /_/ /  __/ /_/ / / /_/ / /_/ / "
echo "/_____/\___/ .___/_/\____/\__, /  "
echo "          /_/            /____/   "
echo
echo "Hello, "$USER"! Let's deploy ROKU!"
echo

DEFAULT_IP="roku-reverse1.duckdns.org"
OUTPUT_DIR=cicd/out
DEVPASSWORD=Sike1234
PKGPASSWORD=DudeMaster2000-9J--------n==
APPVERSION=`head ./robinhood/app_version.txt`
ZIPREL=cicd/out

 ls -l


if [ ! -d "$OUTPUT_DIR" ]; then
	echo "ERROR: $OUTPUT_DIR doesn't exist"
	exit 1
fi

echo -n "API ENVIRONMENT:"
echo
echo "- staging"
echo "- preprod"
echo "* production (default)"
read environment
echo

echo -n "IP TO DEPLOY:"
echo
echo "* local $DEFAULT_IP (default)"
echo "- other (type your own)"
read IP
echo

echo -n "PHOENIX ENVIRONMENT:"
echo
echo "- staging"
echo "- preprod"
echo "* production (default)"
read phx_env
echo

if [[ "$phx_env" == "" ]]; then
	phx_env="production"
fi

if [ "$phx_env" != 'staging' ] && [ "$phx_env" != 'preprod' ] && [ "$phx_env" != 'production' ]; then
	phx_env="staging"
fi

if [[ "$environment" == "" ]]; then
	environment="production"
fi

if [[ "$app_to_launch" == "" ]]; then
	app_to_launch="1.0"
fi

if [[ "$IP" == "" ]]; then
	IP="$DEFAULT_IP"
fi

echo "> WILL LAUNCH: $app_to_launch"
echo "> DEPLOYING TO: $IP"
echo "> PHX ENV: $phx_env"
echo "> API ENV: $environment"

echo "  > INVALIDATING MOCKED FILES"
sed -e 's/REPLACE_MOCK/invalid/g' brightscript/tpl_mocked_channels > brightscript/components/legacy_app/mockedChannels.brs
sed -e 's/REPLACE_MOCK/invalid/g' brightscript/tpl_mocked_vod > brightscript/components/legacy_app/mockedVod.brs
python mocking.py clear

echo
echo "    ____             __               _            "
echo "   / __ \____ ______/ /______ _____ _(_)___  ____ _"
echo "  / /_/ / __ \`/ ___/ //_/ __ \`/ __ \`/ / __ \/ __ \`/"
echo " / ____/ /_/ / /__/ ,< / /_/ / /_/ / / / / / /_/ / "
echo "/_/    \__,_/\___/_/|_|\__,_/\__, /_/_/ /_/\__, /  "
echo "                            /____/        /____/   "
echo

function package_roku {

	local build_file=./build_number.txt
	local previous_zip=./cicd/out/robin-roku.zip
	if [ -f "$previous_zip" ]; then
		rm $previous_zip
	fi

	GITBRANCH=`git branch | grep \* | cut -d ' ' -f2 | tr / _`
	GITCOMMIT=`git rev-parse --short HEAD`

	cd ROBINHOOD/ && \
		export ROKU_DEV_TARGET=$IP && \
		make ROBIN_ENV=$environment \
			ROBIN_MOCK=false \
			ROBIN_STAGE=gold \
			ROBIN_PROFILE=0 \
			ROBIN_GITCOMMIT=$GITCOMMIT \
			ROBIN_LAUNCH_APP=$app_to_launch \
			ROBIN_UNITTESTING=false \
			PHX_ENV=$phx_env \
			ROBIN_REGION=$1 \
			install && \
		cd ..

	BUILD_NUMBER_LOCAL=`cat $build_file`
	echo "$(($BUILD_NUMBER_LOCAL - 1))" > $build_file
	APPVERSION=`head ./app_version.txt`

	curl -d '' "http://${IP}:8060/keypress/Home"

	APPNAME="Robin-$APPVERSION-phx_$phx_env-api_$environment-$1-gitbranch_$GITBRANCH-commit_$GITCOMMIT"
	USERPASS=rokudev:${DEVPASSWORD}

	echo
	echo "Packaging for $1 @ $APPVERSION ...."
	echo

	curl \
		--user ${USERPASS} \
		--digest -s -S -0 \
		-F "app_name=${APPNAME}" \
		-F "passwd=${PKGPASSWORD}" \
		-F "mysubmit=Package" \
		-F "pkg_time=`date +%s%M`" http://${IP}/plugin_package > /dev/null;

	curl --user ${USERPASS} \
		--digest -S -0 "http://${IP}/plugin_package" > /tmp/package.tmp

	sleep 1

	PKGNAME=`grep -o "pkgs//\w*.pkg" /tmp/package.tmp`
	PKGLOCATION=http://${IP}/${PKGNAME}

	wget --user="rokudev" \
		--password="$DEVPASSWORD" \
		-O "$OUTPUT_DIR/$APPNAME.pkg" $PKGLOCATION

	cp "$ZIPREL/robin-roku.zip" "$OUTPUT_DIR/$APPNAME.zip"
}

package_roku "US"
sleep 5
package_roku "EU"
