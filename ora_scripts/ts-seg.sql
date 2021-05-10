REM ------------------------------------------------------------------------------------------------
REM $Id: ts-seg.sql,v 1.3 2003/03/22 00:54:09 hien Exp $
REM Author     : hien
REM #DESC      : Show detailed information for all segments inside a given tablespace
REM Usage      : Input parameter: tablespace_name
REM Description: 
REM ------------------------------------------------------------------------------------------------

REM Criptic column headings -
REM A: Largest free space chunk will not accomodate largest next extent 
REM B: Number of extents is more than 90% of max extents
REM C: Number of extents is more than 1024
REM
REM PI     : pctincrease 
REM Pct TS : Space used as percent of total tablespace allocation
REM Fl Ct  : Number of datafiles occupied by the segment
REM Degr   : Degree of parallelism
REM Cach   : Whether table is cached
REM IT     : initrans
REM PctFr  : pctfree
REM PctUs  : pctused
REM Flg    : Free List Groups
REM Fl     : Free Lists
REM Ch     : Whether table has chained rows
REM BL     : Index B-Tree Level

@plusenv
undef tsname

accept 	 tsname  prompt 'Enter Tablespace Name: '

col tsname	format a24		head 'Tablespace Name'
col alloc	format a06		head ' Alloc|Tot MB'
col tfree	format a05		head 'Total| Free|   MB'
col mfree	format 99999.9		head 'Largest|Free MB'
col owner	format a07		head 'Seg|Owner'		trunc
col sgname	format a38		head 'Segment Name'		trunc
col ABC 	format a03		head 'ABC'
col sgtype	format a01		head 'T'			trunc
col tspct	format a06	     	head 'Pct TS'
col pi 		format a02		head 'PI'
col flgfl 	format a03		head 'Flg|Fl'
col initMB 	format a04		head 'Init| Ext|  MB'
col nextMB 	format 9999.9		head 'Next|ExtMB'
col totMB 	format a06		head ' Total|UsedMB'
col fcount 	format a02		head 'Fl|Ct'
col fc 		format a02		head 'Fl|Ct'
col totx 	format a05		head 'Total|  Ext'
col maxx 	format a04		head ' Max| Ext'
col bp		format a01		head 'B|P'
col pfpu	format a05 		head 'PctFr|PctUs'
col dc		format a04		head 'Degr|Cach' 		trunc
col initrans	format a01		head 'I|T'
col lastana	format a04		head 'Last|Ana'
col chblvl	format a02		head 'Ch|BL'

break on alloc on fc on tfree on mfree on owner

SELECT	/*+ ORDERED */
	 lpad(df.talloc,6)						alloc
	,lpad(df.fcount,2)						fc
	,lpad(fs.tfree,5)						tfree
	,fs.mfree							mfree
	,decode(sign(fs.mfree - (sg.next_extent/(1024*1024))),-1,'X','-')||
  	 decode(sign(90 - round(sg.extents/decode(sg.max_extents,0,9999,sg.max_extents)*100)),-1,'X','-')||
  	 decode(sign(1024 - sg.extents),-1,'X','-') 			ABC
	,sg.segment_type						sgtype
	,decode(substr(sg.buffer_pool,1,1),'D',' ','K','K','R','R',' ') bp
	,sg.owner||'.'||sg.segment_name					sgname
	,lpad(round(sg.bytes/(1024*1024)),6)				totMB
	,lpad(round((100*sg.bytes/(1024*1024)/df.talloc),2),6)		tspct
	,lpad(sg.initial_extent/(1024*1024),4)				initMB
	,round((sg.next_extent/(1024*1024)),1)				nextMB
	,lpad(decode(sg.pct_increase,100,99,sg.pct_increase),2,' ')	pi
	,lpad(least(sg.extents,99999),5)  				totx
	,lpad(least(sg.max_extents,9999),4)				maxx 
	,lpad(ex.fcount,2,' ') 						fcount
        ,decode(sg.segment_type,'TABLE',lpad(tb.degree,2,' ')||'-'||substr(tb.cache,5,1)
		               ,'INDEX',lpad(ix.degree,2,' ')||' '
			       ,' ')					dc
        ,decode(sg.segment_type,'TABLE',lpad(tb.ini_trans,1,' ')
		               ,'INDEX',lpad(ix.ini_trans,1,' ')
		               ,' ')					initrans
      	,decode(sg.segment_type,'TABLE',lpad(tb.pct_free,2,' ')||'-'||lpad(tb.pct_used,2,' ') 
	                       ,'INDEX',lpad(ix.pct_free,2,' ')
	                       ,' ')					pfpu
	,sg.freelist_groups||'-'||sg.freelists				flgfl
        ,decode(sg.segment_type,'TABLE',decode(sign(1-tb.chain_cnt),-1,'x',' ')
		               ,'INDEX',blevel
		               ,' ')					chblvl
        ,decode(sg.segment_type,'TABLE',to_char(tb.last_analyzed,'MMDD')
		               ,'INDEX',to_char(ix.last_analyzed,'MMDD')
		               ,' ')					lastana
FROM	
	 dba_segments				sg
	,dba_tables				tb
	,dba_indexes				ix
	,(SELECT	 tablespace_name		tsname
			,owner				segowner
			,segment_name			segname
			,segment_type			segtype
			,count(distinct(file_id)) 	fcount
	  FROM		 dba_extents
	  WHERE		 tablespace_name		= upper('&&tsname')
	  GROUP BY	 tablespace_name
			,owner
			,segment_name
			,segment_type
	 )					ex
	,(SELECT	 tablespace_name		tsname
			,sum(bytes)/(1024*1024)		talloc
			,count(file_id) 		fcount
	  FROM		 dba_data_files
	  WHERE		 tablespace_name		= upper('&&tsname')
	  GROUP BY	 tablespace_name
	 )					df
	,(SELECT	 tablespace_name		tsname
			,sum(bytes)/(1024*1024)		tfree
			,max(bytes)/(1024*1024)		mfree
	  FROM		 dba_free_space
	  WHERE		 tablespace_name		= upper('&&tsname')
	  GROUP BY	 tablespace_name
	 )					fs
WHERE	 
	 sg.tablespace_name = upper('&&tsname')
AND    	 sg.tablespace_name = ex.tsname
AND	 sg.owner           = ex.segowner
AND	 sg.segment_name    = ex.segname
AND	 sg.segment_type    = ex.segtype
AND	 sg.owner	    = tb.owner (+)
AND	 sg.segment_name    = tb.table_name (+)
AND	 sg.tablespace_name = tb.tablespace_name (+)
AND	 sg.owner	    = ix.owner (+)
AND	 sg.segment_name    = ix.index_name (+)
AND	 sg.tablespace_name = ix.tablespace_name (+)
ORDER BY 
	 tspct desc
	,sg.owner 
	,sg.segment_name
;

undef tsname
