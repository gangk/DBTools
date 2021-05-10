#!/bin/sh
INTERVAL=5
RUNFILE=/Users/gangk/mysql_stats
PREFIX=$INTERVAL-sec-status
##############RDS Variables################
RDSHOST=gscrs1na-aurora-gamma.cluster-cwnv6um7ntda.us-east-1.rds.amazonaws.com
RDSUSER=transmaster
RDSPASSWORD=Transrdsdbs!!
RDSPORT=8195
##############RDS Variables################

mysql -h "$RDSHOST" -u "$RDSUSER" -p"$RDSPASSWORD" -P "$RDSPORT" -e "SHOW GLOBAL VARIABLES" > mysql-variables.txt

while test -e $RUNFILE; do
   file=${date +%F_%I}
   sleep=${date +%s.%N | awk "{print $INTERVAL - (\$1 % $INTERVAL)}"}
   sleep $sleep
   ts="${date +"TS %s.%N %F %T"}"
   loadavg="${uptime}"
   echo "$ts $loadavg" >> $PREFIX-${file}-status
   mysql -h "$RDSHOST" -u "$RDSUSER" -p"$RDSPASSWORD" -P "$RDSPORT" -e 'SHOW GLOBAL STATUS' >> $PREFIX-${file}-status.txt &
   echo "$ts $loadavg" >> $PREFIX-${file}-processlist
   mysql -h "$RDSHOST" -u "$RDSUSER" -p"$RDSPASSWORD" -P "$RDSPORT" -e 'SHOW FULL PROCESSLIST\G' >> $PREFIX-${file}-processlist.txt &
   echo "$ts $loadavg" >> $PREFIX-${file}-innodbstatus
   mysql -h "$RDSHOST" -u "$RDSUSER" -p"$RDSPASSWORD" -P "$RDSPORT" -e 'SHOW ENGINE INNODB STATUS\G' >> $PREFIX-${file}-innodbstatus.txt &
   echo $ts
done
echo Exiting because $RUNFILE does not exist.
