#!/bin/bash
source ~/SURV_env
#ORACLE SecureWallet Creation - Required $ORACLE_HOME env
#wallet secureStore location  - $ORACLE_HOME/oracle_common/bin/mkstore

# ARG_LIST for secureWalletCreationSSO
ORACLE_WALLET_LOCATION=$1
ORACLE_SQLNET_FILE_LOCATION=$2
ORACLE_WALLET_NAME=$3
TNSPING_DATA=cat tnsping $USER
#TNSNAMES_ORA_FILE=$ORACLE_HOME/network/admin/tnsnames.ora
DB_IP=cat $ORACLE_HOME/network/admin/tnsnames.ora | grep "HOST" | cut -d '=' -f6 | grep "172.25" | cut -d ")" -f1 | cut -c 2-

if [[ ! -f ~/tns_admin ]]; then 
mkdir ~/tns_admin
fi
 
cd ~/tns_admin
mkstore -wrl ${ORACLE_WALLET_LOCATION} -create

echo "SQLNET.WALLET_OVERRIDE = TRUE
WALLET_LOCATION=(
  SOURCE=(METHOD=FILE)
  (METHOD_DATA=(DIRECTORY=`echo $ORACLE_WALLET_LOCATION`))
)" > $ORACLE_SQLNET_FILE_LOCATION/sqlnet.ora

echo "
`echo $ORACLE_WALLET_NAME` = (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = `echo $DB_IP`)(PORT = 1521))(CONNECT_DATA = (SERVICE_NAME = ora12c)))
" >> ~/tns_admin/tnsnames.ora
echo "
TNSPING_DATA_WRAPPER=`echo $TNSPING_DATA`
" > tnsping.log
