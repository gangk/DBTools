#!/bin/bash
# Author......:  T.Grimmett
# Status......:  Work-In-Progress
# Status Date :  05/03/12
# Version.....:  1.0
#
# Purpose:
#  Produce Oracle Business Intelligence (OBI) Report History Report
#
# Notes:
#  DBA_HIST_ACTIVE_SESS_HISTORY.CLIENT_ID = OBI Report Path
#  DBA_HIST_ACTIVE_SESS_HISTORY.MODULE = OBI Sequence #, indicates a unique invocation of OBI Report Path
#
#  The OBI application calls:
#     dbms_application_info.set_module(lv_module,lv_user);
#     dbms_session.set_identifier('OBI:'||lv_ident);
#
#     where
#        lv_module is a sequence generated number, left padded with zeros to 15 places.
#        lv_user is the logged in username.
#        lv_ident is the last 60 characters of the report path/name
#
#    dbms_application_info.set_module populates GV$SESSION.MODULE and ACTION
#    dbms_session.set_identifier populated GV$SESSION.CLIENT_IDENTIFIER
#
#  This script need only be run on 1 node, it will report on SQL
#  accross all nodes in a RAC.
#
# Revision History:
#  05/03/12 TJG Initial Code

USAGE='Usage: oraobirephist -i <instance_name>'
while getopts i: OPT
do
   case $OPT in
      i) InstName=$OPTARG ;;
      *) echo $USAGE; exit 1 ;;
   esac
done

if [[ "$InstName" = "" ]]; then
   echo $USAGE
   exit 1
fi

. /etc/init.d/oracle_wds_functions
export PATH=$PATH:/usr/local/git/bin:/usr/sbin
chgsid $InstName

echo "mon_obirephist.sh starts at `date`"
echo " "

##email_to=todd.grimmett@oracle.com
email_to=andy.brown@oracle.com,gundars.kokts@oracle.com,ric.ginsberg@oracle.com,gitasd-systems-dba_ww@oracle.com
##email_to=andy.brown@oracle.com,gundars.kokts@oracle.com,gitasd-systems-dba_ww@oracle.com,todd.grimmmett@oracle.com

thisday=`date +%F`
Sub="OBI Report History Report: ${InstName} $thisday"
EMAIL_BODY_TXT=$DBA/monitoring/mon_obirephist_email_body_$InstName.txt

sqlplus -s "/ as sysdba" << EOF
set echo off
set feed off
set veri off
set pagesize 0
set long 132
set longchunksize 20000
set linesize 160
set escape on
set serveroutput on
spool $EMAIL_BODY_TXT REPLACE
DECLARE
        hv_top_N NUMBER := 10;
        hv_row_count NUMBER := 0;
        hv_killed_count NUMBER;
        hv_begin_time DATE;
        hv_begin_date VARCHAR(32);
        hv_begin_hour_min CHAR(5);
        hv_end_time DATE;
        hv_end_date VARCHAR(32);
        hv_end_hour_min CHAR(5);
        hv_first_row NUMBER;
        hv_db_unique_name VARCHAR2(30);
        hv_report_short_name VARCHAR2(60);
        hv_instance_name VARCHAR2(16);
        hv_sql_text CLOB;
        hv_sqlid_count NUMBER;
        hv_total_disk_reads NUMBER;
        hv_usage_count NUMBER;
        hv_bsnap NUMBER;
        hv_esnap NUMBER;
BEGIN
        select sysdate into hv_end_date from dual;
        select db_unique_name into hv_db_unique_name from v\$database;
        select instance_name into hv_instance_name from v\$instance;
        select max(snap_id) into hv_esnap from dba_hist_snapshot;
        hv_bsnap := hv_esnap - 23;
        --hv_bsnap := hv_esnap - 2;
        select begin_interval_time into hv_begin_time from dba_hist_snapshot where snap_id = hv_bsnap and instance_number = 2;
        select to_char(begin_interval_time,'DD-MON-YY-"00:00:00"') into hv_begin_date from dba_hist_snapshot where snap_id = hv_bsnap and instance_number = 2;
        select to_char(begin_interval_time,'HH24:MI') into hv_begin_hour_min from dba_hist_snapshot where snap_id = hv_bsnap and instance_number = 2;
        select end_interval_time into hv_end_time from dba_hist_snapshot where snap_id = hv_esnap and instance_number = 2;
        select to_char(end_interval_time,'DD-MON-YY-"00:00:00"') into hv_end_date from dba_hist_snapshot where snap_id = hv_esnap and instance_number = 2;
        select to_char(end_interval_time,'HH24:MI') into hv_end_hour_min from dba_hist_snapshot where snap_id = hv_esnap and instance_number = 2;
        with dist_obi_sqlid as (
                select distinct
                        ash.client_id,
                        ash.sql_id
                from
                        dba_hist_active_sess_history ash,
                        dba_hist_snapshot s
                where
                        s.snap_id=ash.snap_id
                        and s.snap_id between hv_bsnap and hv_esnap
                        and s.dbid=ash.dbid
                        and s.instance_number=ash.instance_number
                        and (ash.client_id like 'OBI%' and ash.client_id not like 'OBI:Unspecified')
        )
        select
                         sum(sql.disk_reads_delta) sum_disk_reads
                into
                        hv_total_disk_reads
                from
                         dba_hist_snapshot s
                        ,dba_hist_sqlstat sql
                        ,dist_obi_sqlid obi
                where
                            s.snap_id=sql.snap_id
                        and s.dbid=sql.dbid
                        and s.instance_number=sql.instance_number
                        and s.snap_id between hv_bsnap and hv_esnap
                        and sql.sql_id = obi.sql_id
                        and sql.executions_delta <> 0
        ;
        dbms_output.put_line('oraobirephist start time .......: '||hv_end_date );
        dbms_output.put_line(chr(9));
        dbms_output.put_line('############################################################################');
        dbms_output.put_line('OBIEE Report History:');
        dbms_output.put_line('DB_UNIQUE_NAME......: '||hv_db_unique_name);
        dbms_output.put_line('Begin Snapshot......: '||hv_bsnap);
        dbms_output.put_line('End Snapshot........: '||hv_esnap);
        dbms_output.put_line('Begin Date..........: '||hv_begin_date);
        dbms_output.put_line('Begin Hour Min......: '||hv_begin_hour_min);
        dbms_output.put_line('End Date............: '||hv_end_date);
        dbms_output.put_line('End Hour Min........: '||hv_end_hour_min);
        dbms_output.put_line('Top N, where N is...: '||hv_top_N);
        dbms_output.put_line('Total OBI Disk Reads: '||to_char(hv_total_disk_reads,'999,999,999'));
        dbms_output.put_line('-----------------------------------------');
        dbms_output.put_line('NOTE: OBI:Unspecified (Oracle Answers) metrics have been omitted for the sake of size');
        dbms_output.put_line('############################################################################');

        for c1 in (
                with dist_obi_sqlid as (
                select distinct
                        ash.client_id,
                        ash.sql_id
                from
                        dba_hist_active_sess_history ash,
                        dba_hist_snapshot s
                where
                        s.snap_id=ash.snap_id
                        and s.snap_id between hv_bsnap and hv_esnap
                        and s.dbid=ash.dbid
                        and s.instance_number=ash.instance_number
                        and (ash.client_id like 'OBI%' and ash.client_id not like 'OBI:Unspecified%')
                )
                select
                         obi.client_id
                        ,sum(sql.disk_reads_delta) sum_disk_reads
                from
                         dba_hist_snapshot s
                        ,dba_hist_sqlstat sql
                        ,dist_obi_sqlid obi
                where
                            s.snap_id=sql.snap_id
                        and s.dbid=sql.dbid
                        and s.instance_number=sql.instance_number
                        and sql.sql_id = obi.sql_id
                        and s.snap_id between hv_bsnap and hv_esnap
                        and sql.executions_delta <> 0
                group by
                        obi.client_id
                order by
                        sum_disk_reads desc
        ) loop
        hv_row_count := hv_row_count + 1;
        if (hv_row_count > hv_top_N) then
                exit;
        end if;
        dbms_output.put_line(chr(9));
        dbms_output.put_line('+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
        dbms_output.put_line('+ REPORT PATH.............: '||rpad(c1.client_id,64,' '));
        dbms_output.put_line('+ REPORT DISK READS.......: '||to_char(c1.sum_disk_reads,'999,999,999'));
        dbms_output.put_line('+ TOTAL OBI DISK READS....: '||to_char(hv_total_disk_reads,'999,999,999'));
        dbms_output.put_line('+ PCT OF TOTAL DISK READS.: '||to_char((c1.sum_disk_reads/hv_total_disk_reads)*100,'999.99'));
        dbms_output.put_line('+');

        hv_report_short_name := substr(c1.client_id,5);
        --dbms_output.put_line('+ REPORT SHORT NAME: '||hv_report_short_name);

        select /*+ index(usage WC_USAGE_TRACK_TODD_03) */
                count(*) into hv_usage_count
        from
                siebel.wc_usage_track_f usage
        where
                saw_src_path like '%'||hv_report_short_name
                and ( to_date(to_char(start_dt,'YYYY-MM-DD')||':'||start_hour_min,'YYYY-MM-DD:HH24:MI') >= hv_begin_time and to_date(to_char(start_dt,'YYYY-MM-DD')||':'||start_h
our_min,'YYYY-MM-DD:HH24:MI') <= hv_end_time )
        ;
        --dbms_output.put_line('+ hv_usage_count = '||hv_usage_count);

        if (hv_usage_count > 0) then
                hv_first_row := 1;
                for c3 in (
                select /*+ index(ut WC_USAGE_TRACK_TODD_03) */
                        saw_src_path,
                        start_dt,
                        start_hour_min,
                        end_dt,
                        end_hour_min,
                        row_count,
                        total_time_sec
                from
                        siebel.wc_usage_track_f ut
                where
                        saw_src_path like '%'||hv_report_short_name
                        and ( to_date(to_char(start_dt,'YYYY-MM-DD')||':'||start_hour_min,'YYYY-MM-DD:HH24:MI') >= hv_begin_time and to_date(to_char(start_dt,'YYYY-MM-DD')||':'|
|start_hour_min,'YYYY-MM-DD:HH24:MI') <= hv_end_time )
                order by
                        1,2,3
                ) loop
                if (hv_first_row = 1) then
                        hv_first_row := 0;
                        dbms_output.put_line('+ USAGE TRACKING SECTION');
                        dbms_output.put_line('+');
                        dbms_output.put_line('+ SAW_SRC_PATH..............:  '||c3.saw_src_path);
                        dbms_output.put_line('+ USAGE TRACKING EXEC COUNT.: '||to_char(hv_usage_count,'99,999'));
                        dbms_output.put_line('+');
                        dbms_output.put_line('+      Start             End      Total     Row');
                        dbms_output.put_line('+ YY-MM-DD HR:MI  YY-MM-DD HR:MI   Secs    Count');
                        dbms_output.put_line('+ -------- -----  -------- -----  ------   ------');
                end if;
                dbms_output.put_line('+ '||to_char(c3.start_dt,'YY-MM-DD')||' '||c3.start_hour_min||'  '||to_char(c3.end_dt,'YY-MM-DD')||' '||c3.end_hour_min||' '||to_char(c3.to
tal_time_sec,'99,999')||'  '||to_char(c3.row_count,'99,999'));
                end loop;
        else
                dbms_output.put_line('+ '||hv_report_short_name||' not found in Usage Tracking.');
        end if;

        dbms_output.put_line('+');
        dbms_output.put_line('+ AWR SECTION');
        dbms_output.put_line('+                                      Para  Elapsed  CPU     Rows       Gets     Disk Reads Killed');
        dbms_output.put_line('+    SQL ID      Snapshot Begin  Execs Execs perExec perExec perExec    perExec     perExec  Count');
        dbms_output.put_line('+-------------- ---------------- ----- ----- ------- ------- ------- ------------ ---------- ------');

        for c4 in (
                select distinct
                        --ash.module,
                        ash.sql_id
                from
                        dba_hist_active_sess_history ash,
                        dba_hist_snapshot s
                where
                        s.snap_id=ash.snap_id
                        and s.snap_id between hv_bsnap and hv_esnap
                        and s.dbid=ash.dbid
                        and s.instance_number=ash.instance_number
                        and ash.client_id = c1.client_id
                order by
--                        module,
                        sql_id
        ) loop

        select count(*) into hv_sqlid_count
                from
                         dba_hist_snapshot s
                        ,dba_hist_sqlstat sql
                where
                            s.snap_id=sql.snap_id
                        and s.dbid=sql.dbid
                        and s.instance_number=sql.instance_number
                        and s.snap_id between hv_bsnap and hv_esnap
                        and sql.sql_id = c4.sql_id
                        and sql.executions_delta <> 0;

        if (hv_sqlid_count > 0) then
                for c2 in
                ( select
                         to_char(s.begin_interval_time,'YY-MM-DD:HH24:MI:SS') as BEGIN_TIME
                        ,to_char(s.end_interval_time,'YY-MM-DD:HH24:MI:SS') as END_TIME
                        ,sql.sql_id
                        ,sql.plan_hash_value
                        ,sql.optimizer_cost
                        ,sql.executions_delta as execs
                        ,sql.px_servers_execs_delta as px_execs
                        ,(sql.elapsed_time_delta / sql.executions_delta) / 1000000 as Elap_per_exec
                        ,(sql.cpu_time_delta / sql.executions_delta) / 1000000 as CPU_per_exec
                        ,(sql.rows_processed_delta / sql.executions_delta) as Rows_per_exec
                        ,(sql.buffer_gets_delta / sql.executions_delta) as Gets_per_exec
                        ,(sql.disk_reads_delta / sql.executions_delta) as Preads_per_exec
                from
                         dba_hist_snapshot s
                        ,dba_hist_sqlstat sql
                where
                            s.snap_id=sql.snap_id
                        and s.dbid=sql.dbid
                        and s.instance_number=sql.instance_number
                        and s.snap_id between hv_bsnap and hv_esnap
                        and sql.sql_id = c4.sql_id
                        and sql.executions_delta <> 0
                order by
                        begin_time
                ) loop
                select
                        count(*)
                into
                        hv_killed_count
                from
                        asd_mon_lr_killed_sql
                where
                        sql_id = c2.sql_id
                        and insert_time_stamp >= to_date(c2.begin_time,'YY-MM-DD:HH24:MI:SS')
                        and insert_time_stamp <= to_date(c2.end_time,'YY-MM-DD:HH24:MI:SS')
                ;
                dbms_output.put_line('+ '||c2.sql_id||' '||c2.begin_time||' '||to_char(c2.execs,'999')||' '||to_char(c2.px_execs,'9999')||' '||to_char(c2.Elap_per_exec,'99,999')
||' '||to_char(c2.CPU_per_exec,'99,999')||' '||to_char(c2.Rows_per_exec,'99,999')||' '||to_char(c2.Gets_per_exec,'999,999,999')||' '||to_char(c2.Preads_per_exec,'9,999,999')||'
'||to_char(hv_killed_count,99999));
                end loop;
        else
                dbms_output.put_line('+ '||c4.sql_id||' not found in AWR.');
        end if;
        end loop;
        end loop;
END;
/
SPOOL OFF
EOF
echo "sending email"
cat $EMAIL_BODY_TXT | mail -s "$Sub" $email_to
##sendmail -t -oi < $EMAIL_BODY_TXT
echo " "
echo "mon_obirephist.sh ends at `date`"
echo " "
