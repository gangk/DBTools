prompt
prompt
prompt === sort users (snap-sort-users.sql) ===;

col hash      	format 9999999999
col idlm   	format 99999		head 'Min|Idle'
col logontm   	format a11		head 'Logon|Time'
col mach	format a14 		head 'Machine'		trunc
col module    	format a22					trunc
col orauser    	format a07					trunc
col osid 	format a7 					trunc
col owner 	format a12	
col ser      	format 99999
col sid      	format 9999
col sseg	format a10
col su_hash   	format 9999999999
col svr   	format a1 		head 'S'
col segmb 	format 99999
col totmb 	format 99999
col usedmb 	format 99999
col totx 	format 9999
col tsname 	format a10

break on tsname on sid on ser on orauser on osid on mach on module on svr on logontm on idlm on hash on su_hash

SELECT 	 /*+ RULE */
	 su.tablespace						tsname
	,se.sid							sid
	,se.serial#  						ser
	,se.username 						orauser
	,se.osuser 						osid
	,substr(se.machine,1,instr(se.machine,'.')-1)       	mach
	,se.module  						module
	,decode(se.server,'DEDICATED','D',' ')   		svr
        ,to_char(se.logon_time,'MMDDYY HH24MI')			logontm
	,se.last_call_et/60     				idlm
	,se.sql_hash_value  					hash
	,su.sqlhash						su_hash
	,su.segfile#||'.'||su.segblk#				sseg
	,su.blocks*bs.blksize/(1024*1024)			usedmb
FROM	 v$session	se
	,(SELECT value blksize   from v$parameter where name='db_block_size') bs
        ,v$sort_usage	su
WHERE	 su.session_addr 	= se.saddr
ORDER BY su.tablespace
	,se.sid
;
