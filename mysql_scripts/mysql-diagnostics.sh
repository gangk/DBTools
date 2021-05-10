#!/bin/sh

##################
#
# SETTINGS
# PLEASE SET VARIABLES BELOW
# 
# RDSUSER requires at least a PROCESS PRIVILEGE
# 
# It's advised to call this script as unpriviled user from cron. Please set proper permissions for STAT_DIR to allow that user to write files in that directory
#################
RDSHOST='gscrs1na-aurora-gamma.cluster-cwnv6um7ntda.us-east-1.rds.amazonaws.com'
RDSUSER='transmaster'
RDSPASSWORD='Transrdsdbs!!'
RDSPORT='8195'
STAT_DIR="${HOME}/mysql_stats/"

/Users/gangk/.bash_profile

##################
# SCRIPT
#################
DATE=`date -u '+%Y-%m-%d-%H%M%S'`
mkdir -p ${STAT_DIR}

#        echo "================VARIABLES================" >> ${STAT_DIR}/${DATE}.output
#        /Users/gangk/develop/mysql-5.7.12-osx10.11-x86_64/bin/mysql -u ${RDSUSER} --password=${RDSPASSWORD} -h ${RDSHOST} -P ${RDSPORT} -e 'SHOW VARIABLES;' >> ${STAT_DIR}/${DATE}.output
#        echo "================GLOBAL VARIABLES================" >> ${STAT_DIR}/${DATE}.output
#        /Users/gangk/develop/mysql-5.7.12-osx10.11-x86_64/bin/mysql -u ${RDSUSER} --password=${RDSPASSWORD} -h ${RDSHOST} -P ${RDSPORT} -e 'SHOW GLOBAL VARIABLES;' >> ${STAT_DIR}/${DATE}.output

if [ $? -eq 0 ]; then

	echo "================FULL PROCESS LIST================" >> ${STAT_DIR}/${DATE}.output
	/Users/gangk/develop/mysql-5.7.12-osx10.11-x86_64/bin/mysql -u ${RDSUSER} --password=${RDSPASSWORD} -h ${RDSHOST} -P ${RDSPORT} -e 'SHOW FULL PROCESSLIST;' >> ${STAT_DIR}/${DATE}.output
	echo "================INNODB STATUS================" >> ${STAT_DIR}/${DATE}.output
	/Users/gangk/develop/mysql-5.7.12-osx10.11-x86_64/bin/mysql -u ${RDSUSER} --password=${RDSPASSWORD} -h ${RDSHOST} -P ${RDSPORT} -e 'SHOW ENGINE INNODB STATUS\G' >> ${STAT_DIR}/${DATE}.output
	echo "================INNODB MUTEX================" >> ${STAT_DIR}/${DATE}.output
	/Users/gangk/develop/mysql-5.7.12-osx10.11-x86_64/bin/mysql -u ${RDSUSER} --password=${RDSPASSWORD} -h ${RDSHOST} -P ${RDSPORT} -e 'SHOW ENGINE INNODB MUTEX;' >> ${STAT_DIR}/${DATE}.output
	echo "================GLOBAL STATUS================" >> ${STAT_DIR}/${DATE}.output
	/Users/gangk/develop/mysql-5.7.12-osx10.11-x86_64/bin/mysql -u ${RDSUSER} --password=${RDSPASSWORD} -h ${RDSHOST} -P ${RDSPORT} -e 'SHOW GLOBAL STATUS;' >> ${STAT_DIR}/${DATE}.output
	echo "================LOCKS================" >> ${STAT_DIR}/${DATE}.output
	/Users/gangk/develop/mysql-5.7.12-osx10.11-x86_64/bin/mysql -u ${RDSUSER} --password=${RDSPASSWORD} -h ${RDSHOST} -P ${RDSPORT} -e 'SELECT trx_id, trx_state, trx_wait_started, trx_requested_lock_id, time_to_sec(timediff(now(),trx_started)) AS cq, lock_type, lock_table, lock_index, lock_data FROM information_schema.innodb_trx LEFT JOIN information_schema.innodb_locks ON trx_requested_lock_id=lock_id; ' >> ${STAT_DIR}/${DATE}.output
	echo "================PROFILE================" >> ${STAT_DIR}/${DATE}.output
	/Users/gangk/develop/mysql-5.7.12-osx10.11-x86_64/bin/mysql -u ${RDSUSER} --password=${RDSPASSWORD} -h ${RDSHOST} -P ${RDSPORT} -e 'SHOW PROFILE;' >> ${STAT_DIR}/${DATE}.output
else
	echo "DIRECTORY CREATING ERROR"
fi
