REM
REM This script collects detailed diagnostic information on the Automatic Workload Repository (AWR) for use in resolution of various issues that might occur with the repository.
REM

spool awr_check_out.log
    set serveroutput on
    set timing on
    set echo on
    
REM
REM -- disable flush and purge while we gather information
REM
    alter system set "_swrf_mmon_flush" = false;
    
REM
REM check how many rows are in the different tables
REM
 
    select count(*) from wrh$_sqlstat;
    select count(*) from wrh$_sqlstat_bl;
    select count(*) from wrh$_sqltext;
    select count(*) from wrh$_sql_plan;
    
    select count(*) from
     (select sql_id from wrh$_sqlstat union select sql_id from wrh$_sqlstat_bl);
    
 REM
 REM check rows in growth tables that could/should be purged
 REM
    select count(sql_id) from wrh$_sqltext  where ref_count = 0 and sql_id not in
     (select sql_id from wrh$_sqlstat union select sql_id from wrh$_sqlstat_bl);
    
    select count(sql_id) from wrh$_sql_plan where sql_id not in
     (select sql_id from wrh$_sqlstat union select sql_id from wrh$_sqlstat_bl);
    
 
 REM 
 REM check what could be limiting purge
 REM
 
    col baseline_name form a20
    select * from wrm$_baseline order by baseline_id;
    
    select count(*) from wrh$_sqltext where ref_count != 0;
    
 REM 
 REM use delete with rownum < ... to get a ballpark figure for the time
 REM 
    delete from wrh$_sqltext where rownum < 1001 and ref_count = 0 and sql_id not in
     (select sql_id from wrh$_sqlstat union select sql_id from wrh$_sqlstat_bl);
    
    rollback;
    
    delete from wrh$_sql_plan where rownum < 1001 and sql_id not in
     (select sql_id from wrh$_sqlstat union select sql_id from wrh$_sqlstat_bl);
    
    rollback;
    
 REM 
 REM Query the output od DBA_HIST_WR_CONTROL
 REM
 
    select * from  dba_hist_wr_control;
    
 REM
 REM  re-enable flush and purge
 REM
 
    alter system set "_swrf_mmon_flush" = true;
    
    spool off;