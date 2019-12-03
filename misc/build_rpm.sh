#!/bin/bash

set -x

SPEC_BASE=$1

MACROS=components/OHPC_*

SPEC=$(find . -name ${SPEC_BASE})
SPEC_DIR=$(dirname ${SPEC})
rm -rf ~/rpmbuild/SOURCES/*
cp -p ${MACROS} ${SPEC_DIR}/../SOURCES/* ~/rpmbuild/SOURCES/
createrepo --update ~/rpmbuild/RPMS/x86_64
createrepo --update ~/rpmbuild/RPMS/noarch
# /etc/sudoers needs to be updated:
# - commnet out the line such as "# Defaults    always_set_home"
# - add SETENV to your user account such as "centos ALL=(ALL) NOPASSWD:SETENV: ALL"
sudo -E yum-builddep -y ${SPEC}
# use 'rm -rf ~/rpmbuild/SOURCES/*' instead of '--rmsource'
QA_RPATHS=$[ 0x0001|0x0002|0x0004|0x0020 ] rpmbuild -ba --define 'ohpc_version 1.3' ${SPEC}

