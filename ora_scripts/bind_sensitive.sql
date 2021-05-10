@plusenv
col apwpx 		format 99999 		head 'AppW|PerX'
col bgpx 		format 999999999	head 'BGets|PerX'
col conw		format 9999999		head 'Conw|PerX'
col cpx 		format 99999.999 	head 'CPUms|PerX'
col drpx 		format 999999 		head 'DReads|PerX'
col elpx 		format 999999.999 	head 'Elapms|PerX'
col exec		format 9999999999	head 'Execs'
col iowpx 		format 999999.999 	head 'IOWms|PerX'
col latime		format a11		head 'Last Active'
col lltime		format a09		head 'Last Load'
col maxsnapid		format 999999		head 'Max|SnapId'
col m			format a01	trunc
col minsnapid		format 999999		head 'Min|SnapId'
col module		format a14	trunc	head 'Module'
col o			format a01		head 'O'		trunc
col opt_mode		format a04	trunc	head 'Opt|Mode'		trunc
col parse_usr		format a08		head 'ParsUsr' 		trunc
col phashp		format a12	head 'PlanHash   P'
col rwpx 		format 99999		head 'RwsP|PerX'
col s_cn		format a04		head 'S Cn'		trunc
col sql_id		format a14		head 'SQL Id'
col sqltext		format a14	trunc	head 'Sql Text'
col ue			format 999
col cpct		format 999		head 'CPU|Pct'		trunc
col btime		format a11		head 'Begin Time'

break on parse_usr

select 	 parsing_schema_name	parse_usr
	,sql_id
	,substr(object_status,1,1)||lpad(child_number,3,' ')		s_cn
	,is_bind_sensitive||is_bind_aware||is_shareable		pas
	--,optimizer_mode		m
	--,is_obsolete		o
	,lpad(plan_hash_value,10,' ')||' '||decode(sql_profile,null,' ','P')	phashp
	--,to_char(to_date(last_load_time,'YYYY-MM-DD/HH24:MI:SS'),'MMDD HH24MI')	lltime
	,to_char(last_active_time,'MMDD HH24MISS')    			latime
	--,users_executing	ue
	,decode(executions,0,1,executions)				exec
       	,cpu_time/decode(executions,0,1,executions)/1000		cpx
	,elapsed_time/decode(executions,0,1,executions)/1000		elpx
	,(cpu_time/elapsed_time)*100					cpct
       	,buffer_gets/decode(executions,0,1,executions) 			bgpx
	,user_io_wait_time/decode(executions,0,1,executions)/1000	iowpx
	--,disk_reads/decode(executions,0,1,executions)			drpx
	,application_wait_time/decode(executions,0,1,executions)	apwpx
	,concurrency_wait_time/decode(executions,0,1,executions)	conw
       	,rows_processed/decode(executions,0,1,executions)		rwpx
	,module 							module
	,replace(sql_text,chr(13))					sqltext
from 	 v$sql	
where	 is_bind_sensitive ='Y'
and	 last_active_time > sysdate-1
and	 parsing_schema_name not in ('SYS')
and	 executions >1
order by parsing_schema_name, last_active_time
;
