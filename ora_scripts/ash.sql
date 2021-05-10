--
-- Show top sql_ids, objects, events, modules in terms of CPU, I/O, Wait in the last x mins
--
@plusenv

undef last_x_mins

col cnt		format 9999999	head 'Cnt'
col cpu		format 99999	head '*CPU*'
col event 	format a36 trunc
col io		format 99999
col module 	format a40 trunc
col obj#	format 9999999
col obj_name 	format a60 trunc
col oname	format a60	head 'Object - Subobject'
col pct   	format 999.9	head 'Pct'
col pctcpu	format 999.9	head 'CPU%'
col pctio	format 999.9	head 'IO%'
col pcttot	format 999.9	head 'TOT%'
col pctwait	format 999.9	head 'WAIT%'
col sql_id	format a13
col tot		format 999999	head '*TOT*'
col wait	format 99999

-- on cpu vs waiting vs io --

col sql_id	format a13
col module 	format a40 trunc
col cpu		format 999,999	head '*CPU*'
col wait	format 999,999
col io		format 999,999
col tot		format 9,999,999	head 'TOT'
col pctcpu	format 999.9	head 'CPU%'
col pctio	format 999.9	head 'IO%'
select 	 
     	 sum(decode(ash.session_state,'ON CPU',1,0))     					cpu
     	,sum(decode(ash.session_state,'WAITING',1,0)) - sum(decode(ash.session_state,'WAITING',decode(en.wait_class, 'User I/O',1,0),0))    wait
     	,sum(decode(ash.session_state,'WAITING', decode(en.wait_class, 'User I/O',1,0),0))    	io
     	,sum(decode(ash.session_state,'ON CPU',1,1))     					tot
from 	 v$active_session_history 	ash
        ,v$event_name 			en
where 	 ash.event#		= en.event# (+)
and 	 sample_time 		>= sysdate - &&last_x_mins/1440
;

-- top sql_ids --
prompt
prompt ** top sql_ids **
@ash_top_sqlid0

-- top events --
prompt
prompt ** top events **
@ash_top_event0

-- top objects --
prompt
prompt ** top objects **
@ash_top_obj0

-- top modules --
prompt
prompt ** top modules **
@ash_top_module0

-- top I/Os by sql_id --
prompt
prompt ** top I/Os by sql_id **
@ash_top_io0
