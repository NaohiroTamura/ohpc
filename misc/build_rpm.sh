#!/bin/bash

set -x

SPEC_BASE=$1

MACROS=components/OHPC_macros

SPEC=$(find . -name ${SPEC_BASE})
SPEC_DIR=$(dirname ${SPEC})
rm -rf ~/rpmbuild/SOURCES/*
cp -p ${MACROS} ${SPEC_DIR}/../SOURCES/* ~/rpmbuild/SOURCES/
createrepo --update ~/rpmbuild/RPMS
if [ -e /usr/bin/dnf ]
then
    dnf clean expire-cache
    dnf builddep -y --enablerepo=PowerTools ${SPEC}
else
    # zypper refresh # commented out since autorefresh=1 in /etc/zypp/repos.d/ohpc-local.repo
    rpmspec --parse --define 'ohpc_version 2.0' "${@:2}" ${SPEC} | \
        grep BuildRequires | sed -e 's/^BuildRequires://' -e 's/,/ /g' | xargs zypper install -y
fi

# QA_RPATHS=$[ 0x0001|0x0002|0x0004|0x0020 ]
# used 'rm -rf ~/rpmbuild/SOURCES/*' instead of '--rmsource'
rpmbuild -ba --define 'ohpc_version 2.0' "${@:2}" ${SPEC}

