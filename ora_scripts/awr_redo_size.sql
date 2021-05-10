-------------------------------------------------------------------------------------------------
--  Script : awr_redo_size.sql
-------------------------------------------------------------------------------------------------
-- This script will calculate the daily redo size using AWR
-- Restrictions :
-- 	1. Of course, AWR must be running and collects statistics
--      2. If you have centralized AWR repository, then you might want to verify the data.
--         Tested only for non-centralized AWR repository
--
--  Author : Riyaj Shamsudeen
--  No implied or explicit warranty !
-------------------------------------------------------------------------------------------------
PROMPT
PROMPT  To generate Report about Redo rate from AWR tables. Does not consider effect of nologging effects.
PROMPT    
PROMPT  If you want to measure the effect of altering logging mode to FORCE logging, use awr_redo_nologging_size.sql script
PROMPT
set pages 100
set lines 340
set serveroutput on size 1000000
column "redo_size (MB)" format 999,999,999,999.99
set verify off
accept db_block_size prompt 'Enter the block size(Null=8192):'
accept history_days prompt 'Enter past number of days to search for (Null=30):'
SELECT inst.db_name,
       redo_date,
       Trunc(SUM(redo_size ) / ( 1024 * 1024 ), 2) "redo_size (MB)"
FROM   (SELECT DISTINCT dbid,
                        redo_date,
                        redo_size,
                        startup_time
        FROM   (SELECT sysst.dbid,
                       Trunc(begin_interval_time) redo_date,
                       startup_time,
                       VALUE,
                       CASE
                         WHEN stat_name = 'redo size' THEN
                         Last_value (VALUE) over ( PARTITION BY Trunc (begin_interval_time), startup_time, sysst.stat_id,sysst.instance_number
                                                   ORDER BY begin_interval_time, startup_time ROWS BETWEEN unbounded preceding AND unbounded following ) -
                         First_value (VALUE) over ( PARTITION BY Trunc(begin_interval_time), startup_time , sysst.stat_id,sysst.instance_number 
						   ORDER BY begin_interval_time, startup_time ROWS BETWEEN unbounded preceding AND unbounded following )
                        ELSE 0
                        END                        redo_size
                FROM   sys.wrh$_sysstat sysst,
                       dba_hist_snapshot snaps,
                       sys.wrh$_stat_name statname
                WHERE  snaps.snap_id = sysst.snap_id
                       AND snaps.dbid = sysst.dbid
                       AND sysst.stat_id = statname.stat_id
                       AND sysst.dbid = statname.dbid
			AND snaps.begin_interval_time >= to_date(trunc(sysdate-nvl('&&history_days',30)))
                ORDER  BY snaps.snap_id)) redo_data,
       sys.dba_hist_database_instance inst
WHERE  inst.dbid = redo_data.dbid
       AND inst.startup_time = redo_data.startup_time
GROUP  BY inst.db_name,
          redo_date
ORDER  BY inst.db_name,
          redo_date

/ 
set verify on
