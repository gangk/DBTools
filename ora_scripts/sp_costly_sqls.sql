REM --------------------------------------------------------------------------------------------------
REM Author: Riyaj Shamsudeen @OraInternals, LLC
REM         www.orainternals.com
REM
REM Functionality: This script is to print costly SQLs for a given time frame.
REM **************
REM Use Case: 1. If you want to find which SQL consumed much of cpu_time or elapsed_time or any other resource 
REM              in a specific time frame, this is immensely useful.
REM           2. If you want to find how performance of a specific SQL has changed over time, that can be
REM              also shown from the output of this Script.
REM 
REM Source  : Statspack tables
REM
REM Note : 1. Keep window 160 columns for better visibility.
REM
REM Exectution type: Execute from sqlplus or any other tool. 
REM
REM Parameters: Modify the script to use correct parameters. Search for PARAMS below.
REM No implied or explicit warranty
REM
REM Please send me an email to rshamsud@orainternals.com, if you enhance this script :-)
REM --------------------------------------------------------------------------------------------------
PROMPT 
PROMPT !! Make sure to use correct Parameters in the script !!
PROMPT
select sum2.instance_number, 
       sum2.snap_time, 
       sum2.snap_id, 
       sum2.startup_time,
       sum2.executions, 
       sum2.buffer_Gets, trunc(decode (sum2.executions, 0,0, buffer_gets/executions),2 )  bfgets_per_exec,
       sum2.disk_reads, trunc( decode (sum2.executions, 0, 0,disk_reads/executions) ,2) diskrd_per_exec,
       sum2.cpu_time, trunc( decode (sum2.executions, 0, cpu_time/1/1000000,cpu_time/executions/1000000) ,4) cputmS_per_exec,
       sum2.elapsed_time, trunc( decode (sum2.executions, 0, elapsed_time/1/1000000,cpu_time/executions/1000000) ,4) elatmS_per_exec,
       sum2.hash_value, st.sql_text 
from (
  select instance_number, 
       snap_time, 
       snap_id, 
       startup_time,
       executions-
       lag(executions , 1, executions ) over (
              partition by instance_number, startup_time, hash_value
              order by instance_number, startup_time, snap_id)  executions,
       buffer_Gets-
       lag(buffer_Gets , 1, buffer_Gets ) over (
              partition by instan/e_number, startup_time, hash_value
              order by instance_number, startup_time, snap_id)  buffer_gets,
       disk_reads-
       lag(disk_Reads , 1, disk_reads ) over (
              partition by instance_number, startup_time, hash_value
              order by instance_number, startup_time, snap_id)  disk_Reads, 
       cpu_time-
       lag(cpu_time , 1, cpu_time ) over (
              partition by instance_number, startup_time, hash_value
              order by instance_number, startup_time, snap_id)  cpu_time,
       elapsed_time-
       lag(elapsed_time , 1, elapsed_time ) over (
              partition by instance_number, startup_time, hash_value
              order by instance_number, startup_time, snap_id)  elapsed_time, hash_value, sql_text      
    from            
        (   
       select /*+ use_nl( snap) index (sum1) index(snap) */ sum1.hash_value,  
        snap.snap_id, sum1.instance_number, snap.snap_time, snap.startup_time,
        sum1.executions, sum1.buffer_gets, sum1.disk_reads, sum1.parse_calls, sum1.text_subset,
        sum1.cpu_time, sum1.elapsed_time, sql_text
        from
             perfstat.stats$sql_summary sum1,
            perfstat.stats$snapshot snap  
        where 
            --sum1.hash_value in  (3395862951     ) /* PARAMS if this is for a specific SQL */
            sum1.snap_id =snap.snap_id
            and sum1.instance_number = snap.instance_number
            and snap.snap_time >= to_date ('14-JAN-2008 10:00','DD-MON-YYYY HH24:MI') /* PARAMS */
            and snap.snap_time <= to_date ('14-JAN-2008 23:59','DD-MON-YYYY HH24:MI') /* PARAMS */
            and cpu_time >0
        ) 1
    )  sum2,    perfstat.stats$sqltext st 
where cpu_time>0
and sum2.hash_value =st.hash_value 
and st.piece <60
order by trunc( decode (sum2.executions, 0, elapsed_time/1/1000000,cpu_time/executions/1000000) ,4) desc,  st.hash_value, st.piece,sum2.elapsed_time desc
/
