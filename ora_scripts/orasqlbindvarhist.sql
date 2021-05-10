set verify off
set heading on
set pagesize 0
select
--      s.dbid
--        s.instance_number as inst#
--        ,s.snap_id
--        ,to_char(s.begin_interval_time,'YY-MM-DD:HH24:mi') as BEGIN_TIME
--      ,to_char(s.end_interval_time,'YY-MM-DD:HH24:mi') as END_TIME
        'ObjMgrSqlLog    Detail  4       0000018049ac243c:0      2009-03-03 00:14:17     Bind variable '||sql.name||': '||sql.value_string
from
        dba_hist_snapshot s
        ,dba_hist_sqlbind sql
where
        s.snap_id=sql.snap_id
        and s.dbid=sql.dbid
        and s.instance_number=sql.instance_number
        and sql.sql_id = '&&1'
        and s.begin_interval_time > sysdate - &&2
order by
        s.snap_id
        ,s.instance_number
        ,sql.position
;
