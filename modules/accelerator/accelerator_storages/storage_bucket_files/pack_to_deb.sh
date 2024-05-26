#!/usr/bin/env bash

# Initializing Variables
CWD=$(pwd)
BIN_PATH=$(readlink -f $1)
BIN=$(echo $BIN_PATH | awk -F/ '{print $NF}')
VERSION=$2
APP=$3
LANGUAGE=$4
APP_PATH="/opt/$APP"
DEPEND=""

# Validating language support
if [ $LANGUAGE = "golang" ] || [ $LANGUAGE = "java" ] || [ $LANGUAGE = "python" ]; then
  echo "Building deb package with ${LANGUAGE}"
else
  echo "This programming language isn't supported now"
  exit 1
fi

# Setting dependency for Java
if [ $LANGUAGE = "java" ]; then
  DEPEND="default-jre"
fi

# Cleanup function to delete directory
function cleanup() {
  rm -rf ${DIR}
}

# Set trap for cleanup
trap cleanup EXIT

cd ${DIR}
mkdir -v -p control data/{etc/systemd/system,$APP_PATH/bin}
cp -r ${CWD}/* data/$APP_PATH/

# Generating start.sh script based on the given programming language
case "$LANGUAGE" in
    golang)
        cat >data/$APP_PATH/start.sh <<EOF
#!/bin/bash
cd $APP_PATH/
find ./ -maxdepth 1 -type f -name "*.yml" -delete
. ./scripts/get_environment.sh
./$BIN
EOF
    ;;

    java)
        cat >data/$APP_PATH/start.sh <<EOF
#!/bin/bash
cd $APP_PATH/
find ./ -maxdepth 1 -type f -name "*.yml" -delete
. ./scripts/get_environment.sh
/usr/bin/java -jar $BIN
EOF
    ;;

    python)
        cat >data/$APP_PATH/start.sh <<EOF
#!/bin/bash
cd $APP_PATH/
find ./ -maxdepth 1 -type f -name "*.yml" -delete
. ./scripts/get_environment.sh
./run.sh
EOF
    ;;

    *)
echo "This programming language isn't supported now"
exit 1
    ;;
esac

cat >data/etc/systemd/system/$APP.service <<EOF
[Unit]
Description=$APP
[Service]
ExecStart=/bin/bash /$APP_PATH/start.sh
Type=simple
[Install]
WantedBy=multi-user.target
EOF

echo "/etc/systemd/system/$APP.service" >control/conffiles

cat >control/control <<EOF
Package: $APP
Version: ${VERSION}
Architecture: all
Maintainer: EPAM Team <auto_epmc-acm_iac@epam.com>
Installed-Size: $(du -ks data/$APP_PATH/$BIN | cut -f 1)
Depends: $DEPEND
Description: $APP
Section: devel
Priority: extra
EOF

cd data
md5sum $APP_PATH/$BIN >../control/md5sums
cd -

if [ $LANGUAGE = "python" ]; then
    cat >control/postinst <<EOF
#!/bin/sh
set -e
if [ "\$1" = "configure" ] || [ "\$1" = "abort-upgrade" ] || [ "\$1" = "abort-deconfigure" ] || [ "\$1" = "abort-remove" ] ; then
cd $APP_PATH
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
systemctl disable $APP -q
fi
systemctl --system daemon-reload -q || true
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
