#!/usr/bin/env bash

CWD=$(pwd)

BIN_PATH=$(readlink -f $1)
BIN=$(echo $BIN_PATH | awk -F/ '{print $NF}')
VERSION=$2
APP=$3
LANG=$4
DEPEND=""

if [ $LANG = "golang" ] || [ $LANG = "java" ] || [ $LANG = "python" ]; then
  echo "Building deb package with ${LANG}"
else
  echo "This programming language isn't supported now"
  exit 1
fi

if [ $LANG = "java" ]; then
  DEPEND="default-jre"
fi

function cleanup() {
  rm -rf ${DIR}
}

trap cleanup EXIT

cd ${DIR}
mkdir -v -p control data/{etc/systemd/system,usr/share/app}
cp -r ${CWD}/* data/usr/share/app/

cat >data/usr/share/app/start.sh <<EOF
#!/usr/bin/env bash

set -e -x

function golang {
cd /usr/share/app/
/usr/share/app/$BIN
}

function java {
ENV=\$(aws ec2 describe-tags --filters "Name=resource-id,Values=\$(curl -s http://169.254.169.254/latest/meta-data/instance-id)" --region $(curl --silent http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region) --query "Tags[?Key=='aws:autoscaling:groupName'].Value" --output text | cut -f2 -d"-")

# Running app with appropriate profiling group name.
/usr/bin/java -javaagent:/usr/share/app/codeguru-profiler-java-agent-standalone-0.3.2.jar="profilingGroupName:${APP}-\${ENV}" -jar /usr/share/app/$BIN
}

function python {
  cd /usr/share/app/
  . ./scripts/get_environment.sh
  ./run.sh
}

lang=$4
if [ \$lang = "golang" ]; then
  golang
elif [ \$lang = "java" ]; then
  java
elif [ \$lang = "python" ]; then
  python
else
echo "This programming language isn't supported now"
fi
EOF

cat >data/etc/systemd/system/$APP.service <<EOF
[Unit]
Description=$APP
[Service]
ExecStart=/bin/bash /usr/share/app/start.sh
Type=simple
[Install]
WantedBy=multi-user.target
EOF

echo "/etc/systemd/system/$APP.service" >control/conffiles

cat >control/control <<EOF
Package: $APP
Version: ${VERSION}
Architecture: all
Maintainer: Oleh Palii <oleh_palii@epam.com>
Installed-Size: $(du -ks data/usr/share/app/$BIN | cut -f 1)
Depends: $DEPEND
Description: $APP
Section: devel
Priority: extra
EOF

cd data
md5sum usr/share/app/$BIN >../control/md5sums
cd -

if [ $LANG = "python" ]; then

cat >control/postinst <<EOF
#!/bin/sh
set -e
if [ "\$1" = "configure" ] || [ "\$1" = "abort-upgrade" ] || [ "\$1" = "abort-deconfigure" ] || [ "\$1" = "abort-remove" ] ; then

cd /usr/share/app
virtualenv -p /usr/bin/python3 venv
./venv/bin/python -m pip install --upgrade pip
./venv/bin/python -m pip install --no-cache-dir -r requirements.txt

systemctl --system daemon-reload
systemctl enable $APP
systemctl start $APP

fi

exit 0
EOF

else

cat >control/postinst <<EOF
#!/bin/sh

set -e

if [ "\$1" = "configure" ] || [ "\$1" = "abort-upgrade" ] || [ "\$1" = "abort-deconfigure" ] || [ "\$1" = "abort-remove" ] ; then

systemctl --system daemon-reload
systemctl enable $APP
systemctl start $APP

fi

exit 0
EOF

fi

cat >control/prerm <<EOF
#!/bin/sh
set -e
systemctl stop $APP || exit 1
EOF

cat >control/postrm <<EOF
#!/bin/sh
set -e
APP=$APP
if [ "\$1" = "purge" ] ; then
  systemctl disable $APP >/dev/null
fi
  systemctl --system daemon-reload >/dev/null || true
  systemctl reset-failed
exit 0
EOF

cd control
tar czf ../control.tar.gz .
cd -

cd data
tar czf ../data.tar.gz .
cd -

echo "2.0" >debian-binary

ar r ${CWD}/$APP.deb debian-binary control.tar.gz data.tar.gz

cd ${CWD}