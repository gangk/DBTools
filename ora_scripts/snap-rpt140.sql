set echo 	off
set feedback 	off
set termout	off

col rpt_time	new_value xrpt_time
col spool_time	new_value xspool_time
col spool_date	new_value xspool_date
col db_uptime	new_value xdb_uptime
col instance	new_value xinstance
col host	new_value xhost

SELECT 	 
	 to_char(sysdate,'YY/MM/DD-HH24:MI') 		rpt_time 
	,to_char(sysdate,'YYMMDD:HH24MI') 		spool_time
	,to_char(sysdate,'YYMMDD') 			spool_date
	,to_char(startup_time,'YY/MM/DD-HH24:MI') 	db_uptime 
	,substr(instance_name,1,8) 			instance
	,decode(instr(host_name,'.',1),0,host_name,substr(host_name,1,instr(host_name,'.',1)-1)) 	host
FROM		
	 dual
	,v$instance
;

ttitle 		center xinstance '/' xhost skip 1 -
		left 'DB Startup Time:' xdb_uptime center '&1' right 'Report Time:' xrpt_time	skip 2 
rem right 'Page '	format 999 sql.pno skip 1

set linesize 	140
set pagesize	1000
set verify 	off
set head	off
set termout	on

select ' ' from dual;
ttitle		off
undef		1
set head 	on
