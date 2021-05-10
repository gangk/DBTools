prompt ............................................................
prompt .
prompt op_cpu_speed.sql - OraPub CPU Speed Test
prompt Version 1.0c 22-Jan-2009
prompt (c)OraPub, Inc. - Author: Craig Shallahamer, craig@orapub.com
prompt This script can be used to compare Oracle
prompt database server CPU speed.
prompt .
prompt ............................................................
prompt . Use at your own risk. There is no warrenty.
prompt . OraPub assumes no responsibility for the use of this script.
prompt ............................................................
prompt .
prompt Usage: Simply review and run the sript, it's self contained.
prompt ............................................................
 
prompt Creating objects...
 
CREATE OR REPLACE PROCEDURE OP_LOAD_ROWS (LOOPS IN NUMBER)
IS
        i       number;
BEGIN
 
        execute immediate 'truncate table op$speed_test';
 
        insert into op$speed_test nologging select * from all_objects where rownum <= 10000;
 
        for i in 1..loops
        loop
                insert into op$speed_test nologging select * from op$speed_test;
                commit;
        end loop;
END;
/
 
SET SERVEROUTPUT ON
 
drop   table op$speed_test;
create table op$speed_test cache parallel 1 as select * from all_objects where rownum < 1;
drop   table op$stats;
create table op$stats (lio number, pio number, duration number);
prompt Loading rows. This will take a couple of minutes depending on your redo flow...
exec op_load_rows(7);
set heading off feedback off
select 'Speed test rows are '||count(*) x from op$speed_test;
set heading on feedback on
prompt Caching all rows...
set termout off
                select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test;
set termout on
prompt Speed tests about to begin. This will take a few minutes.
prompt Starting now...
 
DECLARE
        j               number;
        start_time      number;
        end_time        number;
        test_time       number;
        test_time_ms    number;
        duration        number;
        rows            number;
        speed           number;
        stdev           number;
        start_lio       number;
        end_lio         number;
        start_pio       number;
        end_pio         number;
        lio             number;
        lios            number;
        pio             number;
        pio_lio         number;
BEGIN
        execute immediate 'truncate table op$stats';
 
        for i in 1..7
        loop
                select sum(value) into start_lio from v$statname sn, v$mystat ms where sn.name in ('db block gets','consistent gets') and sn.statistic#=ms.statistic#;
                select value      into start_pio from v$statname sn, v$mystat ms where sn.name in ('physical reads') and sn.statistic#=ms.statistic#;
                start_time := DBMS_UTILITY.get_time;
 
                select /*+ FULL (op$speed_test) */   count(*) into rows from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test
                union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test union select /*+ FULL (op$speed_test) */   count(*) from op$speed_test;
 
                end_time := DBMS_UTILITY.get_time;
                test_time := end_time - start_time ;
                select sum(value) into end_lio from v$statname sn, v$mystat ms where sn.name in ('db block gets','consistent gets') and sn.statistic#=ms.statistic#;
                select value      into end_pio from v$statname sn, v$mystat ms where sn.name in ('physical reads') and sn.statistic#=ms.statistic#;
                pio := end_pio - start_pio;
                lio := end_lio - start_lio;
                insert into op$stats values (lio,pio,test_time);
                commit;
 
        end loop;
 
        dbms_output.put_line('Complete!');
 
        delete from op$stats where lio = (select max(lio) from op$stats);
 
        select round(avg(duration*10),3) into test_time_ms from op$stats;
        select round(avg(lio),3) into lios from op$stats;
 
        select round(avg(lio/(duration*10)),3) into speed from op$stats;
 
        select round(stddev(lio/(duration*10)),3) into stdev from op$stats;
 
        select round(avg(pio/lio),3) into pio_lio from op$stats;
 
        rollback;
 
        dbms_output.put_line('..........................................................................');
        dbms_output.put_line('OraPub CPU speed statistic is ' || speed );
        dbms_output.put_line('Other statistics: stdev='||stdev||' PIOs='||pio||' pio/lio='||pio_lio||' avg lios/test='||lios||' avg time(ms)/test='||test_time_ms||')');
 
END;
/
set echo off
select * from op$stats;
!uname -a
 
col host_name format a30
col instance_name format a12
select host_name,instance_name,version from v$instance;
show parameter cpu
 
prompt ..........................................................................