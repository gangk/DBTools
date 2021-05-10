/**********************************************************************
 * File:        sp_sys_time_trends.sql
 * Type:        SQL*Plus script
 * Author:      Tim Gorman (Evergreen Database Technologies, Inc.)
 * Edited by Coskan Gundogar for sys_time_model metrics
 * Date:        15-Jul-2003
 *
 * Description:
 *      Query to display "trends" for specific statistics captured by
 *	the STATSPACK package, and display summarized totals daily and
 *	hourly as a ratio using the RATIO_FOR_REPORT analytic function.
 *
 *	The intent is to find the readings with the greatest deviation
 *	from the average value, as these are likely to be "periods of
 *	interest" for further, more detailed research...
 *
 *	This version of the script is intended for Oracle9i, which
 *	records TIME_WAITED_MICRO in micro-seconds (1/100,000ths of
 *	a second).
 *
 * Modifications:
 *	TGorman 02may04	corrected bug in LAG() OVER () clauses
 *	TGorman	10aug04	changed "deviation" column from some kind of
 *			weird "deviation from average" calculation to
 *			a more straight-forward percentage ratio
 *	TGorman	25aug04	use "ratio_to_report()" function instead
 *********************************************************************/
set echo off feedback off timing off pagesize 200 linesize 130
set trimout on trimspool on verify off recsep off
col sort0 noprint
col day format a6 heading "Day"
col hr format a6 heading "Hour"
col time_waited format 999,999,999,990.00 heading "Secs Waited"

accept V_INSTANCE prompt "Please enter the ORACLE_SID value: "
accept V_BEGIN_DATE prompt "Please enter the report begin date: "
accept V_END_DATE prompt "Please enter the report end date:"
prompt
prompt
prompt Some useful database statistics to search upon:
col name format a60 heading "Name"
select  chr(9)||stat_name name
from	v$sys_time_model
order by 1;
accept V_STATNAME prompt "What statistic do you want to analyze? "

col spoolname new_value V_SPOOLNAME noprint
select    replace(replace(replace(replace(lower('&&V_STATNAME'),' ','_'),'(',''),')',''),'/','_') spoolname
from    dual;

spool sp_evtrends_&&V_SPOOLNAME
clear breaks computes
break on day skip 1 on report
col ratio format a60 heading "Percentage of total over all days"
col name format a30 heading "Statistic Name"
prompt
prompt Daily trends for "&&V_STATNAME"...
select	sort0,
	day,
	name,
	value,
	rpad('*', round((ratio_to_report(value) over (partition by name))*60, 0), '*') ratio
from	(select	sort0,
		day,
		name,
		sum(value)/100000 value
	 from	(select	to_char(ss.snap_time, 'YYYYMMDD') sort0,
			to_char(ss.snap_time, 'DD-MON') day,
			s.snap_id,
			stm.stat_name name,
			nvl(decode(greatest(s.value, nvl(lag(s.value) over (partition by s.dbid, s.instance_number, s.stat_id order by s.snap_id),0)),
				   s.value, s.value - lag(s.value) over (partition by s.dbid, s.instance_number, s.stat_id order by s.snap_id),
					  s.value), 0) value
		 from	stats$sys_time_model			s,
			stats$snapshot				ss,
			v$sys_time_model			stm,
			(select distinct
				dbid,
				instance_number
			 from	stats$database_instance
			 where	instance_name = '&&V_INSTANCE')	i
		 where	ss.dbid = i.dbid
		 and	ss.instance_number = i.instance_number
		 and	ss.snap_time between trunc(&&V_BEGIN_DATE) and trunc(&&V_END_DATE)
		 and	s.snap_id = ss.snap_id
		 and	s.dbid = ss.dbid
		 and	s.instance_number = ss.instance_number
		 and	s.stat_id=stm.stat_id
		 and	stm.stat_name like '%'||'&&V_STATNAME'||'%')
	 group by sort0,
		  day,
		  name)
order by sort0, name;

clear breaks computes
break on day skip 1 on hr on report
col ratio format a60 heading "Percentage of total over all hours for each day"
prompt
prompt Daily/hourly trends for "&&V_STATNAME"...
select	sort0,
	day,
	hr,
	name,
	value,
	rpad('*', round((ratio_to_report(value) over (partition by day, name))*60, 0), '*') ratio
from	(select	sort0,
		day,
		hr,
		name,
		sum(value)/100000 value
	 from	(select	to_char(ss.snap_time, 'YYYYMMDDHH24') sort0,
			to_char(ss.snap_time, 'DD-MON') day,
			to_char(ss.snap_time, 'HH24')||':00' hr,
			s.snap_id,
			stm.stat_name name,
			nvl(decode(greatest(s.value, nvl(lag(s.value) over (partition by s.dbid, s.instance_number, s.stat_id order by s.snap_id),0)),
				   s.value, s.value - lag(s.value) over (partition by s.dbid, s.instance_number, s.stat_id order by s.snap_id),
					  s.value), 0) value
		 from	stats$sys_time_model			s,
			stats$snapshot				ss,
			v$sys_time_model			stm,
			(select distinct
				dbid,
				instance_number
			 from	stats$database_instance
			 where	instance_name = '&&V_INSTANCE')	i
		 where	ss.dbid = i.dbid
		 and	ss.instance_number = i.instance_number
		 and	ss.snap_time between trunc(&&V_BEGIN_DATE) and trunc(&&V_END_DATE)
		 and	s.snap_id = ss.snap_id
		 and	s.dbid = ss.dbid
		 and	s.instance_number = ss.instance_number
		 and	stm.stat_id=s.stat_id
		 and	stm.stat_name like '%'||'&&V_STATNAME'||'%')
	 group by sort0,
		  day,
		  hr,
		  name)
order by sort0, name;
spool off
set verify on recsep each