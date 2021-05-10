set lines 200
REM ------------------------------------------------------------------------------------------------
REM $Id: tab-info.sql,v 1.3 2002/04/02 00:11:38 hien Exp $
REM Author     : hien
REM #DESC      : Show all information related to a table such as stats, space, indexes, cons, etc
REM Usage      : Input parameter: tab_owner & tab_name
REM Description: Everything you need to know about a table
REM ------------------------------------------------------------------------------------------------
@plusenv

accept tab_owner	prompt 'Enter Table Owner: ' 
accept tab_name  	prompt 'Enter Table Name : ' 

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
col clen			format 9999	head 'Col|Len'
col descend			format a01	head "D"
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
col samp_sz 			head "Samp|Size" format 9999
col nfb 			head "Num|FreeLst|Blks" format 999999
col asfb 			head "AvgSpc|FreeLst|Blks" format 9999
col hdrf 			head "Hdr|Fil" format 999
col hdrb 			head "Hdr|Blk" format 999999
col pctfl 			head "Pct|On|FL" format 999
col pctch 			head "Pct|Chn" format 999
col ustat			head 'U'	format a01	trunc

prompt -- TABLE STATISTICS --;
SELECT 	 table_name
	,to_char(last_analyzed,'MMDD HH24MI') 		last_ana
	,sample_size 					samp_sz
	,user_stats					ustat
      	,lpad(t.pct_free,2,' ')||'-'||lpad(t.pct_used,2,' ') pfpu 					
        ,t.ini_trans 					it
        ,substr(t.cache,5,1) 				c
	,to_number(decode(t.degree,null,0,'DEFAULT',0,t.degree))	d
 	,num_rows
 	,t.blocks 					blk
 	,empty_blocks 					eblk
 	,avg_space
 	,avg_space_freelist_blocks			asfb
 	,num_freelist_blocks				nfb
 	,num_freelist_blocks*100/decode(blocks,0,1,blocks)			pctfl
 	,chain_cnt/100 					chain
	,chain_cnt*100/decode(num_rows,0,999999999,num_rows) pctch
 	,avg_row_len
FROM   	 dba_tables 					t
WHERE 	 t.owner 	= upper(nvl('&&tab_owner',user)) 
AND 	 table_name 	= upper('&&tab_name') 
;

prompt ;
prompt ;
prompt -- TABLE SPACE USAGE --;
SELECT 	 segment_name
 	,s.buffer_pool					bp
 	,s.tablespace_name				tsname
 	,s.blocks 					blk
 	,round(s.bytes/(1024*1024),2)			sizem
 	,s.initial_extent/1024 				initkb
 	,s.next_extent/1024 				nextkb
 	,s.pct_increase 				pi
        ,s.extents 					ext
        ,s.min_extents 					mine
        ,decode(sign(999 - s.max_extents),-1,999,s.max_extents) max
        ,s.freelists 					fl
	,s.header_file					hdrf
	,s.header_block					hdrb
FROM 	 dba_segments s
WHERE 	 s.owner = upper(nvl('&&tab_owner',user)) 
AND 	 segment_name = upper('&&tab_name') 
;

prompt ;
prompt ;
prompt -- TABLE HWM --;
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
	dbms_space.unused_space(upper('&&tab_owner'),upper('&&tab_name'),'TABLE',
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
prompt -- TABLE COLUMNS --;
col num_bckts    	format 9999	head 'Num|Buckets'
col samp_sz 			head "Samp|Size" format 99999999
SELECT	 column_name
	,to_char(c.last_analyzed,'MMDD HH24MI') 	last_ana
	,sample_size 					samp_sz
	,num_distinct
	,decode(c.DATA_TYPE, 
		'NUMBER',c.DATA_TYPE||'('|| 
         		decode(c.DATA_PRECISION, 
                	null,c.DATA_LENGTH||')', 
                	c.DATA_PRECISION||','||c.DATA_SCALE||')'), 
		'DATE',c.DATA_TYPE, 
		'LONG',c.DATA_TYPE, 
		'LONG RAW',c.DATA_TYPE, 
		'ROWID',c.DATA_TYPE, 
		'MLSLABEL',c.DATA_TYPE, 
		c.DATA_TYPE||'('||c.DATA_LENGTH||')') ||' '|| 
       		decode(c.nullable, 
              	'N','NOT NULL', 
              	'n','NOT NULL', 
        	NULL) 					col 
	,data_default					ddefault
	,c.num_nulls					num_nulls
	,c.num_buckets					num_bckts
FROM 	 dba_tab_columns c 
WHERE 	 table_name = upper('&&tab_name') 
AND 	 owner = upper(nvl('&&tab_owner',user)) 
ORDER BY column_id
;

prompt ;
prompt ;
prompt -- TABLE CONSTRAINTS --;
col tname	format a30	head 'Table Name'
col cname	format a30	head 'Const Name'
break on tname 
SELECT	 table_name		tname
	,constraint_type
	,constraint_name	cname
	,r_owner
	,r_constraint_name
FROM	 dba_constraints
WHERE	 table_name = upper('&&tab_name')
AND 	 owner = upper('&&tab_owner') 
;

prompt ;
prompt ;
prompt -- PK TO FK COLUMN MAPPING --;
col fktab	format a30	head 'FK|Table Name'
col fkcons	format a30	head 'FK|Const Name'
col fkcol	format a29	head 'FK|Column Name'
col pktab	format a18	head 'PK|Table Name' trunc
col pkcons	format a29	head 'PK|Const Name'
col pkpos	noprint
col pkcol 	format a30	head 'PK|Col Name'

break on pktab on pkcons on fktab on fkcons

SELECT 	 
	 a.table_name		pktab
	,a.constraint_name	pkcons
	,b.table_name		fktab
	,b.constraint_name	fkcons
	--,d.position		fkpos
	,d.column_name		fkcol
FROM     dba_constraints 	a 
	,dba_constraints 	b
	,dba_cons_columns 	d
WHERE    b.constraint_type	= 'R'
  AND    a.constraint_type 	= 'P'
  AND    b.r_owner (+)		= a.owner
  AND    b.r_constraint_name (+)	= a.constraint_name
  AND    b.constraint_name	= d.constraint_name
  AND    b.owner		= d.owner
  AND    b.table_name		= d.table_name
  AND	 a.owner		= upper(nvl('&&tab_owner',user)) 
  AND	 a.table_name		= upper('&&tab_name') 
ORDER BY a.table_name
	,a.constraint_name
	,b.table_name
	,b.constraint_name
	,d.position
;

prompt ;
prompt ;
prompt -- FK TO PK COLUMN MAPPING --;
col fktab	format a18	head 'FK|Table Name' trunc
col fkcons	format a30	head 'FK|Cons Name'
col pktab	format a30	head 'PK|Table Name'
col pkcons	format a29	head 'PK|Cons Name'
col pkcol 	format a29	head 'PK|Col Name'

break on fktab on fkcons on pktab on pkcons

SELECT 	 
	 fk.table_name   	fktab
	,fk.constraint_name   	fkcons
	,pk.table_name   	pktab
	,pk.constraint_name   	pkcons
	,pkc.column_name	pkcol
FROM     dba_constraints pk
	,dba_constraints fk
	,dba_cons_columns pkc
WHERE    fk.r_constraint_name 	= pk.constraint_name 
  AND    fk.r_owner		= pk.owner
  AND    pk.constraint_type 	= 'P'
  AND    fk.constraint_type 	= 'R'
  AND	 pk.constraint_name	= pkc.constraint_name
  AND	 pk.owner		= pkc.owner
  AND	 fk.owner		= upper(nvl('&&tab_owner',user)) 
  AND	 fk.table_name		= upper('&tab_name') 
ORDER BY fk.constraint_name
	,pk.table_name
	,pk.constraint_name
	,pkc.position
;

prompt ;
prompt ;
prompt -- TABLE TRIGGERS --;
break on table_name
SELECT 	 table_name
	,trigger_name					trname
      	,trigger_type					trtype
        ,triggering_event				trevent
        ,status						sta
FROM   	 dba_triggers
WHERE 	 table_owner = upper(nvl('&&tab_owner',user)) 
AND 	 table_name = upper('&&tab_name') 
ORDER BY trigger_name
;

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
WHERE 	 object_name like upper('%&tab_name%')
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
WHERE 	 i.table_name = upper('&&tab_name') 
AND 	 i.table_owner = upper(nvl('&&tab_owner',user)) 
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
WHERE 	 i.table_name = upper('&&tab_name') 
AND 	 i.owner = s.owner
AND 	 i.index_name = s.segment_name
AND 	 i.table_owner = upper(nvl('&&tab_owner',user)) 
ORDER BY i.index_name
;

prompt ;
prompt ;
prompt -- INDEX COLUMNS --;
break on index_name 
SELECT  
	 i.index_name
	,i.column_position			cpos
	,i.column_name
	,decode(i.descend,'DESC','x',' ')	descend
	,i.column_length			clen
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
              	NULL) 				col 
FROM 	 dba_ind_columns i
	,dba_tab_columns t 
WHERE 	 i.table_owner 	= upper(nvl('&&tab_owner',user)) 
AND   	 i.table_name 	= upper('&tab_name') 
AND 	 i.table_name 	= t.table_name  (+)
AND 	 i.column_name 	= t.column_name (+)
ORDER BY index_name
	,column_position 
;
undef tab_owner
undef tab_name
