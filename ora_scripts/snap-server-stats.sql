prompt
prompt
prompt === mts server stats (snap-server-stats.sql) ===;

col maxconn	format 99999	head 'Max|Connections'
col initcnt	format a7	head 'Init|Servers'
col maxcnt	format a7	head 'Max|Servers'
col hwm		format 99999	head 'HWM|Servers'
col startc	format 99999	head 'Started|Servers'
col termc	format 99999	head 'Terminated|Servers'

SELECT	 parm1.initcnt		initcnt
	,parm2.maxcnt		maxcnt
	,m.servers_started	startc
	,m.servers_terminated	termc
	,m.servers_highwater	hwm
	,m.maximum_connections	maxconn
FROM	 v$mts			m
	,(select value	initcnt from v$parameter where name = 'mts_servers') 	 parm1
	,(select value	maxcnt  from v$parameter where name = 'mts_max_servers') parm2
;
