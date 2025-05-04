#!/bin/bash
# Author  : Gaston Gonzalez
# Date    : 8 November 2024
# Updated : 26 March 2025
# Purpose : Install Linbpq
#
# Notes:
# These build steps are partially based on an article by the Modern Ham (KN4MKB).
# https://themodernham.com/install-linbpq-bbs-packet-node-on-debian-ubuntu-and-raspbian/

VERSION=latest
FILE=linbpq
LINK_PATH=/opt/linbpq
INSTALL_DIR=/opt/linbpq-${VERSION}
INSTALL_BIN_DIR=${INSTALL_DIR}/bin

et-log "Installing Dan Bernstein's tcpserver..."
apt install ucspi-tcp -y

et-log "Installing Linbpq..."

# Install the web interface for LinBPQ
HTML_ZIP_FILE=HTMLPages.zip
HTML_ZIP_URL="http://www.cantab.net/users/john.wiseman/Downloads/Beta/${HTML_ZIP_FILE}"
BBS_HOME="/etc/skel/.local/share/emcomm-tools/bbs-server"
BBS_HOME_FILES="${BBS_HOME}/Files"

et-log "Downloading web interface for LinBPQ from ${HTML_ZIP_URL}"
curl -s -f -L -o ${HTML_ZIP_FILE} ${HTML_ZIP_URL}

if [[ $? -eq 0 ]]; then

   CWD_DIR=$(pwd)

   et-log "Installing web interface under ${BBS_HOME}"

   [[ ! -e ${BBS_HOME_FILES} ]] && mkdir -p ${BBS_HOME_FILES}
   mv ${HTML_ZIP_FILE} ${BBS_HOME} && cd ${BBS_HOME} && unzip ${HTML_ZIP_FILE}

   cd ${CWD_DIR}

   if [[ -e "${BBS_HOME}/index.htmlx" ]]; then
     et-log "Web interface installation successful"
   else
     et-log "Web interface installation failed"
   fi
else
   et-log "Unable install web interface for LinBPQ"
fi

# Install Linbpq
et-log "Installing 32-bit dependencies for Linbpq..."
dpkg --add-architecture i386 &&  apt update && apt install \
  libpcap0.8-dev:i386 \
  libasound2-dev:i386 \
  libz3-4:i386 \
  zlib1g:i386 \
  -y

URL="https://www.cantab.net/users/john.wiseman/Downloads/${FILE}"

if [ ! -e ${FILE} ]; then
  et-log "Downloading Linbpq: ${URL}"
  curl -s -L -o ${FILE} --fail ${URL}
fi

[ ! -e ${INSTALL_BIN_DIR} ] && mkdir -v -p ${INSTALL_BIN_DIR}
chmod 755 ${FILE} && mv -v ${FILE} ${INSTALL_BIN_DIR}

CWD_DIR=$(pwd)

[ -e ${LINK_PATH} ] && rm ${LINK_PATH}
ln -s ${INSTALL_DIR} ${LINK_PATH}

stow -v -d /opt linbpq -t /usr/local

cd ${CWD_DIR}

