-- setup columns for snapshots

column bsnap1 new_value bsnap1s noprint;
column esnap1 new_value esnap1s noprint;
column bsnap2 new_value bsnap2s noprint;
column esnap2 new_value esnap2s noprint;
column bsnap3 new_value bsnap3s noprint;
column esnap3 new_value esnap3s noprint;


-- get snap id for yesterday 10 am to 4 pm central

-- get snap id for 10 am yesterday

select snap_id bsnap1,END_INTERVAL_TIME
from dba_hist_snapshot
where 
extract(year from END_INTERVAL_TIME)=extract(year from (sysdate-1-(case trim(to_char(sysdate,'DAY')) WHEN 'MONDAY' then 2 ELSE 0 end))) and
extract(month from END_INTERVAL_TIME)=extract(month from (sysdate-1-(case trim(to_char(sysdate,'DAY')) WHEN 'MONDAY' then 2 ELSE 0 end))) and
extract(day from END_INTERVAL_TIME)=extract(day from (sysdate-1-(case trim(to_char(sysdate,'DAY')) WHEN 'MONDAY' then 2 ELSE 0 end))) and
extract(hour from END_INTERVAL_TIME)= 10;

-- get snap id for 4 pm yesterday

select snap_id esnap1,END_INTERVAL_TIME
from dba_hist_snapshot
where 
extract(year from END_INTERVAL_TIME)=extract(year from (sysdate-1-(case trim(to_char(sysdate,'DAY')) WHEN 'MONDAY' then 2 ELSE 0 end))) and
extract(month from END_INTERVAL_TIME)=extract(month from (sysdate-1-(case trim(to_char(sysdate,'DAY')) WHEN 'MONDAY' then 2 ELSE 0 end))) and
extract(day from END_INTERVAL_TIME)=extract(day from (sysdate-1-(case trim(to_char(sysdate,'DAY')) WHEN 'MONDAY' then 2 ELSE 0 end))) and
extract(hour from END_INTERVAL_TIME)= 16;

-- get snap id for 10 am a week ago yesterday

select snap_id bsnap2,END_INTERVAL_TIME
from dba_hist_snapshot
where 
extract(year from END_INTERVAL_TIME)=extract(year from (sysdate-8-(case trim(to_char(sysdate,'DAY')) WHEN 'MONDAY' then 2 ELSE 0 end))) and
extract(month from END_INTERVAL_TIME)=extract(month from (sysdate-8-(case trim(to_char(sysdate,'DAY')) WHEN 'MONDAY' then 2 ELSE 0 end))) and
extract(day from END_INTERVAL_TIME)=extract(day from (sysdate-8-(case trim(to_char(sysdate,'DAY')) WHEN 'MONDAY' then 2 ELSE 0 end))) and
extract(hour from END_INTERVAL_TIME)= 10;

-- get snap id for 4 pm a week ago yesterday

select snap_id esnap2,END_INTERVAL_TIME
from dba_hist_snapshot
where 
extract(year from END_INTERVAL_TIME)=extract(year from (sysdate-8-(case trim(to_char(sysdate,'DAY')) WHEN 'MONDAY' then 2 ELSE 0 end))) and
extract(month from END_INTERVAL_TIME)=extract(month from (sysdate-8-(case trim(to_char(sysdate,'DAY')) WHEN 'MONDAY' then 2 ELSE 0 end))) and
extract(day from END_INTERVAL_TIME)=extract(day from (sysdate-8-(case trim(to_char(sysdate,'DAY')) WHEN 'MONDAY' then 2 ELSE 0 end))) and
extract(hour from END_INTERVAL_TIME)= 16;

-- get snap id for 10 am four weeks ago yesterday

select snap_id bsnap3,END_INTERVAL_TIME
from dba_hist_snapshot
where 
extract(year from END_INTERVAL_TIME)=extract(year from (sysdate-29-(case trim(to_char(sysdate,'DAY')) WHEN 'MONDAY' then 2 ELSE 0 end))) and
extract(month from END_INTERVAL_TIME)=extract(month from (sysdate-29-(case trim(to_char(sysdate,'DAY')) WHEN 'MONDAY' then 2 ELSE 0 end))) and
extract(day from END_INTERVAL_TIME)=extract(day from (sysdate-29-(case trim(to_char(sysdate,'DAY')) WHEN 'MONDAY' then 2 ELSE 0 end))) and
extract(hour from END_INTERVAL_TIME)= 10;

-- get snap id for 4 pm four weeks ago yesterday

select snap_id esnap3,END_INTERVAL_TIME
from dba_hist_snapshot
where 
extract(year from END_INTERVAL_TIME)=extract(year from (sysdate-29-(case trim(to_char(sysdate,'DAY')) WHEN 'MONDAY' then 2 ELSE 0 end))) and
extract(month from END_INTERVAL_TIME)=extract(month from (sysdate-29-(case trim(to_char(sysdate,'DAY')) WHEN 'MONDAY' then 2 ELSE 0 end))) and
extract(day from END_INTERVAL_TIME)=extract(day from (sysdate-29-(case trim(to_char(sysdate,'DAY')) WHEN 'MONDAY' then 2 ELSE 0 end))) and
extract(hour from END_INTERVAL_TIME)= 16;

-- awr report for yesterday

define report_type='html';
define begin_snap = &bsnap1s;
define end_snap   = &esnap1s;
define report_name = 'yesterday.html';

define num_days = 0;

@@$ORACLE_HOME/rdbms/admin/awrrpt.sql

undefine report_type
undefine report_name
undefine begin_snap
undefine end_snap
undefine num_days

-- awr report for week ago yesterday

define report_type='html';
define begin_snap = &bsnap2s;
define end_snap   = &esnap2s;
define report_name = 'weekagoyesterday.html';

define num_days = 0;

@@$ORACLE_HOME/rdbms/admin/awrrpt.sql

undefine report_type
undefine report_name
undefine begin_snap
undefine end_snap
undefine num_days

-- awr report for 4 weeks ago yesterday

define report_type='html';
define begin_snap = &bsnap3s;
define end_snap   = &esnap3s;
define report_name = '4weeksagoyesterday.html';

define num_days = 0;

@@$ORACLE_HOME/rdbms/admin/awrrpt.sql

undefine report_type
undefine report_name
undefine begin_snap
undefine end_snap
undefine num_days
