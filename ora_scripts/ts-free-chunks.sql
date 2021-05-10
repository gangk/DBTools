REM ------------------------------------------------------------------------------------------------
REM $Id: ts-free-chunks.sql,v 1.1 2002/03/14 20:00:02 hien Exp $
REM Author     : hien
REM #DESC      : Show tablespace free chunks by size
REM Usage      : Input parameter: tablespace_name
REM Description: 
REM ------------------------------------------------------------------------------------------------

@plusenv
undef tsname
accept tsname		prompt 'Enter Tablespace Name: '

col tsname     	form       a30 head 'Tablespace Name' 
col nextmb	form	999.99 head 'Next MB'
col blocks	form   9999990 head 'Size|Blocks'       
col pieces	form	  9999 head 'Pieces'
col afree	form   9999.99 head 'Avg|FreeMB'       
col tfree	form  99999.99 head 'Tot|FreeMB'       
col sfree	form   9999.99 head 'Smlest|FreeMB'       
col lfree	form   9999.99 head 'Lrgest|FreeMB'       
col sgtype	form	   a03 head 'Seg|Typ' 		trunc
col segment     form       a10 head 'Seg|Name'   
col range	form	   a12 head 'Chunk Size'
col seq		noprint

break on report on tsname on nextmb
compute sum of pieces on report
compute sum of tfree on report

SELECT	 
   	 fs.tablespace_name	tsname
	,round(ts.next_extent/(1024*1024),2)	nextmb
	,0			seq
	,'00   - 128K'		range
  	,count(*)		pieces
  	,avg(fs.bytes)/(1024*1024)	afree
  	,min(fs.bytes)/(1024*1024)	sfree
  	,max(fs.bytes)/(1024*1024)	lfree
  	,sum(fs.bytes)/(1024*1024)	tfree
FROM	 dba_tablespaces	ts
      	,dba_free_space		fs
WHERE	 fs.tablespace_name 	= upper('&&tsname')
AND	 fs.tablespace_name	= ts.tablespace_name
AND	 fs.bytes/1024		between		00 and 128
GROUP BY fs.tablespace_name
	,ts.next_extent
UNION
SELECT	 
   	 fs.tablespace_name	tsname
	,round(ts.next_extent/(1024*1024),2)	nextmb
	,1			seq
	,'128K+-  04M'		range
  	,count(*)		pieces
  	,avg(fs.bytes)/(1024*1024)	afree
  	,min(fs.bytes)/(1024*1024)	sfree
  	,max(fs.bytes)/(1024*1024)	lfree
  	,sum(fs.bytes)/(1024*1024)	tfree
FROM	 dba_tablespaces	ts
      	,dba_free_space		fs
WHERE	 fs.tablespace_name 	= upper('&&tsname')
AND	 fs.tablespace_name	= ts.tablespace_name
AND	 fs.bytes/1024		between		128.0001 and 4096
GROUP BY fs.tablespace_name
	,ts.next_extent
UNION
SELECT	 
   	 fs.tablespace_name	tsname
	,round(ts.next_extent/(1024*1024),2)	nextmb
	,2			seq
	,'04+  -  16M'		range
  	,count(*)		pieces
  	,avg(fs.bytes)/(1024*1024)	afree
  	,min(fs.bytes)/(1024*1024)	sfree
  	,max(fs.bytes)/(1024*1024)	lfree
  	,sum(fs.bytes)/(1024*1024)	tfree
FROM	 dba_tablespaces	ts
      	,dba_free_space		fs
WHERE	 fs.tablespace_name 	= upper('&&tsname')
AND	 fs.tablespace_name	= ts.tablespace_name
AND	 fs.bytes/(1024*1024)	between		04.0001 and 16
GROUP BY fs.tablespace_name
	,ts.next_extent
UNION
SELECT	 
   	 fs.tablespace_name	tsname
	,round(ts.next_extent/(1024*1024),2)	nextmb
	,3			seq
	,'16+  -  32M'		range
  	,count(*)		pieces
  	,avg(fs.bytes)/(1024*1024)	afree
  	,min(fs.bytes)/(1024*1024)	sfree
  	,max(fs.bytes)/(1024*1024)	lfree
  	,sum(fs.bytes)/(1024*1024)	tfree
FROM	 dba_tablespaces	ts
      	,dba_free_space		fs
WHERE	 fs.tablespace_name 	= upper('&&tsname')
AND	 fs.tablespace_name	= ts.tablespace_name
AND	 fs.bytes/(1024*1024)	between		16.0001 and 32
GROUP BY fs.tablespace_name
	,ts.next_extent
UNION
SELECT	 
   	 fs.tablespace_name	tsname
	,round(ts.next_extent/(1024*1024),2)	nextmb
	,4			seq
	,'32+  -  64M'		range
  	,count(*)		pieces
  	,avg(fs.bytes)/(1024*1024)	afree
  	,min(fs.bytes)/(1024*1024)	sfree
  	,max(fs.bytes)/(1024*1024)	lfree
  	,sum(fs.bytes)/(1024*1024)	tfree
FROM	 dba_tablespaces	ts
      	,dba_free_space		fs
WHERE	 fs.tablespace_name 	= upper('&&tsname')
AND	 fs.tablespace_name	= ts.tablespace_name
AND	 fs.bytes/(1024*1024)	between		32.0001 and 64
GROUP BY fs.tablespace_name
	,ts.next_extent
UNION
SELECT	 
   	 fs.tablespace_name	tsname
	,round(ts.next_extent/(1024*1024),2)	nextmb
	,5			seq
	,'64+  - 128M'		range
  	,count(*)		pieces
  	,avg(fs.bytes)/(1024*1024)	afree
  	,min(fs.bytes)/(1024*1024)	sfree
  	,max(fs.bytes)/(1024*1024)	lfree
  	,sum(fs.bytes)/(1024*1024)	tfree
FROM	 dba_tablespaces	ts
      	,dba_free_space		fs
WHERE	 fs.tablespace_name 	= upper('&&tsname')
AND	 fs.tablespace_name	= ts.tablespace_name
AND	 fs.bytes/(1024*1024)	between		64.0001 and 128
GROUP BY fs.tablespace_name
	,ts.next_extent
UNION
SELECT	 
   	 fs.tablespace_name	tsname
	,round(ts.next_extent/(1024*1024),2)	nextmb
	,6			seq
	,'     > 128M'		range
  	,count(*)		pieces
  	,avg(fs.bytes)/(1024*1024)	afree
  	,min(fs.bytes)/(1024*1024)	sfree
  	,max(fs.bytes)/(1024*1024)	lfree
  	,sum(fs.bytes)/(1024*1024)	tfree
FROM	 dba_tablespaces	ts
      	,dba_free_space		fs
WHERE	 fs.tablespace_name 	= upper('&&tsname')
AND	 fs.tablespace_name	= ts.tablespace_name
AND	 fs.bytes/(1024*1024)	> 128
GROUP BY fs.tablespace_name
	,ts.next_extent
ORDER BY seq
;
undef tsname
