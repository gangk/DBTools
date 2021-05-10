-- awr_sysstat.sql
-- AWR Load Profile Report
-- Karl Arao, Oracle ACE (bit.ly/karlarao), OCP-DBA, RHCE
-- http://karlarao.wordpress.com
--
-- Changes:
-- 
 
 
set arraysize 5000
set termout off
set echo off verify off
 
COLUMN blocksize NEW_VALUE _blocksize NOPRINT
select distinct block_size blocksize from v$datafile;
 
COLUMN dbid NEW_VALUE _dbid NOPRINT
select dbid from v$database;
 
COLUMN instancenumber NEW_VALUE _instancenumber NOPRINT
select instance_number instancenumber from v$instance;
 
ttitle center 'AWR Load Profile Report' skip 2
set pagesize 50000
set linesize 300
 
col tm          format a15              heading "Snap|Start|Time"
col id          format 99999            heading "Snap|ID"
col inst        format 90               heading "i|n|s|t|#"
col dur         format 999990.00        heading "Snap|Dur|(m)"
col cpu         format 90               heading "C|P|U"
col cap         format 9999990.00       heading "***|Total|CPU|Time|(s)"
col dbt         format 999990.00        heading "DB|Time"
col dbc         format 99990.00         heading "DB|CPU"
col bgc         format 99990.00         heading "Bg|CPU"
col rman        format 9990.00          heading "RMAN|CPU"
col aas         format 990.0            heading "A|A|S"
col totora      format 9999990.00       heading "***|Total|Oracle|CPU|(s)"
col busy        format 9999990.00       heading "Busy|Time"
col load        format 990.00           heading "OS|Load"
col totos       format 9999990.00       heading "***|Total|OS|CPU|(s)"
col mem         format 999990.00        heading "Physical|Memory|(mb)"
col IORs        format 9990.000         heading "IOPs|r"
col IOWs        format 9990.000         heading "IOPs|w"
col IORedo      format 9990.000         heading "IOPs|redo"
col IORmbs      format 9990.000         heading "IO r|(mb)/s"
col IOWmbs      format 9990.000         heading "IO w|(mb)/s"
col redosizesec format 9990.000         heading "Redo|(mb)/s"
col logons      format 990              heading "Sess"
col logone      format 990              heading "Sess|End"
col exsraw      format 99990.000        heading "Exec|raw|delta"
col exs         format 999990.000       heading "Exec|/s"
col oracpupct   format 990              heading "Oracle|CPU|%"
col rmancpupct  format 990              heading "RMAN|CPU|%"
col oscpupct    format 990              heading "OS|CPU|%"
col oscpuusr    format 990              heading "U|S|R|%"
col oscpusys    format 990              heading "S|Y|S|%"
col oscpuio     format 990              heading "I|O|%"
 
col lios        format 999999990.000    heading "LIO|/s"
col dbblkc      format 999990.000       heading "DB Block|Changes|/s"
col ucs         format 999990.000       heading "User|Calls|/s"
col parsestotal format 999990.000       heading "Parses|/s"
col parseshard  format 999990.000       heading "Hard|Parses|/s"
col parsesfail  format 999990.000       heading "Parses|Fail|/s"
col opencursors format 999990.000       heading "Opened|Cursors|End"
col sorts       format 999990.000       heading "Sorts|/s"
col logonscum   format 999990.000       heading "Logons|/s"
col trxs        format 999990.000       heading "Trx|/s"
 
 
 
 
 
 
SELECT * FROM
(
  SELECT s0.snap_id id,
  TO_CHAR(s0.END_INTERVAL_TIME,'YY/MM/DD HH24:MI') tm,
  s0.instance_number inst,
  round(EXTRACT(DAY FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 1440
                                  + EXTRACT(HOUR FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 60
                                  + EXTRACT(MINUTE FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME)
                                  + EXTRACT(SECOND FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) / 60, 2) dur,
  s3t1.value AS cpu,
  (round(EXTRACT(DAY FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 1440
                                  + EXTRACT(HOUR FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 60
                                  + EXTRACT(MINUTE FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME)
                                  + EXTRACT(SECOND FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) / 60, 2)*60)*s3t1.value cap,
  (s5t1.value - s5t0.value) / 1000000 as dbt,
  (s6t1.value - s6t0.value) / 1000000 as dbc,
  (s7t1.value - s7t0.value) / 1000000 as bgc,
  round(DECODE(s8t1.value,null,'null',(s8t1.value - s8t0.value) / 1000000),2) as rman,
  ((s5t1.value - s5t0.value) / 1000000)/60 /  round(EXTRACT(DAY FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 1440
                                  + EXTRACT(HOUR FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 60
                                  + EXTRACT(MINUTE FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME)
                                  + EXTRACT(SECOND FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) / 60, 2) aas,
   ((s14t1.value - s14t0.value)/1024/1024)  / ((round(EXTRACT(DAY FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 1440
                                  + EXTRACT(HOUR FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 60
                                  + EXTRACT(MINUTE FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME)
                                  + EXTRACT(SECOND FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) / 60, 2))*60)
     as redosizesec,
   ((s26t1.value - s26t0.value)  / ((round(EXTRACT(DAY FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 1440
                                  + EXTRACT(HOUR FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 60
                                  + EXTRACT(MINUTE FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME)
                                  + EXTRACT(SECOND FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) / 60, 2))*60)
    ) as lios,
   ((s27t1.value - s27t0.value)  / ((round(EXTRACT(DAY FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 1440
                                  + EXTRACT(HOUR FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 60
                                  + EXTRACT(MINUTE FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME)
                                  + EXTRACT(SECOND FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) / 60, 2))*60)
    ) as dbblkc,
   (((s11t1.value - s11t0.value)* &_blocksize)/1024/1024)  / ((round(EXTRACT(DAY FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 1440
                                  + EXTRACT(HOUR FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 60
                                  + EXTRACT(MINUTE FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME)
                                  + EXTRACT(SECOND FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) / 60, 2))*60)
      as IORmbs,
   (((s12t1.value - s12t0.value)* &_blocksize)/1024/1024)  / ((round(EXTRACT(DAY FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 1440
                                  + EXTRACT(HOUR FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 60
                                  + EXTRACT(MINUTE FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME)
                                  + EXTRACT(SECOND FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) / 60, 2))*60)
      as IOWmbs,
   ((s28t1.value - s28t0.value)  / ((round(EXTRACT(DAY FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 1440
                                  + EXTRACT(HOUR FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 60
                                  + EXTRACT(MINUTE FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME)
                                  + EXTRACT(SECOND FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) / 60, 2))*60)
    ) as ucs,
   ((s29t1.value - s29t0.value)  / ((round(EXTRACT(DAY FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 1440
                                  + EXTRACT(HOUR FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 60
                                  + EXTRACT(MINUTE FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME)
                                  + EXTRACT(SECOND FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) / 60, 2))*60)
    ) as parsestotal,
   ((s30t1.value - s30t0.value)  / ((round(EXTRACT(DAY FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 1440
                                  + EXTRACT(HOUR FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 60
                                  + EXTRACT(MINUTE FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME)
                                  + EXTRACT(SECOND FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) / 60, 2))*60)
    ) as parseshard,
   ((s36t1.value - s36t0.value)  / ((round(EXTRACT(DAY FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 1440
                                  + EXTRACT(HOUR FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 60
                                  + EXTRACT(MINUTE FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME)
                                  + EXTRACT(SECOND FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) / 60, 2))*60)
    ) as parsesfail,
   (s37t1.value) as opencursors,
   ( ((s31t1.value - s31t0.value) + (s32t1.value - s32t0.value))  / ((round(EXTRACT(DAY FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 1440
                                  + EXTRACT(HOUR FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 60
                                  + EXTRACT(MINUTE FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME)
                                  + EXTRACT(SECOND FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) / 60, 2))*60)
    ) as sorts,
   ((s33t1.value - s33t0.value)  / ((round(EXTRACT(DAY FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 1440
                                  + EXTRACT(HOUR FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 60
                                  + EXTRACT(MINUTE FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME)
                                  + EXTRACT(SECOND FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) / 60, 2))*60)
    ) as logonscum,
   ((s10t1.value - s10t0.value)  / ((round(EXTRACT(DAY FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 1440
                                  + EXTRACT(HOUR FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 60
                                  + EXTRACT(MINUTE FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME)
                                  + EXTRACT(SECOND FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) / 60, 2))*60)
    ) as exs,
   ( ((s34t1.value - s34t0.value) + (s35t1.value - s35t0.value))  / ((round(EXTRACT(DAY FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 1440
                                  + EXTRACT(HOUR FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) * 60
                                  + EXTRACT(MINUTE FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME)
                                  + EXTRACT(SECOND FROM s1.END_INTERVAL_TIME - s0.END_INTERVAL_TIME) / 60, 2))*60)
    ) as trxs
FROM dba_hist_snapshot s0,
  dba_hist_snapshot s1,
  dba_hist_osstat s3t1,         -- osstat just get the end value
  dba_hist_sys_time_model s5t0,
  dba_hist_sys_time_model s5t1,
  dba_hist_sys_time_model s6t0,
  dba_hist_sys_time_model s6t1,
  dba_hist_sys_time_model s7t0,
  dba_hist_sys_time_model s7t1,
  dba_hist_sys_time_model s8t0,
  dba_hist_sys_time_model s8t1,      
  dba_hist_sysstat s10t0,       -- execute count, diffed
  dba_hist_sysstat s10t1,
  dba_hist_sysstat s14t0,       -- redo size, diffed
  dba_hist_sysstat s14t1,
  dba_hist_sysstat s26t0,       -- session logical reads, diffed
  dba_hist_sysstat s26t1,
  dba_hist_sysstat s27t0,       -- db block changes, diffed
  dba_hist_sysstat s27t1,
  dba_hist_sysstat s11t0,       -- physical reads, diffed
  dba_hist_sysstat s11t1,
  dba_hist_sysstat s12t0,       -- physical writes, diffed
  dba_hist_sysstat s12t1,
  dba_hist_sysstat s28t0,       -- user calls, diffed
  dba_hist_sysstat s28t1,
  dba_hist_sysstat s29t0,       -- parse count (total), diffed
  dba_hist_sysstat s29t1,
  dba_hist_sysstat s30t0,       -- parse count (hard), diffed
  dba_hist_sysstat s30t1,
  dba_hist_sysstat s31t0,       -- sorts (memory), diffed
  dba_hist_sysstat s31t1,
  dba_hist_sysstat s32t0,       -- sorts (disk), diffed
  dba_hist_sysstat s32t1,
  dba_hist_sysstat s33t0,       -- logons cumulative, diffed
  dba_hist_sysstat s33t1,
  dba_hist_sysstat s34t0,       -- user commits, diffed
  dba_hist_sysstat s34t1,
  dba_hist_sysstat s35t0,       -- user rollbacks, diffed
  dba_hist_sysstat s35t1,
  dba_hist_sysstat s36t0,       -- parse count (failures), diffed
  dba_hist_sysstat s36t1,
  dba_hist_sysstat s37t1       -- opened cursors current, just the end value
WHERE s0.dbid            = &_dbid    -- CHANGE THE DBID HERE!
AND s1.dbid              = s0.dbid
AND s3t1.dbid            = s0.dbid
AND s5t0.dbid            = s0.dbid
AND s5t1.dbid            = s0.dbid
AND s6t0.dbid            = s0.dbid
AND s6t1.dbid            = s0.dbid
AND s7t0.dbid            = s0.dbid
AND s7t1.dbid            = s0.dbid
AND s8t0.dbid            = s0.dbid
AND s8t1.dbid            = s0.dbid
AND s10t0.dbid            = s0.dbid
AND s10t1.dbid            = s0.dbid
AND s14t0.dbid            = s0.dbid
AND s14t1.dbid            = s0.dbid
AND s26t0.dbid            = s0.dbid
AND s26t1.dbid            = s0.dbid
AND s27t0.dbid            = s0.dbid
AND s27t1.dbid            = s0.dbid
AND s11t0.dbid            = s0.dbid
AND s11t1.dbid            = s0.dbid
AND s12t0.dbid            = s0.dbid
AND s12t1.dbid            = s0.dbid
AND s28t0.dbid            = s0.dbid
AND s28t1.dbid            = s0.dbid
AND s29t0.dbid            = s0.dbid
AND s29t1.dbid            = s0.dbid
AND s30t0.dbid            = s0.dbid
AND s30t1.dbid            = s0.dbid
AND s31t0.dbid            = s0.dbid
AND s31t1.dbid            = s0.dbid
AND s32t0.dbid            = s0.dbid
AND s32t1.dbid            = s0.dbid
AND s33t0.dbid            = s0.dbid
AND s33t1.dbid            = s0.dbid
AND s34t0.dbid            = s0.dbid
AND s34t1.dbid            = s0.dbid
AND s35t0.dbid            = s0.dbid
AND s35t1.dbid            = s0.dbid
AND s36t0.dbid            = s0.dbid
AND s36t1.dbid            = s0.dbid
AND s37t1.dbid            = s0.dbid
AND s0.instance_number   = &_instancenumber   -- CHANGE THE INSTANCE_NUMBER HERE!
AND s1.instance_number   = s0.instance_number
AND s3t1.instance_number = s0.instance_number
AND s5t0.instance_number = s0.instance_number
AND s5t1.instance_number = s0.instance_number
AND s6t0.instance_number = s0.instance_number
AND s6t1.instance_number = s0.instance_number
AND s7t0.instance_number = s0.instance_number
AND s7t1.instance_number = s0.instance_number
AND s8t0.instance_number = s0.instance_number
AND s8t1.instance_number = s0.instance_number
AND s10t0.instance_number = s0.instance_number
AND s10t1.instance_number = s0.instance_number
AND s14t0.instance_number = s0.instance_number
AND s14t1.instance_number = s0.instance_number
AND s26t0.instance_number = s0.instance_number
AND s26t1.instance_number = s0.instance_number
AND s27t0.instance_number = s0.instance_number
AND s27t1.instance_number = s0.instance_number
AND s11t0.instance_number = s0.instance_number
AND s11t1.instance_number = s0.instance_number
AND s12t0.instance_number = s0.instance_number
AND s12t1.instance_number = s0.instance_number
AND s28t0.instance_number = s0.instance_number
AND s28t1.instance_number = s0.instance_number
AND s29t0.instance_number = s0.instance_number
AND s29t1.instance_number = s0.instance_number
AND s30t0.instance_number = s0.instance_number
AND s30t1.instance_number = s0.instance_number
AND s31t0.instance_number = s0.instance_number
AND s31t1.instance_number = s0.instance_number
AND s32t0.instance_number = s0.instance_number
AND s32t1.instance_number = s0.instance_number
AND s33t0.instance_number = s0.instance_number
AND s33t1.instance_number = s0.instance_number
AND s34t0.instance_number = s0.instance_number
AND s34t1.instance_number = s0.instance_number
AND s35t0.instance_number = s0.instance_number
AND s35t1.instance_number = s0.instance_number
AND s36t0.instance_number = s0.instance_number
AND s36t1.instance_number = s0.instance_number
AND s37t1.instance_number = s0.instance_number
AND s1.snap_id           = s0.snap_id + 1
AND s3t1.snap_id         = s0.snap_id + 1
AND s5t0.snap_id         = s0.snap_id
AND s5t1.snap_id         = s0.snap_id + 1
AND s6t0.snap_id         = s0.snap_id
AND s6t1.snap_id         = s0.snap_id + 1
AND s7t0.snap_id         = s0.snap_id
AND s7t1.snap_id         = s0.snap_id + 1
AND s8t0.snap_id         = s0.snap_id
AND s8t1.snap_id         = s0.snap_id + 1
AND s10t0.snap_id         = s0.snap_id
AND s10t1.snap_id         = s0.snap_id + 1
AND s14t0.snap_id         = s0.snap_id
AND s14t1.snap_id         = s0.snap_id + 1
AND s26t0.snap_id         = s0.snap_id
AND s26t1.snap_id         = s0.snap_id + 1
AND s27t0.snap_id         = s0.snap_id
AND s27t1.snap_id         = s0.snap_id + 1
AND s11t0.snap_id         = s0.snap_id
AND s11t1.snap_id         = s0.snap_id + 1
AND s12t0.snap_id         = s0.snap_id
AND s12t1.snap_id         = s0.snap_id + 1
AND s28t0.snap_id         = s0.snap_id
AND s28t1.snap_id         = s0.snap_id + 1
AND s29t0.snap_id         = s0.snap_id
AND s29t1.snap_id         = s0.snap_id + 1
AND s30t0.snap_id         = s0.snap_id
AND s30t1.snap_id         = s0.snap_id + 1
AND s31t0.snap_id         = s0.snap_id
AND s31t1.snap_id         = s0.snap_id + 1
AND s32t0.snap_id         = s0.snap_id
AND s32t1.snap_id         = s0.snap_id + 1
AND s33t0.snap_id         = s0.snap_id
AND s33t1.snap_id         = s0.snap_id + 1
AND s34t0.snap_id         = s0.snap_id
AND s34t1.snap_id         = s0.snap_id + 1
AND s35t0.snap_id         = s0.snap_id
AND s35t1.snap_id         = s0.snap_id + 1
AND s36t0.snap_id         = s0.snap_id
AND s36t1.snap_id         = s0.snap_id + 1
AND s37t1.snap_id         = s0.snap_id + 1
AND s3t1.stat_name       = 'NUM_CPUS'
AND s5t0.stat_name       = 'DB time'
AND s5t1.stat_name       = s5t0.stat_name
AND s6t0.stat_name       = 'DB CPU'
AND s6t1.stat_name       = s6t0.stat_name
AND s7t0.stat_name       = 'background cpu time'
AND s7t1.stat_name       = s7t0.stat_name
AND s8t0.stat_name       = 'RMAN cpu time (backup/restore)'
AND s8t1.stat_name       = s8t0.stat_name
AND s10t0.stat_name       = 'execute count'
AND s10t1.stat_name       = s10t0.stat_name
AND s14t0.stat_name       = 'redo size'
AND s14t1.stat_name       = s14t0.stat_name
AND s26t0.stat_name       = 'session logical reads'
AND s26t1.stat_name       = s26t0.stat_name
AND s27t0.stat_name       = 'db block changes'
AND s27t1.stat_name       = s27t0.stat_name
AND s11t0.stat_name       = 'physical reads'
AND s11t1.stat_name       = s11t0.stat_name
AND s12t0.stat_name       = 'physical writes'
AND s12t1.stat_name       = s12t0.stat_name
AND s28t0.stat_name       = 'user calls'
AND s28t1.stat_name       = s28t0.stat_name
AND s29t0.stat_name       = 'parse count (total)'
AND s29t1.stat_name       = s29t0.stat_name
AND s30t0.stat_name       = 'parse count (hard)'
AND s30t1.stat_name       = s30t0.stat_name
AND s31t0.stat_name       = 'sorts (memory)'
AND s31t1.stat_name       = s31t0.stat_name
AND s32t0.stat_name       = 'sorts (disk)'
AND s32t1.stat_name       = s32t0.stat_name
AND s33t0.stat_name       = 'logons cumulative'
AND s33t1.stat_name       = s33t0.stat_name
AND s34t0.stat_name       = 'user commits'
AND s34t1.stat_name       = s34t0.stat_name
AND s35t0.stat_name       = 'user rollbacks'
AND s35t1.stat_name       = s35t0.stat_name
AND s36t0.stat_name       = 'parse count (failures)'
AND s36t1.stat_name       = s36t0.stat_name
AND s37t1.stat_name       = 'opened cursors current'
)
-- WHERE
-- id  in (select snap_id from (select * from r2toolkit.r2_regression_data union all select * from r2toolkit.r2_outlier_data))
-- id in (338)
-- aas > 1
-- oracpupct > 50
-- oscpupct > 50
-- AND TO_CHAR(s0.END_INTERVAL_TIME,'D') >= 1     -- Day of week: 1=Sunday 7=Saturday
-- AND TO_CHAR(s0.END_INTERVAL_TIME,'D') <= 7
-- AND TO_CHAR(s0.END_INTERVAL_TIME,'HH24MI') >= 0900     -- Hour
-- AND TO_CHAR(s0.END_INTERVAL_TIME,'HH24MI') <= 1800
-- AND s0.END_INTERVAL_TIME >= TO_DATE('2010-jan-17 00:00:00','yyyy-mon-dd hh24:mi:ss')     -- Data range
-- AND s0.END_INTERVAL_TIME <= TO_DATE('2010-aug-22 23:59:59','yyyy-mon-dd hh24:mi:ss')
ORDER BY id ASC;