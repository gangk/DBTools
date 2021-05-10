REM ------------------------------------------------------------------------------------------------
REM $Id: ts-map.sql,v 1.1 2002/03/14 20:00:11 hien Exp $
REM Author     : Cary Millsap
REM		 Modified by Hien
REM #DESC      : Tablespace map - for all segment extents  and free space chunks
REM Usage      : Input parameter: ts_name
REM Description: 
REM ------------------------------------------------------------------------------------------------

@plusenv
accept ts_name 	prompt 'Enter tablespace name: '

col tablespace  form       a30 head 'Tablespace' just c trunc
col file_id	form       990 head 'File'       just c
col block_id    form 99,999,990 head 'Block Id'   just c
col blocks	form 9,999,990 head 'Size|Blocks'       just c
col sizemb	form  9,990.99 head 'Size|MB'       
col segment     form       a40 head 'Segment'    just c trunc

break on tablespace on file_id skip 1

SELECT
   	 tablespace_name		tablespace
   	,file_id
   	,1				block_id
   	,1				blocks
	,(1*p.blksz)/(1024*1024)	sizemb
   	,'<file hdr>'			segment
FROM
	(SELECT	value blksz FROM v$parameter WHERE name = 'db_block_size')	p
   	,dba_extents
WHERE
   	 tablespace_name 		= upper('&&ts_name')
UNION
SELECT
   	 tablespace_name		tablespace
   	,file_id
   	,1				block_id
   	,1				blocks
	,(1*p.blksz)/(1024*1024)	sizemb
   	,'<file hdr>'			segment
FROM
	(SELECT	value blksz FROM v$parameter WHERE name = 'db_block_size')	p
   	,dba_free_space
WHERE
   	 tablespace_name 		= upper('&&ts_name')
UNION
SELECT
   	 tablespace_name		tablespace
   	,file_id
   	,block_id
   	,blocks
	,(blocks*p.blksz)/(1024*1024)	sizemb
   	,owner||'.'||segment_name	segment
FROM
	(SELECT	value blksz FROM v$parameter WHERE name = 'db_block_size')	p
   	,dba_extents
WHERE
   	 tablespace_name 		= upper('&&ts_name')
UNION
SELECT
   	 tablespace_name		tablespace
   	,file_id
   	,block_id
   	,blocks
	,(blocks*p.blksz)/(1024*1024)	sizemb
   	,'<free>'			segment
FROM
	(SELECT	value blksz FROM v$parameter WHERE name = 'db_block_size')	p
   	,dba_free_space
WHERE
   	 tablespace_name 		= upper('&&ts_name')
ORDER BY 1,2,3
;
undef ts_name
