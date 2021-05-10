@plusenv
col value	format 99,999,999.99
col metric_name format a30
col btime	format a08
col etime	format a08
set head off

with cpu_util	as
(
select   begin_time
	,end_time
	,metric_name
	,value
	,decode(metric_name,
         'Host CPU Utilization (%)',010
        ,'Current OS Load' 	   ,015
	,'?')	stat_seq
from	 v$sysmetric_history
where	 begin_time > sysdate -15/1440
and	 metric_name ='Host CPU Utilization (%)'
)
,   cpu_load as
(
select   begin_time
        ,end_time
        ,metric_name
        ,value
	,decode(metric_name,
	'Host CPU Utilization (%)',010
        ,'Current OS Load'         ,015
        ,'?')   stat_seq
from     v$sysmetric_history
where    begin_time > sysdate -15/1440
and      metric_name = 'Current OS Load'
)
select	 
	 cpu_util.metric_name
	,'|'
	,to_char(cpu_util.begin_time,'HH24:MI:SS')	btime
	,to_char(cpu_util.end_time,'HH24:MI:SS')	etime
	,cpu_util.value
	,'|'
	,cpu_load.metric_name
	,'|'
	,cpu_load.value
	,'|'
from	 cpu_util, cpu_load
where	 cpu_util.begin_time = cpu_load.begin_time
order by btime
;
