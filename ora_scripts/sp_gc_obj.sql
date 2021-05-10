REM --------------------------------------------------------------------------------------------------
REM Author: Riyaj Shamsudeen @OraInternals, LLC
REM         www.orainternals.com
REM
REM Functionality: This script is to query global cache CUR performance from statspack
REM **************
REM Use Case: 1. To find objects that are involved in high global cache CUR traffic. 
REM 
REM Source  : Statspack tables
REM
REM Note : 1. Keep window 160 columns for better visibility.
REM        2. Of course, this can be modified to use get global cache CR traffic
REM
REM Exectution type: Execute from sqlplus or any other tool. 
REM
REM Parameters: Modify the script to use correct parameters. Search for PARAMS below.
REM No implied or explicit warranty
REM
REM Please send me an email to rshamsud@orainternals.com, if you enhance this script :-)
REM
REM --------------------------------------------------------------------------------------------------
REM  1. Minor code bug fix on Feb 2008
PROMPT 
PROMPT !! Make sure to use correct Parameters in the script !!
PROMPT
REM This SQL is to measure global cache CUR performance at object level.
set lines 120 pages 100
set lines 130 pages 100
col owner format A30
col object_name format A30
col gc_cu_blocks_served format 99999999999999
spool gctest.lst
with stats1 as(
 select snap_time,obj#,dataobj#, dbid, global_cache_cu_blocks_served
 from (
  select
    snap_time , dataobj#,obj#,snap_id, dbid, instance_number, startup_time,
    global_cache_cu_blocks_served -
    lag(global_cache_cu_blocks_served,1,global_cache_cu_blocks_served) over (partition by instance_number,startup_time, dataobj#, obj#
              order by  snap_id ) global_cache_cu_blocks_served
    from  (
       select  /*+ leading (snap) parallel (snap 5) parallel ( e 5)  */
         snap.snap_time ,  e.dataobj#, e.obj#, e.global_cache_cu_blocks_served, e.snap_id, e.dbid, e.instance_number, snap.startup_time
          from
                perfstat.stats$seg_stat e, perfstat.stats$snapshot snap
                where
                        e.snap_id =snap.snap_id
                        and e.instance_number = snap.instance_number
                        and e.dbid = snap.dbid
                      and trunc(snap.snap_time) = trunc(sysdate-1) -- one day ago PARAM
                      order by instance_number, startup_time, dataobj#, snap_id
                )
      )
)
select * from
    ( select   /*+ no_merge(s) */ o.owner, o.object_name, sum(GLOBAL_CACHE_CU_BLOCKS_SERVED) gc_cu_blocks_served
      from  stats1 s, dba_objects  o
      where s.dataobj# = o.data_object_id
         and s.obj#=o.object_id
      group by  o.owner, o.object_name
      order by 3 desc
    ) where rownum <21
/
spool off
