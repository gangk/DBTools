REM --------------------------------------------------------------------------------------------------
REM Author: Riyaj Shamsudeen @OraInternals, LLC
REM         www.orainternals.com
REM  
REM Functionality: This script is to print top ten sessions by logical reads, physical reads, parse calls, redo size and cpu used.
REM Uses Rank to find rank of a session and also shows its rank for other metrics.
REM
REM Provides high level overview of all sessions in an instance.
REM
REM Note : 1. This SQL can be modified to use GV$ views, but beware that can saturate the cluster interconnect. 
REM        2. In 32 bit software, numbers wraparound and so, output can slightly mislead.
REM        3. Keep window 160 columns for better visibility.
REM
REM Exectution type: Just execute from sqlplus or any other tool. 
REM
REM By default prints "Top Ten sessions by Logical reads"
REM 
REM No implied or explicit warranty
REM
REM Please send me an email to rshamsud@orainternals.com, if you enhance this script :-)
REM --------------------------------------------------------------------------------------------------  
prompt Top ten sessions by logical reads:
prompt =================================


set lines 160 pages 40
col sid format 99999999
col value format 9,999,999,999,999,999,999
with lreads as (
	select  ses.sid, sum(ses.value) lrvalue from 
	v$sesstat ses , v$statname stat
	where stat.statistic#=ses.statistic# and
	stat.name in ('db block gets','consistent gets')
	--statistics# in  (40,41)
	group by ses.sid
	) ,
      preads as (
	select  ses.sid, sum(ses.value) prvalue from 
	v$sesstat ses , v$statname stat
	where stat.statistic#=ses.statistic# and
	stat.name in ('physical reads','physical reads direct')
	--statistics# in  (40,41)
	group by ses.sid),
      prsreads as (
	select  ses.sid, sum(ses.value) prsvalue from 
	v$sesstat ses , v$statname stat
	where stat.statistic#=ses.statistic# and	
	stat.name in ('parse count (total)','parse count (total)')
	--statistics# in  (40,41)
	group by ses.sid), 
      redosize as (
	select  ses.sid, sum(ses.value) redovalue from
	v$sesstat ses , v$statname stat
	where stat.statistic#=ses.statistic# and
	stat.name in ('redo size')
	--statistics# in  (40,41)
	group by ses.sid
     	), 
      cpuused as (
	select  ses.sid, ses.value cpuvalue from
	v$sesstat ses , v$statname stat
	where stat.statistic#=ses.statistic# and
	stat.name in ('CPU used by this session')
	--statistics# in  (40,41)
	)
select * from (
	select lreads.sid, 
		lreads.lrvalue,rank () over (order by lrvalue desc) lrrank,
		preads.prvalue,rank () over (order by prvalue desc) prrank,
		prsreads.prsvalue,rank () over (order by prsvalue desc) prsrank,
		redosize.redovalue,rank () over (order by redovalue desc) redorank,
		cpuused.cpuvalue,rank () over (order by cpuvalue desc) cpurank
	from 
	   lreads, preads, prsreads, redosize, cpuused
	where lreads.sid=preads.sid and
	      preads.sid = prsreads.sid and
  	     lreads.sid =prsreads.sid and
	     lreads.sid =redosize.sid and
	     lreads.sid=cpuused.sid
 ) 
where lrrank < 11 or prrank <11 or prsrank <11 or redorank <11 or cpurank <11
order by lrrank
/
