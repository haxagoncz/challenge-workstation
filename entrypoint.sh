#!/bin/bash

PASS=${PASSWORD:-password}
ENCRYPTED_PASSWORD=`openssl passwd -6 -salt jardajagr ${PASS}`
USER=${USERNAME:-student}
DEFAULT_SHELL=${SHELL:-/bin/bash}
ENTRYPOINT_REMOVE=${ENTRYPOINT_REMOVE:-true}
ENTRYPOINT_DEBUG=${ENTRYPOINT_DEBUG:-true}
ENTRYPOINT_SCENARIO_IS_READY=${ENTRYPOINT_SCENARIO_IS_READY:-true}
ENTRYPOINT_PATH=${ENTRYPOINT_PATH:-/tmp/entrypoint.sh}

if [ "${ENTRYPOINT_DEBUG}" == "true" ]; then
    set -x
fi

grep -q $USER /etc/passwd || useradd \
    --badnames\
    --create-home\
    --shell $DEFAULT_SHELL\
    --password $ENCRYPTED_PASSWORD\
    $USER

echo 'PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "' >> /home/$USER/.bashrc

if [ "${SUDO}" == "true" ]; then
    usermod -aG sudo $USER
fi

if [ "${ENABLE_SSH}" == "true" ]; then
    service ssh start
fi

[ -f $ENTRYPOINT_PATH ] && chmod +x $ENTRYPOINT_PATH && $ENTRYPOINT_PATH

if [ "${ENTRYPOINT_REMOVE}" == "true" ]; then
    rm $ENTRYPOINT_PATH
fi

if [ "${ENTRYPOINT_SCENARIO_IS_READY}" == "true" ]; then
    echo SCENARIO_IS_READY
fi

bash
sleep infinity
