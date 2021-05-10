REM ------------------------------------------------------------------------------------------------
REM $Id: snap-grp.sql,v 1.1 2002/03/14 00:25:40 hien Exp $
REM Author     : hien
REM #DESC      : Show all snapshots, ordered by master site and snapshot group
REM Usage      : 
REM Description: 
REM ------------------------------------------------------------------------------------------------

@plusenv

col gowner	format	a8
col cowner	format	a7
col job		format	9999999
col sid		format	99999
col rbs		format  a6
col gname	format	a30	head 'Snapshot Group'
col cname	format	a30	head 'Snapshot Name'
col type#	format  a03	trunc
col mlink	format	a16	
col rmethod	format  a03	trunc
col log		format	a1	trunc
col upd		format	a1	trunc
col f		format  a1 	
col stime	format  a09	head 'Refresh|Time'

break on mlink on gowner on gname on type# on rbs on job on cowner

SELECT
	 s.master_link		mlink
        ,g.owner		gowner
	,g.name			gname
	,g.rollback_seg 	rbs
	,g.job	
	,c.owner		cowner
	,c.name			cname
	,s.refresh_method	rmethod
	,s.can_use_log		log
	,s.updatable		upd
	,decode(sign(snaptime - (sysdate-(30/60*24))),-1,'x',' ') f
	,to_char(sn.snaptime,'MMDD HH24MI') stime
FROM	 dba_rgroup		g
	,dba_rchild		c
	,sys.snap_reftime$	sn
	,dba_snapshots		s
WHERE	 g.refgroup	= c.refgroup
AND	 c.owner	= s.owner
AND	 c.name		= s.name
AND	 c.owner	= sn.sowner
AND	 c.name		= sn.vname
ORDER BY 
	 s.master_link
	,g.name
	,c.name
;
