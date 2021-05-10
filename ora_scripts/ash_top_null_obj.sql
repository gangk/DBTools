set echo off feed off
drop   table hndba_extents;
@big_job
create table hndba_extents as select * from dba_extents;
create index i_fb on hndba_extents (file_id,block_id);
@big_job_off

undef last_x_mins
@plusenv
col owner 		for a10
col segname 		for a40
col segment_type 	for a15
col cnt 		for 9999
col top_sql_id		for a13
col sql_id		for a13
col module      	for a40 trunc

break on sql_id
select * from
(
Select 
	 sql_id
	,top_level_sql_id		top_sql_id
	,nvl(ash.module,'['||substr(ash.machine,1,instr(ash.machine,'amazon')-2)||']')          module
      	,count(*) 	cnt
      	,owner||'.'||segment_name 	segname
      	,segment_type
from 
      v$active_session_history ash, 
      hndba_extents ext
where
       ( event like 'db file s%' or event like 'direct%' )
    and (current_obj# in (0,-1) or current_obj# is Null)
    and sample_time > sysdate - &&last_x_mins/(60*24)
    and session_state='WAITING'
    and P1 = file_id
    and P2  between  block_id and block_id + blocks - 1
group by owner
	,segment_name
	,segment_type
	,sql_id
	,top_level_sql_id
	,nvl(ash.module,'['||substr(ash.machine,1,instr(ash.machine,'amazon')-2)||']')
order by count(*) desc
)
where	 rownum <= 20
/
