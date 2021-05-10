REM ------------------------------------------------------------------------------------------------
REM $Id: ts-sum.sql,v 1.2 2003/03/22 00:54:10 hien Exp $
REM Author     : hien
REM #DESC      : Summary info for all tablespaces (allocation, free space, etc...) including TEMP 
REM Usage      : 
REM Description: 
REM ------------------------------------------------------------------------------------------------
REM Criptic column headings -
REM T: 'T' for temporary tablespace
REM S: '?' if tablespace is NOT online
REM E: 'L' for locally managed tablespace
REM A: 'U' for uniform extent allocation
REM L: 'N' for nologging
REM
REM U: 'x' if % used > 90
REM F: 'x' if largest free chunk cannot accomodate largest next 
REM
REM Fl Ct  : Number of datafiles in the tablespace
REM Seg Cnt: Number of segments in the tablespace
REM PI     : pctincrease 
REM Min Ext Len: Minimum extent size
REM Mn Ex  : Minimum extents (tablespace default storage parameters)

@plusenv

col flgs	format a05		head 'TSEAL'
col fflg	format a01		head 'F'
col uflg	format a01		head 'U'
col ts#		format 999		head 'TS#'
col tsname	format a30		head 'Tablespace Name'
col alloc 	format 9,999,999	head 'Allocated|MB'
col freesp 	format 999,999		head 'Tot Free|MB'
col mfree	format 99999		head 'Max|Free|MB'
col lfree	format 99999		head 'Smlst|Free|MB'
col pctu	format 999.9		head 'Pct|Usd'
col mnext	format 999.9		head 'Max|Next|MB'
col fcount	format 99		head 'Fl|Ct'
col init	format 999.9		head 'Def|Init|MB'
col next	format 999.9		head 'Def|Next|MB'
col minext	format a02		head 'Mn|Ex'
col maxext	format a04		head 'Max|Exts'
col minextl	format 999.9		head 'Min|Ext|Len'
col pcti	format a02		head 'PI'
col segcount	format 999		head 'Seg|Cnt'
col fpcs	format 9999		head 'Free|Pcs'

break on report
compute sum of alloc 	on report
compute sum of freesp 	on report

SELECT 	 /*+ ORDERED */
	 decode(ts.contents,'TEMPORARY','T',' ')	||
	 decode(ts.status,'ONLINE',' ' ,'?')		||
	 decode(ts.extent_management,'LOCAL','L',' ')	||
	 decode(ts.allocation_type,'UNIFORM','U',' ')	||
	 decode(ts.logging,'NOLOGGING','N')		flgs
	,ts#						ts#
	,ts.tablespace_name				tsname
	,100*(df.talloc-fs.fspace)/df.talloc		pctu
	,decode(sign((100*nvl(fs.fspace,0)/df.talloc) - 10),-1,'x',' ')	uflg
	,decode(ts.contents,'TEMPORARY',tf.talloc,df.talloc)		alloc
	,fs.fspace					freesp
	,decode(ts.contents,'TEMPORARY',tf.fcount,df.fcount)		fcount
	,seg.segcount					segcount
	,fs.fpcs					fpcs
	,fs.mfree					mfree
	,decode(sign(fs.mfree - seg.mnext),-1,'x',' ') 	fflg				
	,seg.mnext					mnext
	,fs.lfree					lfree
	,ts.initial_extent/(1024*1024)			init
	,ts.next_extent/(1024*1024)			next
	,lpad(ts.pct_increase,2,' ')			pcti
	,ts.min_extlen/(1024*1024)			minextl
	,lpad(ts.min_extents,2,' ')			minext
	,lpad(least(ts.max_extents,9999),4,' ')		maxext
FROM 	
	 dba_tablespaces			ts
	,sys.ts$				sts
	,(SELECT 	 tablespace_name 			tsname
	 		,sum(bytes)/(1024*1024) 		fspace 
	 		,max(bytes)/(1024*1024) 		mfree 
	 		,min(bytes)/(1024*1024) 		lfree
	 		,count(*)				fpcs
	  FROM 		 dba_free_space 
	  GROUP BY 	 tablespace_name
	 ) 					fs
	,(SELECT 	 tablespace_name 			tsname
	 		,max(next_extent)/(1024*1024) 		mnext
			,count(*)				segcount
	  FROM 		 dba_segments
	  GROUP BY 	 tablespace_name
	 ) 					seg
	,(SELECT	 tablespace_name			tsname
			,sum(bytes)/(1024*1024)			talloc
			,count(*)				fcount
	  FROM		 dba_data_files
	  GROUP BY	 tablespace_name
	 )					df
	,(SELECT	 tablespace_name			tsname
			,sum(bytes)/(1024*1024)			talloc
			,count(*)				fcount
	  FROM	 	 dba_temp_files
	  GROUP BY	 tablespace_name
	 )					tf
WHERE	 
     	 ts.tablespace_name		= df.tsname	(+)
AND  	 ts.tablespace_name		= sts.name
AND	 ts.tablespace_name		= tf.tsname	(+)
AND	 df.tsname			= fs.tsname 	(+)
AND	 df.tsname			= seg.tsname 	(+)
ORDER BY 
	 tsname
;
