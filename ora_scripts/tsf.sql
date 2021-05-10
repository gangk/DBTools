set pages 1000 lines 140
col flag	format a01		head 'F'
col tsname	format a30		head 'Tablespace Name'
col alloc 	format 999,999,999	head 'Allocated'
col freesp 	format 999,999,999	head 'Tot Free'
col largestf	format 99,999		head 'Largest|Free'
col pctu	format 999.9		head 'Pct|Usd'
break on report
compute sum of alloc 	on report
compute sum of freesp 	on report
select 	 
	 sum(df.bytes)/(1024*1024) 		alloc
	,decode(sign(90 - 100*(sum(df.bytes)/(1024*1024)-fs.fspace)/(sum(df.bytes)/(1024*1024))),-1,'x',' ') flag
	,df.tablespace_name			tsname
	,fs.fspace				freesp
	,fs.mspace				largestf
	,100*(sum(df.bytes)/(1024*1024)-fs.fspace)/(sum(df.bytes)/(1024*1024))		pctu
from 	 (select 	 tablespace_name 			tsname
	 		,sum(bytes)/(1024*1024) 		fspace 
	 		,max(bytes)/(1024*1024) 		mspace 
	  from 		 dba_free_space 
	  group by 	 tablespace_name
	 ) 					fs
	,dba_data_files				df
where	 df.tablespace_name			= fs.tsname (+)
group by df.tablespace_name
	,fs.mspace
	,fs.fspace
order by df.tablespace_name
;

SELECT 	 tablespace_name			tsname
	,sum(bytes)/(1024*1024)			alloc
FROM	 dba_temp_files
GROUP BY tablespace_name
;
