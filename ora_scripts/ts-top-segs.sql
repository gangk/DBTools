REM ------------------------------------------------------------------------------------------------
REM $Id: ts-top-segs.sql,v 1.2 2003/03/22 00:54:11 hien Exp $
REM Author     : hien
REM #DESC      : Show top n segments (consuming space) for a given tablespace 
REM Usage      : Input parameter: tablespace_name & top_n
REM Description: 
REM ------------------------------------------------------------------------------------------------

@plusenv

col rank	format 99		head 'No'
col segment	format a40		head 'Owner.Segment'
col pflag	format a01		head 'P'
col pctts	format 999.99		head 'Pct TS'
col sizemb	format 999,999.99	head 'Size MB'

break on report
compute sum of sizemb on report
compute sum of pctts on report

SELECT 	 
	 rownum				rank
	,seg.owner||'.'||
	 seg.segment_name		segment
	,seg.pflag			pflag
	,seg.sizemb			sizemb
	,100*seg.sizemb/ts.sizemb	pctts
FROM	 (SELECT	 owner
			,segment_name
			,decode(partition_name,null,' ','P')	pflag
			,bytes/(1024*1024)	sizemb
	  FROM		 dba_segments
	  WHERE		 tablespace_name 	= upper('&&tablespace_name')
	  ORDER BY	 bytes desc
	 )	seg
	,(SELECT	 sum(bytes)/(1024*1024)	sizemb
	  FROM		 dba_data_files
	  WHERE		 tablespace_name 	= upper('&&tablespace_name')
	  GROUP BY	 tablespace_name
	 )	ts
WHERE	 rownum		<= &&top_n
;
undef tablespace_name
undef top_n
