#!/bin/ksh
# Author......:  T.Grimmett
# Status......:  Complete
# Status Date :  9/15/11
# Version.....:  1.0
#
# Purpose:
#  Report on key system history read and write wait events
#
# Revision History:
#  9/15/11 TJG Initial Code
USAGE='Usage: oraiohist -b <begin_snap> -e <end_snap>  HINT: Use orasnaphist to find snapids'
while getopts b:e: OPT
do
   case $OPT in
      b) bsnap=$OPTARG ;;
      e) esnap=$OPTARG ;;
      *) echo $USAGE; exit 1 ;;
   esac
done

if [[ "$bsnap" = "" ]]; then
   echo $USAGE
   exit 1
fi

if [[ "$esnap" = "" ]]; then
   echo $USAGE
   exit 1
fi

echo bsnap = $bsnap
echo esnap = $esnap

sqlplus -s "/ as sysdba" << EOF
set head on
set pages 5000
set lines 1000
set verify off
set trimspool on
set trimout on
set feed off
set echo off
set time off
set timing off
set numformat 99.9


column report_type new_value report_type


alter session set nls_date_format = 'YY-MM-DD:HH24:MI:SS';


set head off
select '" SNAPSHOT: ' || $bsnap || '-' || $esnap || '"' from dual;
set head on

PROMPT "IO Events"
PROMPT "~~~~~~~~~~"

col ttime heading '.|Time'  just r null 'N/A' format a16
col instance_number heading 'Ins|No' just r  null 'N/A' format a3
col db_seq_rd_cnt heading 'Seq|Read|Cnt' just r null 'N/A' format 9,999,999
col db_seq_rd_ms  heading 'Seq|Read|MS'  just r null 'N/A' format 999.9
col db_sct_rd_cnt heading 'Scat|Read|Cnt' just r null 'N/A' format 999,999
col db_sct_rd_ms  heading 'Scat|Read|MS' just r null 'N/A' format 999.9
col db_par_rd_cnt heading 'Para|Read|Cnt' just r null 'N/A' format 999,999
col db_par_rd_ms  heading 'Para|Read|MS' just r null 'N/A' format 999.9
col dp_rd_cnt heading 'Direct|Read|Cnt' just r null 'N/A' format 999,999
col dp_rd_ms  heading 'Direct|Read|MS' just r null 'N/A' format 999.99
col db_sin_wr_cnt heading 'Single|Write|Cnt' just r null 'N/A' format 9,999
col db_sin_wr_ms  heading 'Single|Write|MS'  just r null 'N/A' format 99.9
col db_par_wr_cnt heading 'Para|Write|Cnt' just r null 'N/A' format 999,999
col db_par_wr_ms  heading 'Para|Writ|MS'  just r null 'N/A' format 999.9
col dp_wr_cnt heading 'Drect|Write|Cnt' just r null 'N/A' format 999,999
col dp_wr_ms  heading 'Drect|Write|MS' just r null 'N/A' format 9.999

compute avg maximum minimum of db_seq_rd_cnt db_seq_rd_ms db_sct_rd_cnt db_sct_rd_ms db_par_rd_cnt db_par_rd_ms dp_rd_cnt dp_rd_ms db_sin_wr_cnt db_sin_wr_ms db_par_wr_cnt db_pa
r_wr_ms dp_wr_cnt dp_wr_ms on report
break on report

select
       to_char(end_interval_time,'YY-MM-DD:HH24:MI') ttime,
       rpad(to_char(instance_number),3) instance_number,
       sum(db_seq_rd_cnt) db_seq_rd_cnt,
       avg(db_seq_rd_micro / 1000 / db_seq_rd_cnt) db_seq_rd_ms,
       sum(db_sct_rd_cnt) db_sct_rd_cnt,
       avg(db_sct_rd_micro / 1000 / db_sct_rd_cnt) db_sct_rd_ms,
       sum(db_par_rd_cnt) db_par_rd_cnt,
       avg(db_par_rd_micro / 1000 / db_par_rd_cnt) db_par_rd_ms,
       sum(dp_rd_cnt) dp_rd_cnt,
       avg(dp_rd_micro / 1000 / dp_rd_cnt) dp_rd_ms,
       sum(db_sin_wr_cnt) db_sin_wr_cnt,
       avg(db_sin_wr_micro / 1000 / db_sin_wr_cnt) db_sin_wr_ms,
       sum(db_par_wr_cnt) db_par_wr_cnt,
       avg(db_par_wr_micro / 1000 / db_par_wr_cnt) db_par_wr_ms,
       sum(dp_wr_cnt) dp_wr_cnt,
       avg(dp_wr_micro / 1000 / dp_wr_cnt) dp_wr_ms
from
(
select s.snap_id, s.end_interval_time, s.instance_number,
    case when event_name = lag(event_name) over (order by ss.event_name,ss.instance_number,s.snap_id) and  event_name = 'db file sequential read' and ss.instance_number = lag(ss
.instance_number) over (order by ss.event_name,ss.instance_number,s.snap_id) and
          total_waits > lag(total_waits) over (order by ss.event_name,ss.instance_number,s.snap_id) then
          total_waits - lag(total_waits) over (order by ss.event_name,ss.instance_number,s.snap_id)
       end db_seq_rd_cnt,
    case when event_name = lag(event_name) over (order by ss.event_name,ss.instance_number,s.snap_id) and  event_name = 'db file sequential read' and ss.instance_number = lag(ss
.instance_number) over (order by ss.event_name,ss.instance_number,s.snap_id) and
          time_waited_micro > lag(time_waited_micro) over (order by ss.event_name,ss.instance_number,s.snap_id) then
          time_waited_micro - lag(time_waited_micro) over (order by ss.event_name,ss.instance_number,s.snap_id)
       end db_seq_rd_micro,
    case when event_name = lag(event_name) over (order by ss.event_name,ss.instance_number,s.snap_id) and  event_name = 'db file scattered read' and ss.instance_number = lag(ss.
instance_number) over (order by ss.event_name,ss.instance_number,s.snap_id) and
          total_waits > lag(total_waits) over (order by ss.event_name,ss.instance_number,s.snap_id) then
          total_waits - lag(total_waits) over (order by ss.event_name,ss.instance_number,s.snap_id)
       end db_sct_rd_cnt,
    case when event_name = lag(event_name) over (order by ss.event_name,ss.instance_number,s.snap_id) and  event_name = 'db file scattered read' and ss.instance_number = lag(ss.
instance_number) over (order by ss.event_name,ss.instance_number,s.snap_id) and
          time_waited_micro > lag(time_waited_micro) over (order by ss.event_name,ss.instance_number,s.snap_id) then
          time_waited_micro - lag(time_waited_micro) over (order by ss.event_name,ss.instance_number,s.snap_id)
       end db_sct_rd_micro,
    case when event_name = lag(event_name) over (order by ss.event_name,ss.instance_number,s.snap_id) and  event_name = 'db file parallel read' and ss.instance_number = lag(ss.i
nstance_number) over (order by ss.event_name,ss.instance_number,s.snap_id) and
          total_waits > lag(total_waits) over (order by ss.event_name,ss.instance_number,s.snap_id) then
          total_waits - lag(total_waits) over (order by ss.event_name,ss.instance_number,s.snap_id)
       end db_par_rd_cnt,
    case when event_name = lag(event_name) over (order by ss.event_name,ss.instance_number,s.snap_id) and  event_name = 'db file parallel read' and ss.instance_number = lag(ss.i
nstance_number) over (order by ss.event_name,ss.instance_number,s.snap_id) and
          time_waited_micro > lag(time_waited_micro) over (order by ss.event_name,ss.instance_number,s.snap_id) then
          time_waited_micro - lag(time_waited_micro) over (order by ss.event_name,ss.instance_number,s.snap_id)
       end db_par_rd_micro,
    case when event_name = lag(event_name) over (order by ss.event_name,ss.instance_number,s.snap_id) and  event_name = 'direct path read' and ss.instance_number = lag(ss.instan
ce_number) over (order by ss.event_name,ss.instance_number,s.snap_id) and
          total_waits > lag(total_waits) over (order by ss.event_name,ss.instance_number,s.snap_id) then
          total_waits - lag(total_waits) over (order by ss.event_name,ss.instance_number,s.snap_id)
       end dp_rd_cnt,
    case when event_name = lag(event_name) over (order by ss.event_name,ss.instance_number,s.snap_id) and  event_name = 'direct path read' and ss.instance_number = lag(ss.instan
ce_number) over (order by ss.event_name,ss.instance_number,s.snap_id) and
          time_waited_micro > lag(time_waited_micro) over (order by ss.event_name,ss.instance_number,s.snap_id) then
          time_waited_micro - lag(time_waited_micro) over (order by ss.event_name,ss.instance_number,s.snap_id)
       end dp_rd_micro,
    case when event_name = lag(event_name) over (order by ss.event_name,ss.instance_number,s.snap_id) and  event_name = 'db file single write' and ss.instance_number = lag(ss.in
stance_number) over (order by ss.event_name,ss.instance_number,s.snap_id) and
          total_waits > lag(total_waits) over (order by ss.event_name,ss.instance_number,s.snap_id) then
          total_waits - lag(total_waits) over (order by ss.event_name,ss.instance_number,s.snap_id)
       end db_sin_wr_cnt,
    case when event_name = lag(event_name) over (order by ss.event_name,ss.instance_number,s.snap_id) and  event_name = 'db file single write' and ss.instance_number = lag(ss.in
stance_number) over (order by ss.event_name,ss.instance_number,s.snap_id) and
          time_waited_micro > lag(time_waited_micro) over (order by ss.event_name,ss.instance_number,s.snap_id) then
          time_waited_micro - lag(time_waited_micro) over (order by ss.event_name,ss.instance_number,s.snap_id)
       end db_sin_wr_micro,
    case when event_name = lag(event_name) over (order by ss.event_name,ss.instance_number,s.snap_id) and  event_name = 'db file parallel write' and ss.instance_number = lag(ss.
instance_number) over (order by ss.event_name,ss.instance_number,s.snap_id) and
          total_waits > lag(total_waits) over (order by ss.event_name,ss.instance_number,s.snap_id) then
          total_waits - lag(total_waits) over (order by ss.event_name,ss.instance_number,s.snap_id)
       end db_par_wr_cnt,
    case when event_name = lag(event_name) over (order by ss.event_name,ss.instance_number,s.snap_id) and  event_name = 'db file parallel write' and ss.instance_number = lag(ss.
instance_number) over (order by ss.event_name,ss.instance_number,s.snap_id) and
          time_waited_micro > lag(time_waited_micro) over (order by ss.event_name,ss.instance_number,s.snap_id) then
          time_waited_micro - lag(time_waited_micro) over (order by ss.event_name,ss.instance_number,s.snap_id)
       end db_par_wr_micro,
    case when event_name = lag(event_name) over (order by ss.event_name,ss.instance_number,s.snap_id) and  event_name = 'direct path write' and ss.instance_number = lag(ss.insta
nce_number) over (order by ss.event_name,ss.instance_number,s.snap_id) and
          total_waits > lag(total_waits) over (order by ss.event_name,ss.instance_number,s.snap_id) then
          total_waits - lag(total_waits) over (order by ss.event_name,ss.instance_number,s.snap_id)
       end dp_wr_cnt,
    case when event_name = lag(event_name) over (order by ss.event_name,ss.instance_number,s.snap_id) and  event_name = 'direct path write' and ss.instance_number = lag(ss.insta
nce_number) over (order by ss.event_name,ss.instance_number,s.snap_id) and
          time_waited_micro > lag(time_waited_micro) over (order by ss.event_name,ss.instance_number,s.snap_id) then
          time_waited_micro - lag(time_waited_micro) over (order by ss.event_name,ss.instance_number,s.snap_id)
       end dp_wr_micro
from
   dba_hist_system_event        ss,
   dba_hist_snapshot         s
where
   s.snap_id = ss.snap_id
   and s.snap_id between $bsnap and  $esnap
   and ss.instance_number = s.instance_number
   and ss.event_name  in
                         ('db file sequential read'
                         ,'db file scattered read'
                         ,'db file parallel read'
                         ,'direct path read'
                         ,'db file single write'
                         ,'db file parallel write'
                         ,'direct path write'
                        )
         and ss.total_waits          >  0
) where snap_id > $bsnap
group by
        to_char(end_interval_time,'YY-MM-DD:HH24:MI'),
        rpad(to_char(instance_number),3)
order by
        to_char(end_interval_time,'YY-MM-DD:HH24:MI'),
        instance_number
;

--spool off
EOF
