#!/usr/bin/make -f

SHELL = /bin/bash
export ROOT=${PWD}
export INDEX=${ROOT}/index
export DOWNLOAD_SCRIPT=${ROOT}/download.sh

all: html4cd

html4cd: clean-html4cd
	cp -r ${ROOT}/scripts/html4cd/template ${ROOT}/cdrom
	${ROOT}/scripts/html4cd/html4cd.pl "${ROOT}/applications" "${ROOT}/cdrom"

download-script:
	${ROOT}/scripts/gen_download_script.pl "${ROOT}/applications" "${DOWNLOAD_SCRIPT}"
	chmod +x ${DOWNLOAD_SCRIPT}

clean: clean-html4cd

clean-html4cd:
	rm -rf ${ROOT}/cdrom
