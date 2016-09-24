#!/bin/bash

DEST=/opt
HOME=/opt
PWD=/opt

OVS_REPO=${OVS_REPO:-http://github.com/openvswitch/ovs.git}
OVS_REPO_NAME=$(basename ${OVS_REPO} | cut -f1 -d'.')

# The branch to use from $OVS_REPO
# TODO(gsagie) Currently take branch-2.5 branch as master is not stable
OVS_BRANCH=${OVS_BRANCH:-branch-2.5}


# OVS bridge definition
PUBLIC_BRIDGE=${PUBLIC_BRIDGE:-br-ex}
INTEGRATION_BRIDGE=${INTEGRATION_BRIDGE:-br-int}
INTEGRATION_PEER_PORT=${INTEGRATION_PEER_PORT:-patch-ex}
PUBLIC_PEER_PORT=${PUBLIC_PEER_PORT:-patch-int}

# OVS related pid files
#----------------------
OVS_DB_SERVICE="ovsdb-server"
OVS_VSWITCHD_SERVICE="ovs-vswitchd"
OVS_DIR="/var/run/openvswitch"
OVS_DB_PID=$OVS_DIR"/"$OVS_DB_SERVICE".pid"
OVS_VSWITCHD_PID=$OVS_DIR"/"$OVS_VSWITCHD_SERVICE".pid"
OVS_VSWITCH_OCSSCHEMA_FILE=${OVS_VSWITCH_OCSSCHEMA_FILE:-"/usr/share/openvswitch/vswitch.ovsschema"}

source ./function.sh
source ./ovs_setup.sh

install_ovs

init_ovs
