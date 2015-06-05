#!/bin/bash -x

SED=$(which sed);

#
# This is an example of reset password hook in Jelastic
#

#$J_OPENSHIFT_APP_ADM_USER        ;   Operate this variable for the username
#$J_OPENSHIFT_APP_ADM_PASSWORD    ;   Use this varible for your password
J_OPENSHIFT_APP_ADM_USER="root";

function _setPassword() {
    ORIENTDB_SERVER_PROP_FILE="${OPENSHIFT_ORIENTDB_DIR}/versions/2/config/orientdb-server-config.xml";
    service cartridge stop >> /dev/null 2>&1; 
    sed -i '/<user name=\"root\".*password=/d' $ORIENTDB_SERVER_PROP_FILE;
    sed -i '/<user name=\"guest\".*password=/d' $ORIENTDB_SERVER_PROP_FILE;
    sed -i "/<users>/a <user name=\"guest\" password=\"$J_OPENSHIFT_APP_ADM_PASSWORD\" resources=\"connect,server.listDatabases,server.dblist\"\/>" $ORIENTDB_SERVER_PROP_FILE;
    sed -i "/<users>/a <user name=\"root\" password=\"$J_OPENSHIFT_APP_ADM_PASSWORD\" resources=\"*\"\/>" $ORIENTDB_SERVER_PROP_FILE;
    service cartridge start >> /dev/null 2>&1; 
}




