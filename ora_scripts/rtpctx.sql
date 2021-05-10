------------------------------------------------------------
-- file		rtpctx.sql
-- desc		Response Time statitics CHANGE percentage reporting.
-- author	Craig A. Shallahamer, craig@orapub.com
-- orig		21-Jan-2010
-- lst upt	18-Nov-2011 
-- copyright	(c)2010,2011 OraPub, Inc.

-- It is possible to get percentages greater/lesser than 100% because there
-- is a time lag between the total calculations (which queries
-- from v$system_event) and the report query (which also queries from
-- v$system_event).
------------------------------------------------------------

prompt Remember: This report must be run twice so both the initial and
prompt final values are available. If no output, press ENTER about nine times.

set echo off
set feedback off
set heading off
set verify off
set termout off

def old_tot_time_waited=&tot_time_waited noprint
def old_tot_total_waits=&tot_total_waits noprint
def start_time=&end_time noprint
def old_tot_cpu_consume=&tot_cpu_consume noprint

col val1 new_val tot_time_waited 
col val2 new_val tot_total_waits

select	sum(b.time_waited) val1,
	sum(b.total_waits) val2
from	v$system_event b
where	b.event not in ( select a.event
			         from   o$event_type a
			         where  a.type in ('bogus','idle')
		 	       )
/

col val1 new_value tot_cpu_consume
select 	(sum(value)/1000000) val1
from	v$sys_time_model
where	stat_name in ('DB CPU','background cpu time')
/

col val1 new_value end_time
select 	to_char(sysdate,'DD-Mon-YYYY:HH24:MI:SS') val1
from	dual
/

col v2 new_value interval_s 
select	ltrim(round((to_date('&end_time','DD-Mon-YYYY:HH24:MI:SS')-to_date('&start_time','DD-Mon-YYYY:HH24:MI:SS'))*24*60*60,1)) v2
from	dual
/

col v1 new_value delta_cpu_consum
select 	&tot_cpu_consume-&old_tot_cpu_consume v1
from	dual
/ 

col v3 new_value rt_total
select	((&tot_time_waited-&old_tot_time_waited)/100)+&delta_cpu_consum+0.000000010 v3
from	dual
/

col v3 new_value wt_total
select	((&tot_time_waited-&old_tot_time_waited)/100)+0.00000000010 v3
from	dual
/

set echo off
set feedback off
set heading on
set verify off
set termout on

def osm_prog	= 'rtpctx.sql'
def osm_title	= 'Response Time Activity (&interval_s sec interval)'

start osmtitle
set linesize 88

col the_item	format a38	 heading "RT Component" trunc
col tw	 	format 999990.000 heading "Time|(sec)"
col rt_pct 	format 990.00	 heading "% RT"
col wt_pct 	format 990.00	 heading "% WT"
col avg_time 	format 99990.000 heading "Avg Time|Waited (ms)"
col wc 		format 9990	 heading "Wait|Count(k)"

select	'CPU consumption: Oracle SP + BG procs' the_item,
		100*((&delta_cpu_consum)/(&rt_total)) time_pct,
		0 wt_pct,
		0 avg_time,
		&delta_cpu_consum tw,
		0 wc
from	dual
union
select 	b.event the_item,
	100*(((b.time_waited-a.time_waited)/100)/(&rt_total)) rt_pct,
	100*(((b.time_waited-a.time_waited)/100)/(&wt_total)) wt_pct,
	1000*((b.time_waited-a.time_waited)/100)/(b.total_waits-a.total_waits) avg_time,
	((b.time_waited-a.time_waited)/100) tw,
	(b.total_waits-a.total_waits)/1000 wc
from   v$system_event b,
       system_event_snap a
where  b.event_id = a.event_id
  and  b.event not in ( select x.event
		        from   o$event_type x
		        where  x.type in ('bogus','idle')
		      )
  and  (b.total_waits-a.total_waits) > 0
order by time_pct desc
/

ttitle off
set linesize 200

col name 	format a28 		heading "Instance Workload Statistic"
col delta_work 	format 9999999999990 	heading "Interval Work"
col work_per_s 	format 99999990.000 	heading "Arrival|Rate|(work/sec)"
col work_per_ms 	format 9999990.0000 	heading "Arrival|Rate|(work/ms)"
col qt_ms 	format 99990.00000 	heading "Queue|Time|(ms/work)"
col st_ms 	format 99990.00000 	heading "Service|Time|(ms/work)"
col rt_ms 	format 99990.00000 	heading "Response|Time|(ms/work)"

select	t1.name,
	t1.value-t0.value delta_work,
	(t1.value-t0.value)/&interval_s work_per_s,
	(t1.value-t0.value)/(&interval_s*1000) work_per_ms,
	1000*&delta_cpu_consum/(t1.value-t0.value) st_ms,
	1000*&wt_total/(t1.value-t0.value) qt_ms,
	1000*(&wt_total+&delta_cpu_consum)/(t1.value-t0.value) rt_ms
from	v$sysstat t1,
	rtpctx t0
where	t0.name = t1.name
/

set echo off
set feedback off
set heading off
set verify off
set termout off

truncate table system_event_snap
/
insert /*+ APPEND */ into system_event_snap nologging
select * 
from   v$system_event b
where  b.event not in ( select a.event
			from   o$event_type a
			where  a.type in ('bogus','idle')
		       )
/

drop table rtpctx;
create table rtpctx as select * from v$sysstat
where name in ('execute count','session logical reads','user calls','block changes','physical reads','physical read IO requests','parse count (hard)','parse count (total)')
/

commit;

set termout on

start osmclear