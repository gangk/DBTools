@parm recover

col btime	format a10
col etime	format a10
col fbdata	format 999,999
col dbdata	format 999,999
col rddata	format 999,999
col est_mb	format 999,999
col f		format a01
SELECT 	 to_char(begin_time,'MMDD HH24:MI')	btime
	,to_char(end_time,'MMDD HH24:MI')	etime
	,flashback_data/(1024*1024)		fbdata
	,decode(sign(r.recovsz-flashback_data),-1,'*','') f
	,db_data/(1024*1024)			dbdata
	,redo_data/(1024*1024)			rddata
	,estimated_flashback_size/(1024*1024)	est_mb
FROM 	 v$flashback_database_stat
	,(select value recovsz from v$parameter where name='db_recovery_file_dest_size') r
order by begin_time
;
col dbname	format a08
col dbrole	format a07
col flb_on	format a06
col alloc_mb	format 999,999
col est_mb	format 999,999
col oldest_scn 	format 9999999999999	head '*Oldest SCN*'
col oldest_time format a16	head '*Oldest Time*'
col curr_min 	format 999	head '*CurrMin*'
SELECT 	 d.name			dbname
	,d.database_role	dbrole
	,d.flashback_on		flb_on
	,to_char(sysdate,'YYYY-MM-DD HH24:MI') 			curr_time
	,to_char(f.oldest_flashback_time, 'YYYY-MM-DD HH24:MI') oldest_time
	,f.oldest_flashback_scn					oldest_scn
	,round(f.flashback_size/(1024*1024),0)			alloc_mb
	,round(f.estimated_flashback_size/(1024*1024),0)	est_mb
	,round((sysdate - f.oldest_flashback_time)*24*60,0) 	curr_min
	,f.retention_target 					tgt_min
FROM 	 v$database d
	,V$FLASHBACK_DATABASE_LOG f
;
