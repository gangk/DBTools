
REM
REM HealthCheck for SGA
REM 
REM  runs on 11g releases
REM
REM This scripts attempts to provide overview data on the memory usage
REM in the SGA
REM

set lines 120
connect / as sysdba

accept start prompt "Start Time (Several Hours Prior to Errors - Format YYYY DD-Mon HH24): "
accept endd prompt "End Time (Time Errors Started - Format YYYY DD-Mon HH24): "

set pages 999
clear col
set termout off
set feed off
set verify off

spool SGAAnalysis_RAC.out

col instance_name format a30 head "Instance"
col inst_id format 99999 head "Inst ID"
col "MBytes" format 999,999
col lifetime format a40 heading "Database Started Last"
col name format a32 head "Component"
col bytes format 999,999,999,999,999 head "Current Size"
col resizeable format a3 head "RSZ|Y/N"

set feed on
PROMPT 
PROMPT  ########## Startup information ########## 
PROMPT  ########## NOTE:  This Pulls Current Data From All Nodes ########## 
set feed off

select inst_id, instance_name, 
to_char(startup_time, 'dd-Mon-yyyy hh24:mi:ss') Lifetime 
from gv$instance
order by 1;

set feed on
PROMPT 
PROMPT  ########## Current SGA configuration ########## 
PROMPT  ########## NOTE:  This Pulls Current Data From All Nodes ########## 
set feed off

select instance_name, name, bytes, resizeable 
from gv$sgainfo a, gv$instance b
where a.inst_id = b.inst_id
order by 1;

set feed on
PROMPT 
PROMPT  ########## Historic Parameters at Time of Errors ########## 
PROMPT  ########## NOTE: This Pulls Data From One Node Only ########## 
set feed off
set head off

col "TStamp" format a15
col "MBytes" format a40
col "Setting" format a40

select to_char(end_interval_time, 'YYYY dd-Mon HH24') TStamp,
  upper(parameter_name)||': '||decode(value, null, -1, value/1024/1024) "MBytes"
from dba_hist_snapshot b, dba_hist_parameter a where parameter_name
in ('__shared_pool_size','shared_pool_reserved_size','__streams_pool_size','__db_cache_size',
    '__java_pool_size','db_recycle_cache_size','db_keep_cache_size','db_2k_cache_size',
    'db_4k_cache_size','db_8k_cache_size','log_buffer','db_32k_cache_size','__large_pool_size',
    'sga_max_size','sga_target','__shared_io_pool_size',
    'shared_pool_size','large_pool_size','java_pool_size','streams_pool_size','db_cache_size')
and a.snap_id = b.snap_id
and to_char(end_interval_time, 'YYYY dd-Mon HH24') = '&&endd'
order by 1,2
/

select to_char(end_interval_time, 'YYYY dd-Mon HH24') TStamp,
  upper(parameter_name)||':  '|| decode(value, null,-1,value) "Setting" 
from dba_hist_snapshot b, dba_hist_parameter a where parameter_name
in ('open_cursors','processes','sessions','db_files','shared_server','session_cached_cursors')
and a.snap_id = b.snap_id
and to_char(end_interval_time, 'YYYY dd-Mon HH24') = '&&endd'
order by 1,2
/

col Setting format a30

select to_char(end_interval_time, 'YYYY dd-Mon HH24') TStamp,
   upper(parameter_name)||':  '||value "Setting" 
from dba_hist_snapshot b, dba_hist_parameter a where parameter_name
in ('cursor_sharing','query_rewrite_enabled','statistics_level',
     'cursor_space_for_time','db_cache_advice','compatible','event')
and a.snap_id = b.snap_id
and to_char(end_interval_time, 'YYYY dd-Mon HH24') = '&&endd'
order by 1,2
/

set head on
set feed on
PROMPT 
PROMPT  ########## Historic Resource Limits at time of error ########## 
PROMPT  ########## NOTE: This Pulls Data From One Node Only ########## 
set feed off

col resource_name format a25 head "Resource"
col current_utilization format 999,999,999,999 head "Current"
col max_utilization format 999,999,999,999 head "HWM"
col intl format a15 head "Setting"

select to_char(end_interval_time, 'YYYY dd-Mon HH24') TStamp,
  resource_name, current_utilization, max_utilization, initial_allocation intl
from dba_hist_snapshot a, dba_hist_resource_limit b
where a.snap_id = b.snap_id
and to_char(end_interval_time, 'YYYY dd-Mon HH24') = '&&endd'
/

set feed on
PROMPT 
PROMPT  ########## Overall Resource Limits Currently ########## 
PROMPT  ########## NOTE:  This Pulls Current Data From All Nodes ########## 
set feed off

select instance_name, resource_name, current_utilization, max_utilization, initial_allocation intl
from gv$resource_limit a, gv$instance b
where a.inst_id = b.inst_id
order by 1
/

set feed on
PROMPT 
PROMPT  ########## SGA Related Hidden Parameter Settings ########## 
PROMPT  ########## NOTE: This Pulls Data From One Node Only ########## 
set feed off

set lines 90

col Parameter format a35 wrap
col "Session Value" format a25 wrapped
col "Instance Value" format a25 wrapped

select  a.ksppinm  "Parameter",
             b.ksppstvl "Session Value",
             c.ksppstvl "Instance Value"
      from x$ksppi a, x$ksppcv b, x$ksppsv c
     where a.indx = b.indx and a.indx = c.indx
       and a.ksppinm in ('_kghdsidx_count','__shared_pool_size','__streams_pool_size',
         '__db_cache_size','__java_pool_size','__large_pool_size', '_PX_use_large_pool', 
         '_large_pool_min_alloc','_shared_pool_reserved_min','_shared_pool_reserved_min_alloc',
         '_shared_pool_reserved_pct','_4031_dump_bitvec','4031_dump_interval',
         '_4031_max_dumps','4031_sga_dump_interval','4031_sga_max_dumps', '_kill_java_threads_on_eoc',
         '_optim_peek_user_binds','_px_bind_peek_sharing','_kgl_heap_size',
         '_library_cache_advice','_io_shared_pool_size','_NUMA_pool_size')
order by 1;

REM 
REM  Review memory usage for pinned objects
REM

set lines 120

set feed on
PROMPT 
PROMPT  ########## Memory Usage for Pinned Objects          ##########
PROMPT  ########## NOTE: This Pulls Data From One Node Only ########## 
PROMPT
set feed off

col namespace format a60 heading "Library Cache Area"
col num_objects format 999,999,999,999 heading "# of Objects"
col kb format 999,999 heading "Memory Usage| (KBytes)" 
col memratio format 999,999.999 heading "Pinned Objects|Memory % To|Shared Pool Size"

select namespace, count(1) num_objects
	, sum(sharable_mem)/1024 kb
        , sum((sharable_mem/1024)/(shps/1024)) memratio
	from v$db_object_cache, (select bytes shps from v$sgainfo where name = 'Shared Pool Size') b
	where kept='YES'
	group by namespace
	order by kb desc;

REM  
REM Pointer:   The total memory for non-shared SQL statements should not exceed
REM                20% of the Shared Pool.   If this percentage is much larger than that
REM                then efforts should be made to decrease the non-shared code in the
REM                application.
REM

set feed on
PROMPT 
PROMPT  ########## Memory Statistics for Non-Shared SQL Statements ##########  
PROMPT  ########## NOTE: This Pulls Data From One Node Only ########## 
PROMPT
set feed off

set serveroutput on

declare
   SHPSIZE number;
   SV number;
   IV number;
   NUM_SQL number;
   NUM_EX1 number;
   TTLBYTES number;
   EX1_MEMORY number;

   cursor c1 is select bytes/1024/1024 from v$sgainfo where name='Shared Pool Size';
   cursor c2 is select to_number(b.ksppstvl)/1024/1024, to_number(c.ksppstvl)/1024/1024
      from x$ksppi a, x$ksppcv b, x$ksppsv c
      where a.indx = b.indx and a.indx = c.indx and a.ksppinm in ('__shared_pool_size')
      order by 1;
   cursor c3 is select count(1), sum(decode(executions,1,1,0)),
      round(sum(sharable_mem)/1024/1024,0), round(sum(decode(executions, 1, sharable_mem/1024/1024)),0)
      from v$sqlarea where sharable_mem > 0;

begin 

   open c1;
     fetch c1 into SHPSIZE;
     dbms_output.put_line('Explicit/Minimum Setting:  '||SHPSIZE||'MB');
   close c1;

   open c2;
     fetch c2 into SV, IV;
     dbms_output.put_line('Auto-tuned Setting Currently:  '||SV||'MB');
   close c2;

   open c3;
     fetch c3 into NUM_SQL, NUM_EX1, TTLBYTES, EX1_MEMORY;
     dbms_output.put_line('   =======================================');
     dbms_output.put_line('  Number of stored Objects:  '||NUM_SQL||' >>> Number run Only Once:   '||NUM_EX1);
     dbms_output.put_line('  Memory for All Objects:   '||TTLBYTES||'MB >>> Memory for Non-Shared Code: '||EX1_MEMORY||'MB');
   close c3;
     dbms_output.put_line(' ');
     dbms_output.put_line('FINDINGS: ### Ideal to keep memory for non-shared code < 20% .... Actual here: '||round(100*
(EX1_MEMORY / TTLBYTES), 0)||'% ###');
end;
/

REM
REM  Investigate SGA components
REM     These queries do not impact performance on the database and you can run them 
REM     as often as you like
REM

set feed on
PROMPT 
PROMPT  ########## Auto-tuning Data ########## 
PROMPT  ########## NOTE: This Pulls Data From One Node Only ########## 
set feed off

set lines 120

col component for a25 head "Component"
col status format a10 head "Status"
col initial_size for 999,999,999,999 head "Initial"
col parameter for a25 heading "Parameter"
col final_size for 999,999,999,999 head "Final"
col changed head "Changed At"
col current_size for 999,999,999,999 head "Current Size"
col min_size for 999,999,999,999 head "Min Size"
col max_size for 999,999,999,999 head "Max Size"
col granule_size for 999,999,999,999 head "Granule Size"

select component, current_size, min_size, max_size, granule_size
from v$sga_dynamic_components
/

select component, parameter, initial_size, final_size, status, 
to_char(end_time ,'mm/dd/yyyy hh24:mi:ss') changed
from v$sga_resize_ops
/

REM 
REM   Investigate memory chunk stress in the Shared Pool
REM   It is safe to run these queries as often as you like.    
REM   Large memory misses in the Shared Pool
REM   will be attemped in the Reserved Area.    Another 
REM   failure in the Reserved Area causes an 4031 error
REM
REM   What should you look for?
REM   Reserved Pool Misses = 0 can mean the Reserved 
REM   Area is too big.  Reserved Pool Misses always increasing
REM   but "Shared Pool Misses" not increasing can mean the Reserved Area 
REM   is too small.  In this case flushes in the Shared Pool
REM   satisfied the memory needs and a 4031 was not actually
REM   reported to the user.  Reserved Area Misses and 
REM   "Shared Pool Misses" always increasing can mean 
REM   the Reserved Area is too small and flushes in the 
REM   Shared Pool are not helping (likely got an ORA-04031).
REM   

set feed on
PROMPT 
PROMPT  ########## Statistics on Misses and Uses of Memory in Shared Pool ########## 
PROMPT  ########## NOTE:  This Pulls Current Data From All Nodes ########## 
PROMPT
set feed off

col free_space format 999,999,999,999 head "Reserved|Free Space"
col max_free_size format 999,999,999,999 head "Reserved|Max"
col avg_free_size format 999,999,999,999 head "Reserved|Avg"
col used_space format 999,999,999,999 head "Reserved|Used"
col requests format 999,999,999,999 head "Total|Requests"
col request_misses format 999,999,999,999 head "Reserved|Area|Misses"
col last_miss_size format 999,999,999,999 head "Size of|Last Miss" 
col request_failures format 999,999,999 head "Shared|Pool|Misses"
col last_failure_size format 999,999,999,999 head "Failed|Size"

select instance_name, request_failures, last_failure_size, free_space, max_free_size, avg_free_size
from gv$shared_pool_reserved a, gv$instance b
where a.inst_id = b.inst_id
order by 1
/


select instance_name, used_space, requests, request_misses, last_miss_size
from gv$shared_pool_reserved a, gv$instance b
where a.inst_id = b.inst_id
order by 1
/

REM
REM Look at the breakdown of chunks for more detail on fragmentation.
REM This review data from a V$ view so is not the hit to performance
REM getting this data from X$ data dictionary views
REM

set feed on
PROMPT 
PROMPT  ########## Overview of Memory Chunk Data for Chunk Sizes and Average Sizes ########## 
PROMPT  ########## NOTE:  This Pulls Current Data From All Nodes ########## 
set feed off

col alloc_class format a12 head "Allocation|Class"
col average format 999,999.99 head "Average|Chunk|Size"
col maximum format 999,999 head "Maximum|Chunk|Size"

select instance_name, alloc_class, avg(chunk_size) average, max(chunk_size) maximum
from gv$sql_shared_memory a, gv$instance b
where a.inst_id=b.inst_id
group by instance_name, alloc_class
order by 1
/

REM
REM V$SGASTAT data over time leading up to the ORA-4031 errors
REM

set feed on
PROMPT
PROMPT  ########## Historic V$SGASTAT Data Leading to ORA-4031 Errors ########## 
PROMPT  ########## NOTE: This Pulls Data From One Node Only ########## 
set feed off

set lines 350

select n, 
   max(decode(to_char(begin_interval_time, 'hh24'), 1,bytes, null)) "1",
   max(decode(to_char(begin_interval_time, 'hh24'), 2,bytes, null)) "2",
   max(decode(to_char(begin_interval_time, 'hh24'), 3,bytes, null)) "3",
   max(decode(to_char(begin_interval_time, 'hh24'), 4,bytes, null)) "4",
   max(decode(to_char(begin_interval_time, 'hh24'), 5,bytes, null)) "5",
   max(decode(to_char(begin_interval_time, 'hh24'), 6,bytes, null)) "6",
   max(decode(to_char(begin_interval_time, 'hh24'), 7,bytes, null)) "7",
   max(decode(to_char(begin_interval_time, 'hh24'), 8,bytes, null)) "8",
   max(decode(to_char(begin_interval_time, 'hh24'), 9,bytes, null)) "9",
   max(decode(to_char(begin_interval_time, 'hh24'), 10,bytes, null)) "10",
   max(decode(to_char(begin_interval_time, 'hh24'), 11,bytes, null)) "11",
   max(decode(to_char(begin_interval_time, 'hh24'), 12,bytes, null)) "12",
   max(decode(to_char(begin_interval_time, 'hh24'), 13,bytes, null)) "13",
   max(decode(to_char(begin_interval_time, 'hh24'), 14,bytes, null)) "14",
   max(decode(to_char(begin_interval_time, 'hh24'), 15,bytes, null)) "15",
   max(decode(to_char(begin_interval_time, 'hh24'), 16,bytes, null)) "16",
   max(decode(to_char(begin_interval_time, 'hh24'), 17,bytes, null)) "17",
   max(decode(to_char(begin_interval_time, 'hh24'), 18,bytes, null)) "18",
   max(decode(to_char(begin_interval_time, 'hh24'), 19,bytes, null)) "19",
   max(decode(to_char(begin_interval_time, 'hh24'), 20,bytes, null)) "20",
   max(decode(to_char(begin_interval_time, 'hh24'), 21,bytes, null)) "21",
   max(decode(to_char(begin_interval_time, 'hh24'), 22,bytes, null)) "22",
   max(decode(to_char(begin_interval_time, 'hh24'), 23,bytes, null)) "23",
   max(decode(to_char(begin_interval_time, 'hh24'), 24,bytes, null)) "24"
from (select '"'||name||'"' n, begin_interval_time, bytes from dba_hist_sgastat a, dba_hist_snapshot b 
where pool='shared pool' and a.snap_id=b.snap_id
and to_char(begin_interval_time,'YYYY dd-Mon HH24') >= '&&start'
and to_char(begin_interval_time,'YYYY dd-Mon HH24')  <= '&&endd')
group by n
/

REM 
REM Hit Ratio information leading up the ORA-4031 errors
REM
REM   This is applicable to Shared Pool errors only
REM

set lines 150

set feed on
PROMPT 
PROMPT  ########## Historic Hit Ratio Data Leading up to the ORA-4031 Errors ########## 
PROMPT  ##########   Reload Ratio to Total Loads Should Ideally be <= 10%    ##########
PROMPT  ##########  Reload Ratio to Invalidations Should Ideally be <= 20%   ##########
PROMPT  ##########         NOTE: This Pulls Data From One Node Only          ########## 
set feed off

col time format a20 head "Time Stamp"
col name format a5 head "Name"
col gets format 999,999,999,999,999 head "Gets"
col g_hits format 99.9 head "Gets|Ratio"
col pins format 999,9999,999,9999 head "Pins"
col p_hits format 99.9 head "Pins|Ratio"
col reloads format 999,999,999,999 head "Reloads"
col r_hits format 99.9 head "Reloads|Ratio To|Pins"
col r1_hits format 99.9 head "Reloads|Ratio To|Total Loads"
col invalidations format 999,999,999,999 head "Invalidations"
col inv_hits format 999.9 head "Invalids|Ratio To|Reloads"

select to_char(begin_interval_time, 'yyyy dd-Mon hh24:mi') Time, 
  decode(namespace,'SQL AREA','CRSR',namespace) name,
  gets, (gethits/gets)*100 g_hits, 
  pins, (pinhits/pins)*100 p_hits, 
  reloads, (reloads/pins)*100 r_hits,
  ((reloads-(greatest(reloads-invalidations,0)))/(pins-pinhits))*100 r1_hits, 
  invalidations, (invalidations/reloads)*100 inv_hits
from dba_hist_librarycache a, dba_hist_snapshot b
where a.snap_id=b.snap_id
and namespace='SQL AREA'
and to_char(begin_interval_time, 'yyyy dd-Mon hh24:mi') >= '&&start'
and to_char(begin_interval_time, 'yyyy dd-Mon hh24:mi') <= '&&endd'
order by 1
/


REM 
REM SQL Area Statistics
REM

PROMPT
PROMPT  ########## SQL Area Statistics ########## 
PROMPT  ########## NOTE: This Pulls Data From One Node Only ########## 
PROMPT

declare
   MaxInv   number(15);
   MaxVers  number(11);
   MaxVCNT  number(15);
   MaxShare number(15);

   cursor code is select max(invalidations), max(loaded_versions), max(version_count), 
                         max(sharable_mem) from v$sqlarea;

begin
   open code;
   fetch code into MaxInv, MaxVers, MaxVCNT, MaxShare;

   dbms_output.put_line('====================================');
   dbms_output.put_line('HWM Information:');
   dbms_output.put_line('----- Max Invalidations:      '||to_char(MaxInv,'999,999,999,999'));
   dbms_output.put_line('----- Max Versions Loaded:        '||to_char(MaxVers,'999,999,999'));
   dbms_output.put_line('----- Versions HWM:           '||to_char(MaxVCNT,'999,999,999,999'));
   dbms_output.put_line('----- Largest Memory object:  '||to_char(MaxShare,'999,999,999,999'));
   dbms_output.put_line('====================================');
end;
/

REM 
REM  Check for shared cursor problems
REM

set feed on
PROMPT
PROMPT  ########## Check How Efficiently Cursors Are Shared ##########  
PROMPT  ##########      Ideal Findings Is 80 or Higher ##########  
PROMPT  ########## NOTE: This Pulls Data From One Node Only ########## 
set feed off

col "Eff Ratio" format 99 head "Shared|Cursor|Ratio"

select 100-(100*(share_mem/sp_size)) "Eff Ratio"
from (select bytes sp_size from v$sgainfo where name='Shared Pool Size'),
      (select sum(sharable_mem+persistent_mem+runtime_mem) share_mem
           from v$sqlarea where executions=1);


REM  
REM   LRU Statistics
REM     Needs to be run as SYS (/ as sysdba)
REM
REM   Recurrent objects are those that have been used over and over.
REM   They will tend to be further up on the LRU list and less likely
REM   to flush out.
REM   Transient objects are those that have used only once.   They
REM   are candidates for flushing when needed (depending on their
REM   duration).   Duration of 0 and 1 will remain in the LRU list 
REM   the longest.   
REM   0 - Perm structures (Instance Duration)
REM  1 - Session structures (Session Duration)
REM  2 - Cursor sturctures
REM  3 - Execution structures (variables, arrays, etc.) -shortest lives
REM

set feed on
PROMPT 
PROMPT  ########## LRU Statistics Currently ########## 
PROMPT  ########## NOTE: This Pulls Data From One Node Only ########## 
set feed off

col addr head "SGA Address"
col indx format 9999 head "Index|No"
col kghludur format 999 head "Duration"
col inst_id format 999 head "Innstance|No"
col kghluidx format 999 head "Subpool"
col kghlushrpool format 999,999,999,999 head "SH Pool"
col kghlufsh format 999,999,999,999 head "Count of|Flushed Items"
col kghluops format 999,999,999,999 head "Changes to LRU"
col kghlurcr format 999,999,999,999 head "Count Recurrent"
col kghlutrn format 999,999,999,999 head "Count Transient"
col kghlumxa format 999,999,999,999 head "Alloc Limit"
col kghlumes format 999,999,999,999 Head "Size Request|Over Alloc Limit"
col kghlumer format 999,999,999,999 head "# Exceeded|Alloc Limit"
col kghlurcn format 999,999,999,999 head "No of scans|Reserved"
col kghlurmi format 999,999,999,999 head "No of Misses|Reserved"
col kghlurmz format 999,999,999,999 head "Max Reserved|Size Missed"
col kghlurmx format 999,999,999,999 head "Max Missed|Size"
col kghlunfu format 999,999,999,999 head "No of Times|Looped"
col kghlunfs format 999,999,999,999 head "Last Failed|Size"

select   kghluidx, kghludur, kghlurcr,  kghlutrn,  kghlufsh,  kghluops,  kghlunfu,  kghlunfs
from  sys.x$kghlu
where  inst_id = userenv('Instance');

REM
REM  for 11.2 and higher

set feed on
PROMPT 
PROMPT  ########## Memory Usage Associated with Cached Cursors ########## 
set feed off


col instance_name format a30 head "Instance"
col cursor_type format a24 head "Cursor Type"
col mb format 999,999.99 head "MBytes per Type"

select d.instance_name, c.CURSOR_TYPE, sum(a.sharable_mem)/1024/1024 mb
from   GV$OPEN_CURSOR c, gv$sql a, gv$instance d
where  c.hash_value=a.hash_value
and    c.CURSOR_TYPE='SESSION CURSOR CACHED'
and    a.inst_id = d.inst_id
group by d.instance_name, c.CURSOR_TYPE
/

select instance_name, name, bytes, resizeable 
from gv$sgainfo a, gv$instance b
where a.inst_id = b.inst_id


spool off
set termout on
set verify on
set termout on
set feed on

