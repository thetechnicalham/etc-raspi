#!/bin/bash
# Author  : Gaston Gonzalez
# Date    : 28 February 2025
# Purpose : Install pup (HTML processing)
# Updated by: Anthony Woodward
# Updated Date: 4 May 2025

VERSION="0.4.0"
ZIP_FILE="pup_v${VERSION}_linux_arm64.zip"
INSTALL_DIR="/opt/pup-${VERSION}"
INSTALL_DIR_BIN="${INSTALL_DIR}/bin"
LINK_PATH="/opt/pup"

et-log "Installing pup (HTML processing tool)..."

URL="https://github.com/ericchiang/pup/releases/download/v${VERSION}/${ZIP_FILE}"

et-log "Downloading pup: ${URL}"
curl -s -f -L -o ${ZIP_FILE} ${URL}

[[ $? -ne 0 ]] && et-log "Error fetching pup" && exit 1 

[ ! -e $ET_DIST_DIR ] && mkdir -v $ET_DIST_DIR

mv -v ${ZIP_FILE} ${ET_DIST_DIR}

CWD_DIR=$(pwd)

if [[ ! -e "${INSTALL_DIR}" ]]; then
  mkdir -v -p ${INSTALL_DIR_BIN} && cd ${INSTALL_DIR_BIN}
  unzip ${ET_DIST_DIR}/${ZIP_FILE}
else
  et-log "${INSTALL_DIR} already exists."
fi

chmod 755 ${INSTALL_DIR_BIN}/pup

[[ -e ${LINK_PATH} ]] && rm ${LINK_PATH}
ln -s ${INSTALL_DIR} ${LINK_PATH}

stow -v -d /opt pup -t /usr/local

cd ${CWD_DIR}
