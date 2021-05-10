undef tabowner
undef tabname
@plusenv
col statstime 		format a16
col tname 		format a60
col subpart		format a20
select count(*), to_char(STATS_UPDATE_TIME,'YYYY/MM/DD HH24:MI') statstime, owner||'.'||table_name||' - '||partition_name tname, STATS_UPDATE_TIME
  from dba_tab_stats_history 
  where owner=upper('&&tabowner')
  and TABLE_NAME=upper('&&tabname')
group by STATS_UPDATE_TIME, owner||'.'||table_name||' - '||partition_name
  order by STATS_UPDATE_TIME; 

prompt => exec dbms_stats.restore_table_stats(ownname=>'&&tabowner',tabname=>'&&tabname',AS_OF_TIMESTAMP=>'STATS_UPDATE_TIME');
