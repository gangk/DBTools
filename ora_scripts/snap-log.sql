REM ------------------------------------------------------------------------------------------------
REM $Id: snap-log.sql,v 1.1 2002/03/14 00:25:41 hien Exp $
REM Author     : hien
REM #DESC      : Show snapshot log information given a master table name pattern
REM Usage      : Input parameter: master_table_pattern
REM Description: 
REM ------------------------------------------------------------------------------------------------

@plusenv
undef master_table_pattern

col owner	format a7	head 'Owner'
col master	format a30	head 'Master Table'
col snid	format 999999	head 'Snap|id'
col ltable	format a30	head 'Snapshot Log'
col sizem       format 999   	head 'size|MB'
col ext         format 999      head 'Ext'
col tsname	format a17	trunc
col PR		format a2	head 'PR'
col curr	format a09	head 'Latest|Refresh'
col delaym	format 999	head 'Delay|Min'

break on owner on master on ltable on PR on sizem on ext on tsname 

SELECT	 
         sl.log_owner 			owner
        ,sl.master 			master
	,sl.log_table			ltable
	,decode(sl.primary_key,'YES','x')||decode(sl.rowids,'YES','x')	PR
	,sg.bytes/(1024*1024)		sizem
	,sg.extents			ext
	,sg.tablespace_name		tsname
	,sl.snapshot_id 		snid
	,(sysdate - current_snapshots)*(24*60)		delaym
	,to_char(sl.current_snapshots,'MMDD HH24MI')	curr
FROM
	 dba_segments			sg
	,dba_snapshot_logs		sl
WHERE	 
         sl.log_owner           = sg.owner 
AND      sl.log_table           = sg.segment_name 
AND	 sl.master		like upper('&&master_table_pattern%')
ORDER BY sl.log_owner
        ,sl.master
        ,sl.log_table
        ,sl.snapshot_id
;
undef master_table_pattern
