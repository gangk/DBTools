REM ------------------------------------------------------------------------------------------------
REM $Id: idx-info.sql,v 1.2 2002/04/01 22:04:24 hien Exp $
REM Author     : hien
REM #DESC      : Show all information related to an index such as stats, space, etc
REM Usage      : Input parameter: idx_owner & idx_name
REM Description: Everything you need to know about an index
REM ------------------------------------------------------------------------------------------------

@plusenv

undef idx_owner
undef idx_name
accept idx_owner	prompt 'Enter Index Owner: ' 
accept idx_name  	prompt 'Enter Index Name : ' 

col tsname 		head "Tablespace|Name" format a30
col sizem 		head "Size|in MB"	format 999990.99
col initkb 		head "Init|in KB"	format 999990
col nextkb 		head "Next|in KB"	format 999990
col sta				format a5	trunc
col pi 				format 99
col ext				format 99999
col mine 				format 9
col max 				format 990
col pf				format 99
col pu				format 99
col pfpu			format a5 	head "PctFr|PctUs"
col it				format 99
col fl 				format 9
col d 				format 99 
col cpos			format 99
col c				format a1 trunc
col comp			format a2 trunc
col n				format a1 
col ddefault				format a26 head "Data Default" trunc
col trname     		head "Trigger|Name" format a30 
col trtype     		head "Trig|Type" format a16
col trevent    		head "Trig|Event" format a26

col TABLE_NAME 		head "Table|Name" format a30 
col SEGMENT_NAME 		head "Segment|Name" format a30 
col bp 			head "Bfr|Pool"	format a4	trunc
col NUM_ROWS 		head "Number|of Rows" format 999999990 
col blk 			head "Blocks" format 99999990 
col eblk 			head "Empty|Blocks" format 9999990 
col AVG_SPACE 		head "Avg|Spc" format 9990 
col chain 			head "Ch|Rows|/100" format 99990 
col AVG_ROW_LEN 		head "Avg|RowL" format 99990 
col COLUMN_NAME  		head "Column|Name" format a30 
col NULLABLE 		head N format a1 trunc 
col NUM_DISTINCT 		head "Distinct|Values" format 999999990 
col DENSITY 			head "D" format 9 trunc
col INDEX_NAME 		head "Index|Name" format a30 
col UNIQUENESS 		head "Uni" format a3 trunc
col BLEV 			head "B|L" format 9 
col LEAF_BLOCKS 		head "Leaf|Blks" format 9999990 
col DISTINCT_KEYS 		head "Distinct|Keys" format 999999990 
col albpk 			head "AvgLeaf|Block|PerKey" format  999990
col adbpk 			head "AvgData|Block|PerKey" format  99999990
col CLUSTERING_FACTOR 	head "Clustering|Factor" format 999999990 
col COLUMN_POSITION 		head "Col|Pos" format 9 trunc
col col 			head "Column|Details" format a32 
col COLUMN_LENGTH 		head "Col|Len" format 990 
col last_ana 		head "Last|Analyzed" format a09
col samp_sz 			head "Samp|Size" format 999999
col nfb 			head "Num|FreeLst|Blks" format 999999
col asfb 			head "AvgSpc|FreeLst|Blks" format 9999
col hdrf 			head "Hdr|Fil" format 999
col hdrb 			head "Hdr|Blk" format 999999
col pctfl 			head "Pct|On|FL" format 999
col pctch 			head "Pct|Chn" format 999
col ustat			head 'U'	format a01	trunc


prompt ;
prompt ;
prompt -- LIKE OBJECTS --;
col owner	format a10
col object_name	format a30
col timestamp	format a19
col created	format a12
col last_ddl	format a12
col g		format a1
SELECT 	 owner
	,object_name
	,object_id
	,object_type
	,status
	,generated	g
	,timestamp
	,to_char(created,'YYMMDD HH24:MI') created
	,to_char(last_ddl_time,'YYMMDD HH24:MI') last_ddl
FROM 	 dba_objects
WHERE 	 object_name like upper('%&idx_name%')
ORDER BY object_name
	,object_type
;

prompt ;
prompt ;
prompt -- INDEX STATISTICS --;
SELECT	 index_name
	,to_char(last_analyzed,'MMDD HH24MI') 	last_ana
	,status						sta
	,sample_size 					samp_sz
	,pct_free 					pf
	,ini_trans 					it
	,to_number(decode(i.degree,null,0,'DEFAULT',0,i.degree))	d
	,uniqueness
	,compression					comp
	,blevel 					blev
 	,num_rows
	,leaf_blocks
	,distinct_keys
	,avg_leaf_blocks_per_key			albpk
	,avg_data_blocks_per_key			adbpk
	,clustering_factor
FROM 	 dba_indexes i
WHERE 	 i.index_name 	= upper('&&idx_name') 
AND 	 i.owner 	= upper(nvl('&&idx_owner',user)) 
ORDER BY i.index_name
;

prompt ;
prompt ;
prompt -- INDEX SPACE USAGE --;
break on report
compute sum of sizem on report
SELECT	 index_name
 	,s.buffer_pool					bp
	,s.tablespace_name				tsname
 	,s.blocks 					blk
	,round(s.bytes/(1024*1024),2) 			sizem
	,s.initial_extent/1024 initkb
	,s.next_extent/1024 nextkb
	,s.extents ext
        ,s.min_extents 					mine
	,decode(sign(999 - s.max_extents),-1,999,s.max_extents) max
	,s.pct_increase pi
	,s.freelists fl
	,s.header_file					hdrf
	,s.header_block					hdrb
FROM 	 dba_segments s 
	,dba_indexes i
WHERE 	 i.index_name 	= upper('&&idx_name') 
AND 	 i.owner 	= upper(nvl('&&idx_owner',user)) 
AND 	 i.owner 	= s.owner
AND 	 i.index_name = s.segment_name
ORDER BY i.index_name
;

prompt ;
prompt ;
prompt -- INDEX HWM --;
prompt ;

DECLARE
	tblks 	number;
	tbytes 	number;
	ublks	number;
	ubytes	number;
	luefid 	number;
	luebid	number;
	lub 	number;
BEGIN
	dbms_space.unused_space(upper('&&idx_owner'),upper('&&idx_name'),'INDEX',
				tblks,tbytes,ublks,ubytes,luefid,luebid,lub);
	dbms_output.put_line('Total Blocks      = '||tblks);
	dbms_output.put_line('Total Bytes       = '||tbytes);
	dbms_output.put_line('Total MB          = '||round(tbytes/(1024*1024),2));
	dbms_output.put_line('.');
	dbms_output.put_line('Unused Blocks     = '||ublks);
	dbms_output.put_line('Unused Bytes      = '||ubytes);
	dbms_output.put_line('Unused MB         = '||round(ubytes/(1024*1024),2));
	dbms_output.put_line('.');
	dbms_output.put_line('HWM MB            = '||round((tbytes - ubytes) / (1024*1024),2) );
	dbms_output.put_line('HWM Pct           = '||round((tbytes - ubytes) / tbytes * 100,2) );
END;
/

prompt ;
prompt ;
prompt -- INDEX COLUMNS --;
break on index_name 
SELECT   i.index_name
	,i.column_name
	,i.column_position	cpos
	,decode(t.DATA_TYPE, 
		'NUMBER',t.DATA_TYPE||'('|| 
         	decode(t.DATA_PRECISION, 
                null,t.DATA_LENGTH||')', 
                t.DATA_PRECISION||','||t.DATA_SCALE||')'), 
		'DATE',t.DATA_TYPE, 
		'LONG',t.DATA_TYPE, 
		'LONG RAW',t.DATA_TYPE, 
		'ROWID',t.DATA_TYPE, 
		'MLSLABEL',t.DATA_TYPE, 
		t.DATA_TYPE||'('||t.DATA_LENGTH||')') ||' '|| 
       		decode(t.nullable, 
              	'N','NOT NULL', 
    		'n','NOT NULL', 
              	NULL) 					col 
FROM 	 dba_ind_columns i
	,dba_tab_columns t 
WHERE 	 i.index_name 	= upper('&idx_name') 
AND 	 i.index_owner 	= upper(nvl('&&idx_owner',user)) 
AND 	 i.table_name 	= t.table_name  
AND 	 i.column_name 	= t.column_name 
ORDER BY index_name,column_position 
;
undef idx_owner
undef idx_name
