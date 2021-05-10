rem created rordona 12/01/2006
set head on
set pages 5000
set lines 1000
set verify off
set trimspool on
set trimout on
set feed off
set echo off
set time off
set timing off
set numformat 99.9
var sqlid varchar2(20);
var minutes varchar2(20);

var bsnap number;
var esnap number;
var instance_number number;
exec :bsnap := &begin_snap_id - 1;
exec :esnap := &end_snap_id;
REM exec :instance_number := &instance_number;
REM exec select instance_number into :instance_number from  v$instance;

PROMPT Enter location of report.
column report_type new_value report_type

accept location char default '/tmp/s.lst'  prompt 'Enter a location (default /tmp/s.lst): '

alter session set nls_date_format = 'DD-MON-RR/HH24:MI:SS';

spool &&location

set head off
select '" SNAPSHOT: ' || :bsnap || '-' || :esnap || '"' from dual;
set head on

PROMPT "Time Model"
PROMPT "~~~~~~~~~~"

col instance_number heading  '.|Ins|No'  jus l null 'N/A' format 999999
col ttime   heading        '.|.|Date' jus r null 'N/A' format a20


col db_time heading            '.|DB.Time' jus r null 'N/A' format 99,999,999,999
col db_cpu heading             '.|DB.CPU' jus r null 'N/A' format 99,999,999,999
col perc_cpu heading           '.|%CPU' jus r null 'N/A' format 999.99
col seq_load heading           'sequence|load' jus r null 'N/A' format 99,999,999
col parse_time heading         'parse|time' jus r null 'N/A' format 99,999,999
col hard_parse heading         'hard|parse' jus r null 'N/A' format 999,999,999
col sql_exec heading           'SQL|Exec' jus r null 'N/A' format 999,999,999,999
col connection_mgmt heading    'Connection|Mgmt' jus r null 'N/A' format 999,999,999
col failed_parse heading       'Failed|Parse' jus r null 'N/A' format 999,999,999
col failed_parse_oosm heading  'Failed.Parse|(Out.of.Shared.Mem)'jus r null 'N/A' format 999,999
col hard_parse_Sc heading      'Hard.Parse|(Sharing.Criteria)' jus r null 'N/A' format 999,999,999
col hard_parse_bm heading      'Hard.Parse|(Bind.Mismatch)'jus r null 'N/A' format 999,999,999
col plsql_exec heading         'PLSQL|Exec' jus r null 'N/A' format 9,999,999
col inbound_plsql_rpc heading  'Inbound|PLSQL.RPC' jus r null 'N/A' format 99,999,999
col plsql_compilation  heading 'PLSQL|Compilation' jus r null 'N/A' format 99,999,999
col java_execution  heading 'JAVA|Exec' jus r null 'N/A' format 99,999,999
col repeat_bind  heading 'Repeat|Bind' jus r null 'N/A' format 99,999,999
col rman_cpu  heading 'rman|cpu' jus r null 'N/A' format 99,999

-- break on instance skip 1
-- break on instance_number skip 1

select 
       rpad(to_char(instance_number),6) instance_number,
       trunc(end_interval_time,'HH24') ttime,
       round(sum(db_time)/1000000,2) db_time,
       round(sum(db_cpu)/1000000,2) db_cpu,
       round(sum(db_cpu)/sum(db_time)*100,2) perc_cpu,
       round(sum(seq_load)/1000000,2) seq_load,
       round(sum(parse_time)/1000000,2) parse_time,
       round(sum(hard_parse)/1000000,2) hard_parse,
       round(sum(sql_exec)/1000000,2) sql_exec,
       nvl(round(sum(connection_mgmt)/1000000,2),0) connection_mgmt,
       nvl(round(sum(failed_parse)/1000000,2),0) failed_parse,
       nvl(round(sum(failed_parse_oosm)/1000000,2),0) failed_parse_oosm,
       nvl(round(sum(hard_parse_sc)/1000000,2),0) hard_parse_sc,
       nvl(round(sum(hard_parse_bm)/1000000,2),0) hard_parse_bm,
       nvl(round(sum(plsql_exec)/1000000,2),0) plsql_exec,
       nvl(round(sum(inbound_plsql_rpc)/1000000,2),0) inbound_plsql_rpc,
       nvl(round(sum(plsql_compilation)/1000000,2),0) plsql_compilation,
       nvl(round(sum(java_Execution)/1000000,2),0) java_Execution,
       nvl(round(sum(repeat_bind)/1000000,2),0) repeat_bind,
       nvl(round(sum(rman_cpu)/1000000,2),0) rman_cpu
from
(
select s.snap_id, s.end_interval_time, s.instance_number,
    case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and  stat_name = 'DB time' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
          value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
          value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end db_time,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'DB CPU' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end db_cpu,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'sequence load elapsed time' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end seq_load,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'parse time elapsed' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end parse_time,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and  stat_name = 'hard parse elapsed time' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end hard_parse,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'sql execute elapsed time' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end sql_exec,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'connection management call elapsed time' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end connection_mgmt,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and  stat_name = 'failed parse elapsed time' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end failed_parse,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'failed parse (out of shared memory) elapsed time' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end failed_parse_oosm,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and  stat_name = 'hard parse (sharing criteria) elapsed time' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end hard_parse_sc,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and  stat_name = 'hard parse (bind mismatch) elapsed time' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end hard_parse_bm,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'PL/SQL execution elapsed time' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end plsql_exec,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'inbound PL/SQL rpc elapsed time' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end inbound_plsql_rpc,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'PL/SQL compilation elapsed time' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end plsql_compilation,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'Java execution elapsed time' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end java_Execution,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'repeated bind elapsed time' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end repeat_bind,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'RMAN cpu time (backup/restore)' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end rman_cpu
from
   dba_hist_sys_time_model        ss,
   dba_hist_snapshot         s
where
   s.snap_id = ss.snap_id
   and s.snap_id between :bsnap and  :esnap
   and ss.instance_number = s.instance_number
   and ss.stat_name  in
                         ('DB time',
			'DB CPU',
			'background elapsed time',
			'background cpu time',
			'sequence load elapsed time',
			'parse time elapsed',
			'hard parse elapsed time',
			'sql execute elapsed time',
			'connection management call elapsed time',
			'failed parse elapsed time',
			'failed parse (out of shared memory) elapsed time',
			'hard parse (sharing criteria) elapsed time',
			'hard parse (bind mismatch) elapsed time',
			'PL/SQL execution elapsed time',
			'inbound PL/SQL rpc elapsed time',
			'PL/SQL compilation elapsed time',
			'Java execution elapsed time',
			'repeated bind elapsed time',
			'RMAN cpu time (backup/restore)'
)
         and ss.value          >  0
) where snap_id > :bsnap
group by rpad(to_char(instance_number),6), trunc(end_interval_time,'HH24')
order by instance_number, trunc(end_interval_time,'HH24');

PROMPT
PROMPT "OS Statistics"
PROMPT "~~~~~~~~~~~~~"

col Num_Cpus heading '.|No.CPUs' jus r null 'N/A' format 999
col perc_busy heading '.|%Busy' jus r null 'N/A' format 999.99
col perc_idle heading '.|%Idle' jus r null 'N/A' format 999.99
col perc_user heading '.|%User' jus r null 'N/A' format 999.99
col perc_sys heading '.|%Sys' jus r null 'N/A' format 999.99
col perc_iowait heading '.|%iowait' jus r null 'N/A' format 999.99
col Busy_Time heading 'Busy|Time' jus r null 'N/A' format 9,999,999.99
col Idle_Time heading 'Idle|Time' jus r null 'N/A' format 9,999,999.99
col User_Time heading 'User|Time' jus r null 'N/A' format 9,999,999.99
col Sys_Time heading 'System|Time' jus r null 'N/A' format 9,999,999.99
col IOWait_Time heading 'IOWait|Time' jus r null 'N/A' format 999,999,999.99
col Nice_Time heading 'Nice|Time' jus r null 'N/A' format 999,999.99
col Load heading '.|Load' jus r null 'N/A' format 999,999.99
col Snap_Id heading "Snap|Id" jus r null 'N/A' format 99999

select 
       rpad(to_char(instance_number),6) instance_number,
       trunc(end_interval_time,'HH24') ttime,
       sum(Num_Cpus) Num_Cpus,
       ( sum(Busy_Time)/100   ) /( sum(Busy_Time)/100+ sum(Idle_Time)/100)*100 perc_busy,
       ( sum(Idle_Time)/100   ) /( sum(Busy_Time)/100+ sum(Idle_Time)/100)*100 perc_idle,
       ( sum(User_Time)/100   ) /( sum(Busy_Time)/100+ sum(Idle_Time)/100)*100 perc_user,
       ( sum(Sys_Time)/100    ) /( sum(Busy_Time)/100+ sum(Idle_Time)/100)*100 perc_sys,
       ( sum(IOWait_Time)/100 ) /( sum(Busy_Time)/100+ sum(Idle_Time)/100)*100 perc_iowait,
       sum(Busy_Time)/100 Busy_Time,
       sum(Idle_Time)/100 Idle_Time,
       sum(User_Time)/100 User_Time,
       sum(Sys_Time)/100 Sys_Time,
       sum(IOWait_Time)/100 IOWAIT_Time,
       nvl(sum(Nice_Time)/100,0) Nice_Time,
       nvl(sum(Load),0) Load
from
(
select s.snap_id, s.end_interval_time, s.instance_number,
    case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and  stat_name = 'NUM_CPUS' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
          value >= lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
          value
       end Num_Cpus,
    case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and  stat_name = 'BUSY_TIME' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
          value >= lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
          value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end Busy_time,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'IDLE_TIME' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value >= lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end Idle_time,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'USER_TIME' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value >= lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end User_time,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'SYS_TIME' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value >= lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end Sys_time,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and  stat_name = 'IOWAIT_TIME' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value >= lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end Iowait_time,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'NICE_TIME' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value >= lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end Nice_time,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'LOAD' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value >= lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end Load
from
   dba_hist_osstat        ss,
   dba_hist_snapshot         s
where
   s.snap_id = ss.snap_id
   and s.snap_id between :bsnap and  :esnap
   and ss.instance_number = s.instance_number
)where snap_id > :bsnap
group by rpad(to_char(instance_number),6), trunc(end_interval_time,'HH24')
order by instance_number, trunc(end_interval_time,'HH24');

PROMPT
PROMPT "LOAD PROFILE per SECOND"
PROMPT "~~~~~~~~~~~~~~~~~~~~~~~"

col HParse heading 'Hard|Parse' jus r null 'N/A' format 99,99.99
col Sess heading 'Sessions|(not.per.sec)' jus r null 'N/A' format 99,999
col Cursor_Per_Session heading 'Cursor/session|(not.per.sec)' jus r null 'N/A' format 9,999.99
col Parse heading '.|Parse'  jus r null 'N/A' format 99,999.99
col PhysWrt heading 'Physical|Write Req' jus r null 'N/A' format 9,999.99
col PhysRd heading 'Physical|Reads Req' jus r null 'N/A' format 999,999.99
col RedoSz heading 'Redo|Size' jus r null 'N/A' format 999,999,999.99
col RedoWrt heading 'Redo|Writes' jus r null 'N/A' format 999,999.99
col LogicalRds heading 'Logical|Reads' jus r null 'N/A' format 999,999,999.99
col Ucalls heading 'User|Calls' jus r null 'N/A' format 999,999.99
col Sorts heading '.|Sorts' jus r null 'N/A' format 999,999.99
col Lgns heading '.|Logons' jus r null 'N/A' format 999.99
col Execs heading '.|Execs' jus r null 'N/A' format 999,999.99
col BlkChg heading 'Block|Changes' jus r null 'N/A' format 9,999,999.99
col Txn heading '.|Transactions' jus r null 'N/A' format 99,999.99
col Snap_Id heading "Snap|Id" jus r null 'N/A' format 99999

select 
       rpad(to_char(instance_number),6) instance_number,
       trunc(end_interval_time,'HH24') ttime,
       sum(Sess) Sess,
       sum(Cursor)/sum(Sess) Cursor_per_Session,
       sum(RedoSz)/sum(rs_elapse_sec) RedoSz,
       sum(Redo_Writes)/sum(rw_elapse_sec) RedoWrt,
       sum(BlkChg)/sum(bc_elapse_sec) BlkChg,
       sum(PhysWrt)/sum(pw_elapse_sec) PhysWrt,
       sum(PhysRd)/sum(pr_elapse_sec) PhysRd,
       sum(LogicalRd)/sum(lr_elapse_sec) LogicalRds,
       sum(UserCalls)/sum(uc_elapse_sec) UCalls,
       sum(Parse_Hard)/sum(ph_elapse_sec) HParse,
       sum(Parse)/sum(p_elapse_sec) Parse,
       sum(Sorts)/sum(s_elapse_sec) Sorts,
       sum(Logons)/sum(l_elapse_sec) Lgns,
       sum(Execute)/sum(e_elapse_sec) Execs,
       sum(Txn)/sum(t_elapse_sec) Txn
from
(
select s.snap_id, s.end_interval_time, s.instance_number,
    case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and  stat_name = 'logons current' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
          value
       end Sess,
    case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and  stat_name = 'opened cursors current' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value
       end Cursor,
    case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and  stat_name = 'parse count (hard)' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
          value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
          value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end Parse_Hard,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'redo writes' and 
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end redo_writes,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'parse count (total)' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end Parse,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'physical write IO requests' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end PhysWrt,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and  stat_name = 'physical read IO requests' and 
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end PhysRd,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'redo size' and 
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end RedoSz,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'session logical reads' and 
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end LogicalRd,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and  stat_name = 'user calls' and 
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end UserCalls,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'sorts (memory)' and 
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end Sorts,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and  stat_name = 'logons cumulative' and 
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end Logons,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and  stat_name = 'execute count' and 
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end Execute,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'db block changes' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end BlkChg,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'user commits' and 
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end Txn,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'user rollbacks' and 
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end Txn_Rb,
      case when stat_name = 'redo size' then
       extract(second from (end_interval_time-begin_interval_time))+
       extract(minute from (end_interval_time-begin_interval_time))*60+
       extract(hour from (end_interval_time-begin_interval_time))*3600
      end rs_Elapse_Sec,
      case when stat_name = 'redo writes' then
       extract(second from (end_interval_time-begin_interval_time))+
       extract(minute from (end_interval_time-begin_interval_time))*60+
       extract(hour from (end_interval_time-begin_interval_time))*3600
      end rw_Elapse_Sec,
      case when stat_name = 'db block changes' then
       extract(second from (end_interval_time-begin_interval_time))+
       extract(minute from (end_interval_time-begin_interval_time))*60+
       extract(hour from (end_interval_time-begin_interval_time))*3600
      end bc_Elapse_Sec,
      case when stat_name = 'physical write IO requests' then
       extract(second from (end_interval_time-begin_interval_time))+
       extract(minute from (end_interval_time-begin_interval_time))*60+
       extract(hour from (end_interval_time-begin_interval_time))*3600
      end pw_Elapse_Sec,
      case when stat_name = 'physical read IO requests' then
       extract(second from (end_interval_time-begin_interval_time))+
       extract(minute from (end_interval_time-begin_interval_time))*60+
       extract(hour from (end_interval_time-begin_interval_time))*3600
      end pr_Elapse_Sec,
      case when stat_name = 'session logical reads' then
       extract(second from (end_interval_time-begin_interval_time))+
       extract(minute from (end_interval_time-begin_interval_time))*60+
       extract(hour from (end_interval_time-begin_interval_time))*3600
      end lr_Elapse_Sec,
      case when stat_name = 'user calls' then
       extract(second from (end_interval_time-begin_interval_time))+
       extract(minute from (end_interval_time-begin_interval_time))*60+
       extract(hour from (end_interval_time-begin_interval_time))*3600
      end uc_Elapse_Sec,
      case when stat_name = 'parse count (hard)' then
       extract(second from (end_interval_time-begin_interval_time))+
       extract(minute from (end_interval_time-begin_interval_time))*60+
       extract(hour from (end_interval_time-begin_interval_time))*3600
      end ph_Elapse_Sec,
      case when stat_name = 'parse count (total)' then
       extract(second from (end_interval_time-begin_interval_time))+
       extract(minute from (end_interval_time-begin_interval_time))*60+
       extract(hour from (end_interval_time-begin_interval_time))*3600
      end p_Elapse_Sec,
      case when stat_name = 'sorts (memory)' then
       extract(second from (end_interval_time-begin_interval_time))+
       extract(minute from (end_interval_time-begin_interval_time))*60+
       extract(hour from (end_interval_time-begin_interval_time))*3600
      end s_Elapse_Sec,
      case when stat_name = 'logons cumulative' then
       extract(second from (end_interval_time-begin_interval_time))+
       extract(minute from (end_interval_time-begin_interval_time))*60+
       extract(hour from (end_interval_time-begin_interval_time))*3600
      end l_Elapse_Sec,
      case when stat_name = 'execute count' then
       extract(second from (end_interval_time-begin_interval_time))+
       extract(minute from (end_interval_time-begin_interval_time))*60+
       extract(hour from (end_interval_time-begin_interval_time))*3600
      end e_Elapse_Sec,
      case when stat_name = 'user rollbacks' then
       extract(second from (end_interval_time-begin_interval_time))+
       extract(minute from (end_interval_time-begin_interval_time))*60+
       extract(hour from (end_interval_time-begin_interval_time))*3600
      end t_Elapse_Sec
from
   dba_hist_sysstat        ss,
   dba_hist_snapshot         s
where
   s.snap_id = ss.snap_id
   and s.snap_id between :bsnap and  :esnap
   and ss.instance_number = s.instance_number
   and ss.stat_name  in
                         ('parse count (hard)',
                          'parse count (total)',
                          'logons current',
			  'opened cursors current',
                          'physical write IO requests',
                          'physical read IO requests',
                          'redo size',
                          'session logical reads',
                          'user calls',
                          'sorts (memory)',
                          'logons cumulative',
                          'execute count',
                          'db block changes',
                          'user commits',
                          'redo writes',
                          'user rollbacks')
         and ss.value          >  0
) where snap_id > :bsnap
group by rpad(to_char(instance_number),6), trunc(end_interval_time,'HH24')
order by instance_number, trunc(end_interval_time,'HH24');

PROMPT
PROMPT "LOAD PROFILE per TRANSACTION"
PROMPT "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

select 
       rpad(to_char(instance_number),6) instance_number,
       trunc(end_interval_time,'HH24') ttime,
       sum(RedoSz)/(sum(Txn)+sum(Txn_Rb)) RedoSz,
       sum(Redo_Writes)/(sum(Txn)+sum(Txn_Rb)) RedoWrt,
       sum(BlkChg)/(sum(Txn)+sum(Txn_Rb)) BlkChg,
       sum(PhysWrt)/(sum(Txn)+sum(Txn_Rb)) PhysWrt,
       sum(PhysRd)/(sum(Txn)+sum(Txn_Rb)) PhysRd,
       sum(LogicalRd)/(sum(Txn)+sum(Txn_Rb)) LogicalRds,
       sum(UserCalls)/(sum(Txn)+sum(Txn_Rb)) UCalls,
       sum(Parse_Hard)/(sum(Txn)+sum(Txn_Rb)) HParse,
       sum(Parse)/(sum(Txn)+sum(Txn_Rb)) Parse,
       sum(Sorts)/(sum(Txn)+sum(Txn_Rb)) Sorts,
       sum(Logons)/(sum(Txn)+sum(Txn_Rb)) Lgns,
       sum(Execute)/(sum(Txn)+sum(Txn_Rb)) Execs
from
(
select s.snap_id, s.end_interval_time, s.instance_number,
    case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and  stat_name = 'parse count (hard)' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
          value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
          value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end Parse_Hard,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'redo writes' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end redo_writes,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'parse count (total)' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end Parse,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'physical write IO requests' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end PhysWrt,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and  stat_name = 'physical read IO requests' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end PhysRd,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'redo size' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end RedoSz,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'session logical reads' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end LogicalRd,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and  stat_name = 'user calls' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end UserCalls,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'sorts (memory)' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end Sorts,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and  stat_name = 'logons cumulative' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end Logons,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and  stat_name = 'execute count' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end Execute,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'db block changes' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end BlkChg,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'user commits' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end Txn,
      case when stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,s.snap_id) and stat_name = 'user rollbacks' and
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,s.snap_id) and
         value > lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id) then
         value - lag(value) over (order by ss.stat_name,ss.instance_number,s.snap_id)
       end Txn_Rb
from
   dba_hist_sysstat        ss,
   dba_hist_snapshot         s
where
   s.snap_id = ss.snap_id
   and s.snap_id between :bsnap and  :esnap
   and ss.instance_number = s.instance_number
   and ss.stat_name  in
                         ('parse count (hard)',
                          'parse count (total)',
                          'physical write IO requests',
                          'physical read IO requests',
                          'redo size',
                          'session logical reads',
                          'user calls',
                          'sorts (memory)',
                          'logons cumulative',
                          'execute count',
                          'db block changes',
                          'user commits',
                          'redo writes',
                          'user rollbacks')
         and ss.value          >  0
) where snap_id > :bsnap
group by rpad(to_char(instance_number),6), trunc(end_interval_time,'HH24')
order by instance_number, trunc(end_interval_time,'HH24');

PROMPT
PROMPT "Metric Summary"
PROMPT "~~~~~~~~~~~~~~"

col snap_id jus r null 'N/A' format 99999
col cpu_per_sec heading 'CPU|per.sec(avg)' jus r null 'N/A' format 99,999.99
col cpu_per_sec_sd heading 'CPU|per.sec(sd)' jus r null 'N/A' format 99,999.99
col cpu_per_txn heading 'CPU|per.txn' jus r null 'N/A' format  99,999.99
col db_cpu_ratio heading 'DB.CPU|Ratio' jus r null 'N/A' format 99,999.99
col db_wait_ratio heading 'DB.Wait|Ratio' jus r null 'N/A' format 99,999.99
col exec_per_sec heading 'Exec|per.sec' jus r null 'N/A' format 99,999.99
col exec_per_txn heading 'Exec|per.txn'  jus r null 'N/A' format 99,999.99
col respn_per_sec heading 'Response|per.sec' jus r null 'N/A' format 99,999.99
col respn_per_txn heading 'Response|per.txn' jus r null 'N/A' format 99,999.99
col sql_respn heading 'SQL.Response|Time' jus r null 'N/A' format 99,999.99
col user_txn_per_sec heading 'User.Txn|per.sec'  jus r null 'N/A' format 999.99


select 
       rpad(to_char(instance_number),6) instance_number,
       trunc(end_interval_time,'HH24') ttime,
        sum(cpu_per_sec_avg) cpu_per_sec,
        sum(cpu_per_sec_sd) cpu_per_sec_sd,
        sum(cpu_per_txn_avg) cpu_per_txn,
        sum(db_cpu_ratio_avg) db_cpu_ratio,
        sum(db_wait_ratio_avg) db_wait_ratio,
        sum(exec_per_sec_avg) exec_per_sec,
        sum(exec_per_txn_avg) exec_per_txn,
        sum(respn_per_txn_avg) respn_per_txn,
        sum(sql_respn_time_avg) sql_respn,
        sum(user_txn_per_sec_avg) user_txn_per_sec
from
(
select s.snap_id, s.end_interval_time, s.instance_number,
case when metric_name = 'CPU Usage Per Sec' then
         minval
end cpu_per_sec_min,
case when metric_name = 'CPU Usage Per Sec' then
         maxval
end cpu_per_sec_max,
case when metric_name = 'CPU Usage Per Sec' then
         average
end cpu_per_sec_avg,
case when metric_name = 'CPU Usage Per Sec' then
         standard_deviation
end cpu_per_sec_sd,
case when metric_name = 'CPU Usage Per Txn' then
         minval
end cpu_per_txn_min,
case when metric_name = 'CPU Usage Per Txn' then
         maxval
end cpu_per_txn_max,
case when metric_name = 'CPU Usage Per Txn' then
         average
end cpu_per_txn_avg,
case when metric_name = 'CPU Usage Per Txn' then
         standard_deviation
end cpu_per_txn_sd,
case when metric_name = 'Database CPU Time Ratio' then
         minval
end db_cpu_ratio_min,
case when metric_name = 'Database CPU Time Ratio' then
         maxval
end db_cpu_ratio_max,
case when metric_name = 'Database CPU Time Ratio' then
         average
end db_cpu_ratio_avg,
case when metric_name = 'Database CPU Time Ratio' then
         standard_deviation
end db_cpu_ratio_sd,
case when metric_name = 'Database Wait Time Ratio' then
         minval
end db_wait_ratio_min,
case when metric_name = 'Database Wait Time Ratio' then
         maxval
end db_wait_ratio_max,
case when metric_name = 'Database Wait Time Ratio' then
         average
end db_wait_ratio_avg,
case when metric_name = 'Database Wait Time Ratio' then
         standard_deviation
end db_wait_ratio_sd,
case when metric_name = 'Executions Per Sec' then
         minval
end exec_per_sec_min,
case when metric_name = 'Executions Per Sec' then
         maxval
end exec_per_sec_max,
case when metric_name = 'Executions Per Sec' then
         average
end exec_per_sec_avg,
case when metric_name = 'Executions Per Sec' then
         standard_deviation
end exec_per_sec_sd,
case when metric_name = 'Executions Per Txn' then
         minval
end exec_per_txn_min,
case when metric_name = 'Executions Per Txn' then
         maxval
end exec_per_txn_max,
case when metric_name = 'Executions Per Txn' then
         average
end exec_per_txn_avg,
case when metric_name = 'Executions Per Txn' then
         standard_deviation
end exec_per_txn_sd,
case when metric_name = 'Response Time Per Sec' then
         minval
end respn_per_sec_min,
case when metric_name = 'Response Time Per Sec' then
         maxval
end respn_per_sec_max,
case when metric_name = 'Response Time Per Sec' then
         average
end respn_per_sec_avg,
case when metric_name = 'Response Time Per Sec' then
         standard_deviation
end respn_per_sec_sd,
case when metric_name = 'Response Time Per Txn' then
         minval
end respn_per_txn_min,
case when metric_name = 'Response Time Per Txn' then
         maxval
end respn_per_txn_max,
case when metric_name = 'Response Time Per Txn' then
         average
end respn_per_txn_avg,
case when metric_name = 'Response Time Per Txn' then
         standard_deviation
end respn_per_txn_sd,
case when metric_name = 'SQL Service Response Time' then
         minval
end sql_respn_time_min,
case when metric_name = 'SQL Service Response Time' then
         maxval
end sql_respn_time_max,
case when metric_name = 'SQL Service Response Time' then
         average
end sql_respn_time_avg,
case when metric_name = 'SQL Service Response Time' then
         standard_deviation
end sql_respn_time_sd,
case when metric_name = 'User Transaction Per Sec' then
         minval
end user_txn_per_sec_min,
case when metric_name = 'User Transaction Per Sec' then
         maxval
end user_txn_per_sec_max,
case when metric_name = 'User Transaction Per Sec' then
         average
end user_txn_per_sec_avg,
case when metric_name = 'User Transaction Per Sec' then
         standard_deviation
end user_txn_per_sec_sd
from    dba_hist_sysmetric_summary hs,
        dba_hist_snapshot s
where
   s.snap_id = hs.snap_id
   and s.snap_id between :bsnap and  :esnap
   and hs.instance_number = s.instance_number
   and metric_name in ('CPU Usage Per Sec',
                      'CPU Usage Per Txn',
                      'Database CPU Time Ratio',
                      'Database Wait Time Ratio',
                      'Executions Per Sec',
                      'Executions Per Txn',
                      'Response Time Per Txn',
                      'Response Time Per Sec',
                      'SQL Service Response Time',
                      'User Transaction Per Sec')
) where snap_id > :bsnap
group by rpad(to_char(instance_number),6), trunc(end_interval_time,'HH24')
order by instance_number, trunc(end_interval_time,'HH24');


PROMPT
PROMPT "System Statistics - REDO"
PROMPT "~~~~~~~~~~~~~~~~~~~~~~~~"

col stat_name heading "-|IO" jus r null 'N/A' format a50
col redo_size heading "Redo|Size" jus r null 'N/A' format 999,999,999,999
col redo_writes heading "Redo|Writes" jus r null 'N/A' format  999,999,999
col redo_blocks_written heading "Redo.Blocks|Written" jus r null 'N/A' format 999,999,999
col redo_write_time heading "Redo.Write|Time" jus r null 'N/A' format  999,999,999
col redo_log_space_req heading "Redo.Log|Space.Requests" jus r null 'N/A' format 999,999,999
col redo_buffer_alloc_retries heading "Redo.Buffer|Alloc.Retries" jus r null 'N/A' format 999,999,999
col redo_entries heading "Redo|Entries" jus r null 'N/A' format 999,999,999,999
col flashback_log heading "Flashback|Log.Writes" jus r null 'N/A' format 999,999,999,999



select 
    rpad(to_char(s1.instance_number),6) instance_number, 
    trunc(end_interval_time,'HH24') ttime,
    sum(case when s1.stat_name = 'redo size' then s1.stat_value end) redo_size,
    sum(case when s1.stat_name = 'redo writes' then s1.stat_value end) redo_writes,
    sum(case when s1.stat_name = 'redo blocks written' then s1.stat_value end) redo_blocks_written,
    sum(case when s1.stat_name = 'redo write time' then s1.stat_value end) redo_write_time,
    sum(case when s1.stat_name ='redo log space requests' then s1.stat_value end) redo_log_space_req,
    sum(case when s1.stat_name ='redo buffer allocation retries'  then s1.stat_value end) redo_buffer_alloc_retries,
    sum(case when s1.stat_name ='redo entries' then s1.stat_value end) redo_entries,
    sum(case when s1.stat_name ='flashback log writes' then s1.stat_value end) flashback_log
from
(
select s1.snap_id, s1.stat_id, s1.stat_name,
      case when stat_name = lag(stat_name) over (order by s1.stat_name,s1.instance_number,s1.snap_id)  and
          s1.instance_number = lag(s1.instance_number) over (order by s1.stat_name,s1.instance_number,s1.snap_id) and
         value >= lag(value) over (order by s1.stat_name,s1.instance_number,s1.snap_id) then
         value - lag(value) over (order by s1.stat_name,s1.instance_number,s1.snap_id)
       end stat_value,
  s1.instance_number
from dba_hist_sysstat s1 where
   s1.stat_name
     in (
          'redo size',
          'redo writes',
          'redo blocks written',
          'redo write time',
          'redo log space requests',
          'redo buffer allocation retries',
          'redo entries',
          'flashback log writes'
         )
  and s1.snap_id between :bsnap and :esnap
) s1,
  dba_hist_snapshot s
  where
   s.snap_id between :bsnap + 1 and  :esnap
   and s1.snap_id = s.snap_id
   and s1.instance_number = s.instance_number
group by rpad(to_char(s1.instance_number),6), trunc(end_interval_time,'HH24')
order by rpad(to_char(s1.instance_number),6), trunc(end_interval_time,'HH24');


PROMPT
PROMPT "GLOBAL CACHE Efficiencies""
PROMPT "~~~~~~~~~~~~~~~~~~~~~~~~~"

col lc heading '.|Local|Cache(%)'  jus r null 'N/A' format 999.9
col rc heading '.|Remote|Cache(%)' jus r null 'N/A' format 999.9
col dc heading '.|Disk|Read(%)' jus r null 'N/A' format 999.9
col agccrbrt heading 'Ave.gc.cr|block.rcv|time(ms)' jus r null 'N/A' format 99,999.9
col agccrbst heading 'Ave.gc.cr|block.send|time(ms)' jus r null 'N/A' format 99,999.9
col agccrbft heading 'Ave.gc.cr|block.flush|time(ms)' jus r null 'N/A' format 99,999.9
col gcbc heading '.|gc.blocks|corrupt' jus r null 'N/A' format 99,999.9
col gcbl heading '.|gc.blocks|lost' jus r null 'N/A' format 99,999.9
col gccbl heading '.|gc.claim|blocks.lost' jus r null 'N/A' format 99,999.9
col pcrlf heading '%gc.cr|log.flushes|blocks.served' jus r null 'N/A' format 999.9
col agccubrt heading 'Ave.gc.cu|block.rcv|time(ms)' jus r null 'N/A' format 99,999.9
col agccubst heading 'Ave.gc.cu|block.send|time(ms)' jus r null 'N/A' format 99,999.9
col agccubpt heading 'Ave.gc.cu|block.pin|time(ms)' jus r null 'N/A' format 99,999.9
col agccubft heading 'Ave.gc.cu|block.flush|time(ms)' jus r null 'N/A' format 99,999.9
col pculf heading '%gc.cu|log.flushes|blocks.served' jus r null 'N/A' format 999.9
col msqt  heading  'Avg.msg|sent.queue|time.(ms)' jus r null 'N/A' format   99,999.9
col msqtok heading 'Avg.msg|sent.queue|time.on.ksxp.(ms)' jus r null 'N/A' format  99,999.9
col mrqt heading   'Avg.msg|rcvd.queue|time(ms)' jus r null 'N/A' format     99,999.9
col gcsmpt heading  'Avg.GCS|msg.process|time(ms)' jus r null 'N/A' format  99,999.9
col gesmpt heading  'Avg.GES|msg.process|time(ms)' jus r null 'N/A' format  99,999.9
col pmsd heading    '%.of|direct.sent|msg' jus r null 'N/A' format    999.99
col pmsi heading    '%.of|indirect.sent|msg' jus r null 'N/A' format    999.99
col pmfc heading    '%.of|flow.controlled|msg' jus r null 'N/A' format  999.99


select 
       rpad(to_char(instance_number),6) instance_number,
       trunc(end_interval_time,'HH24') ttime, 
       case when sum(dbgfc)+sum(cgfc) > 0 then (1-(sum(prc)+sum(gccrbr)+sum(gccubr))/(sum(dbgfc)+sum(cgfc)))*100 end lc,
       case when sum(dbgfc)+sum(cgfc) > 0 then (sum(gccrbr)+sum(gccubr))/(sum(dbgfc)+sum(cgfc))*100 end rc,
       case when sum(dbgfc)+sum(cgfc) > 0 then sum(prc)/(sum(dbgfc)+sum(cgfc))*100 end dc,
       sum(gcbc) gcbc,
       sum(gcbl) gcbl,
       sum(gccbl) gccbl,
       case when sum(gccrbr) > 0 then sum(gccrbrt)*10/sum(gccrbr) end agccrbrt,
       case when sum(gccrbs) > 0 then sum(gccrbst)*10/sum(gccrbs) end agccrbst,
       case when sum(cr_flushes) > 0 then sum(gccrbft)*10/sum(cr_flushes) end agccrbft,
       case when sum(gccrbs) > 0 then sum(cr_flushes)/sum(gccrbs)*100 end pcrlf,
       case when sum(gccubr) > 0 then sum(gccubrt)*10/sum(gccubr) end agccubrt,
       case when sum(gccubs) > 0 then sum(gccubst)*10/sum(gccubs) end agccubst,
       case when sum(gccubs) > 0 then sum(gccubpt)*10/sum(gccubs) end agccubpt,
       case when sum(cu_flushes) > 0 then sum(gccubft)*10/sum(cu_flushes) end agccubft,
       case when sum(gccubs) > 0 then sum(cu_flushes)/sum(gccubs)*100 end pculf,
       case when sum(msq) > 0 then sum(msqt)/sum(msq) end msqt,
       case when sum(msqtok) > 0 then sum(msqtok)/sum(msqok) end msqtok,
       case when sum(mrq) > 0 then sum(mrqt)/sum(mrq) end  mrqt,
       case when sum(gcmr) > 0 then sum(gcmpt)/sum(gcmr) end gcsmpt,
       case when sum(gemr) > 0 then sum(gempt)/sum(gemr) end gesmpt,
       case when sum(msd)+sum(msi)+sum(mfc) > 0 then sum(msd)/(sum(msd)+sum(msi)+sum(mfc))*100 end  pmsd,
       case when sum(msd)+sum(msi)+sum(mfc) > 0 then sum(msi)/(sum(msd)+sum(msi)+sum(mfc))*100 end pmsi,
       case when sum(msd)+sum(msi)+sum(mfc) > 0 then sum(mfc)/(sum(msd)+sum(msi)+sum(mfc))*100 end pmfc
from
(
select s.snap_id, s.end_interval_time, s.instance_number,
       case when
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          ss.value >= lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = 'gc blocks corrupt' then ss.value - lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) end gcbc,
       case when
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          ss.value >= lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = 'gc blocks lost' then ss.value - lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) end gcbl,
       case when
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          ss.value >= lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = 'gc claim blocks lost' then ss.value - lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) end gccbl,
       case when
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          ss.value >= lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = 'gc cr blocks received' then ss.value - lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) end gccrbr,
       case when
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          ss.value >= lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = 'gc cr block receive time' then ss.value - lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) end gccrbrt,
       case when
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          ss.value >= lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = 'gc cr blocks served' then ss.value - lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) end gccrbs,
       case when
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          ss.value >= lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = 'gc cr block build time' then ss.value - lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) end gccrbbt,
       case when
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          ss.value >= lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = 'gc cr block flush time' then ss.value - lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) end gccrbft,
       case when
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          ss.value >= lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = 'gc cr block send time' then ss.value - lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) end gccrbst,
       case when
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          ss.value >= lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = 'gc current blocks received' then ss.value - lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) end gccubr,
       case when
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          ss.value >= lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = 'gc current block receive time' then ss.value - lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) end gccubrt,
       case when
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          ss.value >= lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = 'gc current block pin time' then ss.value - lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) end gccubpt,
       case when
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          ss.value >= lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = 'gc current blocks served' then ss.value - lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) end gccubs,
       case when
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          ss.value >= lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = 'gc current block send time' then ss.value - lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) end gccubst,
       case when
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          ss.value >= lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = 'gc current block flush time' then ss.value - lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) end gccubft,
       case when
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          ss.value >= lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = 'global enqueue get time' then ss.value - lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) end gegt,
       case when
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          ss.value >= lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = 'global enqueue gets sync' then ss.value - lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) end gegs,
       case when
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          ss.value >= lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = 'global enqueue gets async' then ss.value - lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) end gega,
       case when
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          ss.value >= lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = 'physical reads cache' then ss.value - lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) end prc,
       case when
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          ss.value >= lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = 'consistent gets from cache' then  ss.value - lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) end cgfc,
       case when
          ss.instance_number = lag(ss.instance_number) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          ss.value >= lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = lag(stat_name) over (order by ss.stat_name,ss.instance_number,ss.snap_id) and
          stat_name = 'db block gets from cache' then ss.value - lag(ss.value) over (order by ss.stat_name,ss.instance_number,ss.snap_id) end dbgfc,
       case when
          dl.instance_number = lag(dl.instance_number) over (order by dl.instance_number,dl.snap_id) and
          dl.value >= lag(dl.value) over (order by dl.name,dl.instance_number,dl.snap_id) and
          name = lag(name) over (order by dl.name,dl.instance_number,dl.snap_id) and
          name = 'msgs sent queued' then dl.value - lag(dl.value) over (order by dl.name,dl.instance_number,dl.snap_id) end msq,
       case when
          dl.instance_number = lag(dl.instance_number) over (order by dl.instance_number,dl.snap_id) and
          dl.value >= lag(dl.value) over (order by dl.name,dl.instance_number,dl.snap_id) and
          name = lag(name) over (order by dl.name,dl.instance_number,dl.snap_id) and
          name = 'msgs sent queue time (ms)' then dl.value - lag(dl.value) over (order by dl.name,dl.instance_number,dl.snap_id) end msqt,
       case when
          dl.instance_number = lag(dl.instance_number) over (order by dl.instance_number,dl.snap_id) and
          dl.value >= lag(dl.value) over (order by dl.name,dl.instance_number,dl.snap_id) and
          name = lag(name) over (order by dl.name,dl.instance_number,dl.snap_id) and
          name = 'msgs sent queued on ksxp' then dl.value - lag(dl.value) over (order by dl.name,dl.instance_number,dl.snap_id) end msqok,
       case when
          dl.instance_number = lag(dl.instance_number) over (order by dl.instance_number,dl.snap_id) and
          dl.value >= lag(dl.value) over (order by dl.name,dl.instance_number,dl.snap_id) and
          name = lag(name) over (order by dl.name,dl.instance_number,dl.snap_id) and
          name = 'msgs sent queue time on ksxp (ms)' then dl.value - lag(dl.value) over (order by dl.name,dl.instance_number,dl.snap_id) end msqtok,
       case when
          dl.instance_number = lag(dl.instance_number) over (order by dl.instance_number,dl.snap_id) and
          dl.value >= lag(dl.value) over (order by dl.name,dl.instance_number,dl.snap_id) and
          name = lag(name) over (order by dl.name,dl.instance_number,dl.snap_id) and
          name = 'msgs received queued' then dl.value - lag(dl.value) over (order by dl.name,dl.instance_number,dl.snap_id) end mrq,
       case when
          dl.instance_number = lag(dl.instance_number) over (order by dl.instance_number,dl.snap_id) and
          dl.value >= lag(dl.value) over (order by dl.name,dl.instance_number,dl.snap_id) and
          name = lag(name) over (order by dl.name,dl.instance_number,dl.snap_id) and
          name = 'msgs received queue time (ms)' then dl.value - lag(dl.value) over (order by dl.name,dl.instance_number,dl.snap_id) end mrqt,
       case when
          dl.instance_number = lag(dl.instance_number) over (order by dl.instance_number,dl.snap_id) and
          dl.value >= lag(dl.value) over (order by dl.name,dl.instance_number,dl.snap_id) and
          name = lag(name) over (order by dl.name,dl.instance_number,dl.snap_id) and
          name = 'gcs msgs received' then dl.value - lag(dl.value) over (order by dl.name,dl.instance_number,dl.snap_id) end gcmr,
       case when
          dl.instance_number = lag(dl.instance_number) over (order by dl.instance_number,dl.snap_id) and
          dl.value >= lag(dl.value) over (order by dl.name,dl.instance_number,dl.snap_id) and
          name = lag(name) over (order by dl.name,dl.instance_number,dl.snap_id) and
          name = 'gcs msgs process time(ms)'  then  dl.value - lag(dl.value) over (order by dl.name,dl.instance_number,dl.snap_id) end gcmpt,
       case when
          dl.instance_number = lag(dl.instance_number) over (order by dl.instance_number,dl.snap_id) and
          dl.value >= lag(dl.value) over (order by dl.name,dl.instance_number,dl.snap_id) and
          name = lag(name) over (order by dl.name,dl.instance_number,dl.snap_id) and
          name = 'ges msgs received' then dl.value - lag(dl.value) over (order by dl.name,dl.instance_number,dl.snap_id) end gemr,
       case when
          dl.instance_number = lag(dl.instance_number) over (order by dl.instance_number,dl.snap_id) and
          dl.value >= lag(dl.value) over (order by dl.name,dl.instance_number,dl.snap_id) and
          name = lag(name) over (order by dl.name,dl.instance_number,dl.snap_id) and
          name = 'ges msgs process time(ms)' then dl.value - lag(dl.value) over (order by dl.name,dl.instance_number,dl.snap_id) end gempt,
       case when
          dl.instance_number = lag(dl.instance_number) over (order by dl.instance_number,dl.snap_id) and
          dl.value >= lag(dl.value) over (order by dl.name,dl.instance_number,dl.snap_id) and
          name = lag(name) over (order by dl.name,dl.instance_number,dl.snap_id) and
          name = 'messages sent directly' then dl.value - lag(dl.value) over (order by dl.name,dl.instance_number,dl.snap_id) end msd,
       case when
          dl.instance_number = lag(dl.instance_number) over (order by dl.instance_number,dl.snap_id) and
          dl.value >= lag(dl.value) over (order by dl.name,dl.instance_number,dl.snap_id) and
          name = lag(name) over (order by dl.name,dl.instance_number,dl.snap_id) and
          name = 'messages sent indirectly' then dl.value - lag(dl.value) over (order by dl.name,dl.instance_number,dl.snap_id) end msi,
       case when
          dl.instance_number = lag(dl.instance_number) over (order by dl.instance_number,dl.snap_id) and
          dl.value >= lag(dl.value) over (order by dl.name,dl.instance_number,dl.snap_id) and
          name = lag(name) over (order by dl.name,dl.instance_number,dl.snap_id) and
          name = 'messages flow controlled' then dl.value - lag(dl.value) over (order by dl.name,dl.instance_number,dl.snap_id) end mfc,
       case when
          cr.instance_number = lag(cr.instance_number) over (order by cr.instance_number,cr.snap_id) and
          flushes >= lag(flushes) over (order by cr.instance_number,cr.snap_id) then
          flushes - lag(flushes) over (order by cr.instance_number,cr.snap_id) end cr_flushes,
       case when
          cu.instance_number = lag(cu.instance_number) over (order by cu.instance_number,cu.snap_id) and
          (flush1+flush10+flush100+flush1000+flush10000) >= lag(flush1+flush10+flush100+flush1000+flush10000) 
                           over (order by cu.instance_number,cu.snap_id) then
          (flush1+flush10+flush100+flush1000+flush10000) - lag(flush1+flush10+flush100+flush1000+flush10000) 
                           over (order by cu.instance_number,cu.snap_id) end cu_flushes
from
   dba_hist_sysstat        ss,
   dba_hist_cr_block_server cr,
   dba_hist_current_block_server cu,
   dba_hist_dlm_misc dl,
   dba_hist_snapshot         s
where
     s.snap_id between :bsnap and  :esnap
     and s.snap_id = ss.snap_id
     and s.snap_id = cr.snap_id
     and s.snap_id = cu.snap_id
     and s.snap_id = dl.snap_id
     and ss.instance_number = s.instance_number
     and cr.instance_number = s.instance_number
     and cu.instance_number = s.instance_number
     and dl.instance_number = s.instance_number
     and ss.stat_name  in
           (
            'gc blocks corrupt',
            'gc blocks lost',
            'gc claim blocks lost',
            'gc cr blocks received', 
            'gc cr block receive time',
            'gc cr blocks served', 
            'gc cr block build time',
            'gc cr block flush time', 
            'gc cr block send time',
            'gc current blocks received',
            'gc current block receive time',
            'gc current block pin time', 
            'gc current blocks served',
            'gc current block send time', 
            'gc current block flush time',
            'db block gets from cache',
            'global enqueue get time',
            'global enqueue gets sync', 
            'global enqueue gets async',
            'physical reads cache',
            'consistent gets from cache'
          )
     and dl.name in
          (
            'msgs sent queued', 
            'msgs sent queue time (ms)',
            'msgs sent queue time on ksxp (ms)', 
            'msgs sent queued on ksxp',
            'msgs received queue time (ms)', 
            'msgs received queued',
            'gcs msgs received', 
            'gcs msgs process time(ms)',
            'ges msgs received', 
            'ges msgs process time(ms)',
            'messages sent directly', 
            'messages sent indirectly',
            'messages flow controlled'
                )
     and dl.value          >  0
) where snap_id > :bsnap
group by  rpad(to_char(instance_number),6), trunc(end_interval_time,'HH24')
order by instance_number, trunc(end_interval_time,'HH24');




PROMPT
PROMPT "Top 10 Timed Events"
PROMPT "~~~~~~~~~~~~~~~~~~~"

col  event_name heading "Event|-" jus r null 'N/A' format a55
col wait_class heading "Wait|Class" jus r null 'N/A' format a17
col db_time heading "DB|time" jus r null 'N/A' format 999,999.9
col perc_db_time heading "(%)Call|time" jus r null 'N/A' format 999,999.9
col avgw1 heading "Avg|Wait(ms)" jus r null 'N/A' format 9,999.9
col total_waited heading "Wait|Time(s)" jus r null 'N/A' format 999,999,999
col total_wait heading "Total|Waits" jus r null 'N/A' format 999,999,999
col Total_Timeouts heading "Total|Timeouts" jus r  null 'N/A' format 999,999,999
col Rank heading "-|Rank" jus r null 'N/A' format 999,999

-- break on instance_number on ttime skip 1

select 
       rpad(to_char(instance_number),6) instance_number, 
       ttime, 
       event_name, wait_class, perc_db_time,
       total_wait, total_timeouts, total_waited, avgw1, avgw1
from (
select  n1.instance_number,
        trunc(end_interval_time,'HH24') ttime,
        event_name, wait_class,
        round(sum(db_time/1000000),1) db_time,
        nvl(round(sum(wm1/db_time)*100,1),0) perc_db_time,
        sum(tw1) Total_Wait,
        sum(to1) Total_Timeouts,
        round(sum(wm1/1000000),1) Total_Waited,
--        round(sum((wm1/1000)/tw1),1) avgw1,
        round(sum(wm1/1000000)/sum(tw1)*1000,1) avgw1,
        row_number() over (partition by n1.instance_number, trunc(end_interval_time,'HH24')
            order by n1.instance_number, trunc(end_interval_time,'HH24'), nvl(round(sum(wm1/db_time)*100,1),0) desc) rn
from
(
select s.snap_id, s.instance_number, 
   '"' || event_name || '"' event_name, s.end_interval_time, '"' || ss.wait_class || '"' wait_class,
    case when event_name = lag(event_name) over (order by ss.event_name,ss.instance_number,s.snap_id) and
          ss.instance_number = lag(ss.instance_number) over (order by ss.event_name,ss.instance_number,s.snap_id) and
          total_waits > lag(total_waits) over (order by ss.event_name,ss.instance_number,s.snap_id) then
          total_waits - lag(total_waits) over (order by ss.event_name,ss.instance_number,s.snap_id)
       end tw1,
    case when event_name = lag(event_name) over (order by ss.event_name,ss.instance_number,s.snap_id) and
          ss.instance_number = lag(ss.instance_number) over (order by ss.event_name,ss.instance_number,s.snap_id) and
          time_waited_micro > lag(time_waited_micro ) over (order by ss.event_name,ss.instance_number,s.snap_id) then
          time_waited_micro - lag(time_waited_micro ) over (order by ss.event_name,ss.instance_number,s.snap_id)
       end wm1,
    case when event_name = lag(event_name) over (order by ss.event_name,ss.instance_number,s.snap_id) and
          ss.instance_number = lag(ss.instance_number) over (order by ss.event_name,ss.instance_number,s.snap_id) and
          total_timeouts > lag(total_timeouts ) over (order by ss.event_name,ss.instance_number,s.snap_id) then
          total_timeouts - lag(total_timeouts ) over (order by ss.event_name,ss.instance_number,s.snap_id)
       end to1
from
   dba_hist_system_event        ss,
   dba_hist_snapshot         s
where
   s.snap_id between :bsnap and  :esnap
   and s.snap_id = ss.snap_id
   and ss.instance_number = s.instance_number
   and wait_class != 'Idle'
) n1,
(
  select s.snap_id, s.instance_number,
    case when stat_name = lag(stat_name) over (order by st.stat_name,st.instance_number,s.snap_id) and stat_name = 'DB time' and
          st.instance_number = lag(st.instance_number) over (order by st.stat_name,st.instance_number,s.snap_id) and
          value > lag(value ) over (order by st.stat_name,st.instance_number,s.snap_id) then
          value - lag(value ) over (order by st.stat_name,st.instance_number,s.snap_id)
       end db_time,
    case when stat_name = lag(stat_name) over (order by st.stat_name,st.instance_number,s.snap_id) and stat_name = 'DB CPU' and
          st.instance_number = lag(st.instance_number) over (order by st.stat_name,st.instance_number,s.snap_id) and
          value > lag(value ) over (order by st.stat_name,st.instance_number,s.snap_id) then
          value - lag(value ) over (order by st.stat_name,st.instance_number,s.snap_id)
       end db_cpu
from
   dba_hist_sys_time_model        st,
   dba_hist_snapshot         s
where
   s.snap_id between :bsnap and  :esnap
   and s.snap_id = st.snap_id
   and st.instance_number = s.instance_number
   and st.stat_name = 'DB time'
) n2
 where n1.snap_id = n2.snap_id
       and n1.instance_number = n2.instance_number
       and n1.snap_id > :bsnap
group by n1.instance_number, trunc(end_interval_time,'HH24'), event_name, wait_class 
) where rn < 11
order by instance_number, ttime, perc_db_time desc;

PROMPT
PROMPT "Wait Class"
PROMPT "~~~~~~~~~~"

col wait_class heading "Wait|Class" jus r null 'N/A' format a17
col db_time heading "DB|time" jus r null 'N/A' format 999,999.9
col perc_db_time heading "(%)Call|time" jus r null 'N/A' format 999,999.9
col avgw1 heading "Avg|Wait(ms)" jus r null 'N/A' format 9,999.9
col total_waited heading "Wait|Time(s)" jus r null 'N/A' format 999,999,999
col total_wait heading "Total|Waits" jus r null 'N/A' format 999,999,999
col Total_Timeouts heading "Total|Timeouts" jus r null 'N/A' format 999,999,999

-- break on instance_number on ttime skip 1

select 
        rpad(to_char(n1.instance_number),6) instance_number,
        trunc(end_interval_time,'HH24') ttime,
        '"' || wait_class || '"' wait_class,
        round(db_time/1000000,1) db_time,
        round(nvl(sum(wm1/db_time)*100,0),1) perc_db_time,
        sum(tw1) Total_Wait,
        sum(to1) Total_Timeouts,
        round(sum(wm1/1000000),1) Total_Waited,
        round(sum(wm1/1000000)/sum(tw1)*1000,1) avgw1
from
(
select s.snap_id, s.instance_number, s.end_interval_time , '"' || ss.event_name || '"' event_name, wait_class,
    case when event_name = lag(event_name) over (order by ss.event_name,ss.instance_number,s.snap_id) and
          ss.instance_number = lag(ss.instance_number) over (order by ss.event_name,ss.instance_number,s.snap_id) and
          total_waits > lag(total_waits) over (order by ss.event_name,ss.instance_number,s.snap_id) then
          total_waits - lag(total_waits) over (order by ss.event_name,ss.instance_number,s.snap_id)
       end tw1,
    case when event_name = lag(event_name) over (order by ss.event_name,ss.instance_number,s.snap_id) and
          ss.instance_number = lag(ss.instance_number) over (order by ss.event_name,ss.instance_number,s.snap_id) and
          time_waited_micro > lag(time_waited_micro ) over (order by ss.event_name,ss.instance_number,s.snap_id) then
          time_waited_micro - lag(time_waited_micro ) over (order by ss.event_name,ss.instance_number,s.snap_id)
       end wm1,
    case when event_name = lag(event_name) over (order by ss.event_name,ss.instance_number,s.snap_id) and
          ss.instance_number = lag(ss.instance_number) over (order by ss.event_name,ss.instance_number,s.snap_id) and
          total_timeouts > lag(total_timeouts ) over (order by ss.event_name,ss.instance_number,s.snap_id) then
          total_timeouts - lag(total_timeouts ) over (order by ss.event_name,ss.instance_number,s.snap_id)
       end to1
from
   dba_hist_system_event        ss,
   dba_hist_snapshot         s
where
   s.snap_id between :bsnap and  :esnap
   and s.snap_id = ss.snap_id
   and ss.instance_number = s.instance_number
   and wait_class != 'Idle'
) n1,
(
  select s.snap_id, s.instance_number,
    case when stat_name = lag(stat_name) over (order by st.stat_name,st.instance_number,s.snap_id) and stat_name = 'DB time' and
          st.instance_number = lag(st.instance_number) over (order by st.stat_name,st.instance_number,s.snap_id) and
          value > lag(value ) over (order by st.stat_name,st.instance_number,s.snap_id) then
          value - lag(value ) over (order by st.stat_name,st.instance_number,s.snap_id)
       end db_time
from
   dba_hist_sys_time_model        st,
   dba_hist_snapshot         s
where
   s.snap_id between :bsnap and  :esnap
   and s.snap_id = st.snap_id
   and st.instance_number = s.instance_number
   and st.stat_name = 'DB time'
) n2
 where n1.snap_id = n2.snap_id
       and n1.instance_number = n2.instance_number
       and n1.snap_id > :bsnap
group by rpad(to_char(n1.instance_number),6), trunc(end_interval_time,'HH24'), wait_class,round(db_time/1000000,1)
order by rpad(to_char(n1.instance_number),6), trunc(end_interval_time,'HH24'), perc_db_time desc;

PROMPT
PROMPT "Top SQL"
PROMPT "~~~~~~~"


col db_time heading 'DB|Time' jus r null 'N/A' format 999,999.99
col perc_db_time heading '(%)Call|Time' jus r null 'N/A' format 999,999.99
col perc_cpu_time heading '.|(%)CPU' jus r null 'N/A' format 999,999.99
col c1 heading '.|SQL'                 jus r null 'N/A' format a13
col c2 heading '.|Exec'             jus r null 'N/A' format 9,999,999
col c3 heading '.|CPU(s)'             jus r null 'N/A' format 999,999.99
col c4 heading '.|Elapsed(s)'             jus r null 'N/A' format 999,999.99
col c5 heading 'Rows|Proc'      jus r null 'N/A' format 999,999,999
col c6 heading 'Buffer|Gets'      jus r null 'N/A' format 999,999,999
col c7 heading 'Disk|Reads'      jus r null 'N/A' format 999,999,999
col c8 heading 'IO|Wait'          jus r null 'N/A' format 99,999,999
col c9 heading 'Application|Wait' jus r null 'N/A' format 99,999,999
col c10 heading 'Concurrency|Wait' jus r null 'N/A' format 99,999,999
col c11 heading 'Gets|Per_Exec' jus r null 'N/A' format 99,999,999
col c12 heading 'Cluster|Wait' jus r null 'N/A' format 99,999,999


select 
       rpad(to_char(n1.instance_number),6) instance_number, 
       ttime,  
       c1,
       round(db_time/1000000,1) db_time,
       round((c4/(db_time/1000000))*100,1) perc_db_time,
       round((c3/(db_time/1000000))*100,1) perc_cpu_time,
       c2, case when c2 > 0 then round(c6/c2,1) else 0 end c11, c3, c4, c5, c6, c7, c8, c9, c10
from
(
select  s.instance_number, s.snap_id, trunc(s.end_interval_time, 'HH24') ttime,
  sql.sql_id               c1,
  sum(sql.executions_delta)     c2,
  sum(sql.cpu_time_delta)/1000000     c3,
  sum(sql.elapsed_time_delta)/1000000    c4,
  sum(sql.rows_processed_delta)  c5,
  sum(sql.buffer_gets_delta)    c6,
  sum(sql.disk_reads_delta)     c7,
  sum(sql.iowait_delta)/1000000         c8,
  sum(sql.apwait_delta)/1000000         c9,
  sum(sql.ccwait_delta)/1000000   c10,
  sum(sql.clwait_delta)/1000000   c12
from
   dba_hist_sqlstat        sql,
   dba_hist_snapshot s
where
   s.snap_id between :bsnap and  :esnap
   and s.snap_id = sql.snap_id
   and sql.instance_number = s.instance_number
group by s.instance_number,s.snap_id, trunc(s.end_interval_time, 'HH24'), sql.sql_id
) n1,
(
 select s.snap_id, s.instance_number,
    case when stat_name = lag(stat_name) over (order by st.stat_name,st.instance_number,s.snap_id) and stat_name = 'DB time' and
          st.instance_number = lag(st.instance_number) over (order by st.stat_name,st.instance_number,s.snap_id) and
          value > lag(value ) over (order by st.stat_name,st.instance_number,s.snap_id) then
          value - lag(value ) over (order by st.stat_name,st.instance_number,s.snap_id)
       end db_time
from
   dba_hist_sys_time_model        st,
   dba_hist_snapshot         s
where
   s.snap_id between :bsnap and  :esnap
   and s.snap_id = st.snap_id
   and st.instance_number = s.instance_number
   and st.stat_name = 'DB time'
) n2
 where n1.snap_id = n2.snap_id
   and n1.instance_number = n2.instance_number
   and c4 > 999  
   and n1.snap_id > :bsnap
order by  rpad(to_char(n1.instance_number),6), ttime, c4 desc,  perc_db_time;




-- break on instance_number skip 1


PROMPT
PROMPT "Single/Multi Block Reads/Writes"
PROMPT "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

col single_block_reads heading "Single|Block|Reads" jus r null 'N/A' format 999,999,999
col single_block_writes heading "Single|Block|Writes" jus r null 'N/A' format  999,999,999
col multi_block_reads heading "Multi|Block|Reads" jus r null 'N/A' format 999,999,999
col multi_block_writes heading "Multi|Block|Writes" jus r null 'N/A' format 999,999,999
col bytes_read heading "-| Bytes|Read" jus r null 'N/A' format 999,999,999,999
col bytes_written heading "-|Bytes|Written" jus r null 'N/A' format  999,999,999,999


select
     rpad(to_char(s.instance_number),6) instance_number, 
     trunc(end_interval_time,'HH24') ttime,
     sum(single_block_reads) single_block_reads,
     sum(single_block_writes) single_block_writes,
     sum(multi_block_reads) multi_block_reads,
     sum(multi_block_writes) multi_block_writes,
     sum(bytes_read) bytes_read,
     sum(bytes_written) bytes_written
from
(
select
    s1.snap_id, s1.instance_number,
    case when s1.stat_name = 'physical read total IO requests' and s2.stat_name = 'physical read total multi block requests'
then
      s1.stat_value - s2.stat_value
    end single_block_reads,
    case when s1.stat_name = 'physical write total IO requests' and s2.stat_name = 'physical write total multi block requests' then
      s1.stat_value - s2.stat_value
    end single_block_writes,
    case when s1.stat_name ='physical write total multi block requests'  and s2.stat_name = 'physical read total multi block requests'  then
      s1.stat_value
    end multi_block_writes,
    case when s1.stat_name ='physical read total multi block requests'  and s2.stat_name = 'physical write total multi block requests' then
      s1.stat_value
    end multi_block_reads,
    case when s1.stat_name = 'physical read total bytes' and s2.stat_name = 'physical read total multi block requests' then
      s1.stat_value
    end bytes_read,
    case when s1.stat_name = 'physical write total bytes' and s2.stat_name = 'physical read total multi block requests' then
      s1.stat_value
    end bytes_written
from
(
select s1.snap_id, s1.stat_id, s1.stat_name,
      case when stat_name = lag(stat_name) over (order by s1.stat_name,s1.instance_number,s1.snap_id)  and
          s1.instance_number = lag(s1.instance_number) over (order by s1.stat_name,s1.instance_number,s1.snap_id) and
         value >= lag(value) over (order by s1.stat_name,s1.instance_number,s1.snap_id) then
         value - lag(value) over (order by s1.stat_name,s1.instance_number,s1.snap_id)
       end stat_value,
  s1.instance_number
from dba_hist_sysstat s1 where
   s1.stat_name
     in (
          'physical read total bytes',
          'physical read total IO requests',
          'physical read total multi block requests',
          'physical write total bytes',
          'physical write total IO requests',
          'physical write total multi block requests'
         )
  and s1.snap_id between :bsnap and :esnap
) s1,
(
select s2.snap_id, s2.stat_id, s2.stat_name,
      case when stat_name = lag(stat_name) over (order by s2.stat_name,s2.instance_number,s2.snap_id)  and
          s2.instance_number = lag(s2.instance_number) over (order by s2.stat_name,s2.instance_number,s2.snap_id) and
         value >= lag(value) over (order by s2.stat_name,s2.instance_number,s2.snap_id) then
         value - lag(value) over (order by s2.stat_name,s2.instance_number,s2.snap_id)
       end stat_value,
  s2.instance_number
from  dba_hist_sysstat s2 where
   s2.stat_name
     in (
          'physical read total multi block requests',
          'physical write total multi block requests'
         )
  and s2.snap_id between :bsnap and :esnap
) s2
 where s1.snap_id = s2.snap_id
     and s1.instance_number = s2.instance_number
     and s1.stat_name <> s2.stat_name
) s3,
  dba_hist_snapshot s
  where
   s.snap_id between :bsnap + 1 and  :esnap
   and s3.snap_id = s.snap_id
   and s3.instance_number = s.instance_number
group by rpad(to_char(s.instance_number),6), trunc(end_interval_time,'HH24')
order by rpad(to_char(s.instance_number),6), trunc(end_interval_time,'HH24');


PROMPT
PROMPT "Backup/Application Block Reads/Writes"
PROMPT "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

col stat_name heading "IO" jus r null 'N/A' format a50
col backup_block_reads heading "Backup|Block|Reads" jus r null 'N/A' format 999,999,999
col backup_block_writes heading "Backup|Block|Written" jus r null 'N/A' format  999,999,999
col backup_gb_reads heading "Backup|GB|Reads" jus r null 'N/A' format 999,999,999
col backup_gb_writs heading "Backup|GB|Written" jus r null 'N/A' format  999,999,999
col app_block_reads heading "App|Block|Reads" jus r null 'N/A' format 999,999,999
col app_block_writes heading "App|Block|Written" jus r null 'N/A' format 999,999,999
col app_gb_reads heading "App|GB|Reads" jus r null 'N/A' format 999,999,999,999
col app_gb_writes heading "App|GB|Written" jus r null 'N/A' format  999,999,999,999


select 
     rpad(to_char(s.instance_number),6) instance_number, 
     trunc(end_interval_time,'HH24') ttime,
     sum(backup_block_reads) backup_block_reads,
     sum(backup_block_writes) backup_block_writes,
     sum(backup_gb_reads)/1024/1024 backup_gb_reads,
     sum(backup_gb_writs)/1024/1024 backup_gb_writs,
     sum(app_block_reads) app_block_reads,
     sum(app_block_writes) app_block_writes,
     sum(app_gb_reads)/1024/1024 app_gb_reads,
     sum(app_gb_writes)/1024/1024 app_gb_writes
from
(
select
    s1.snap_id, s1.instance_number,
    case when s1.stat_name = 'physical read total IO requests' and s2.stat_name = 'physical read IO requests' then
      s1.stat_value - s2.stat_value
    end backup_block_reads,
    case when s1.stat_name = 'physical write total IO requests' and s2.stat_name = 'physical write IO requests' then
      s1.stat_value - s2.stat_value
    end backup_block_writes,
    case when s1.stat_name = 'physical read total bytes' and s2.stat_name = 'physical read bytes' then
      s1.stat_value - s2.stat_value
    end backup_gb_reads,
    case when s1.stat_name = 'physical write total bytes' and s2.stat_name = 'physical write bytes' then
      s1.stat_value - s2.stat_value
    end backup_gb_writs,
    case when s1.stat_name ='physical read IO requests'  and s2.stat_name = 'physical write IO requests' then
      s1.stat_value
    end app_block_reads,
    case when s1.stat_name ='physical write IO requests'  and s2.stat_name = 'physical read IO requests'  then
      s1.stat_value
    end app_block_writes,
    case when s1.stat_name ='physical read bytes'  and s2.stat_name = 'physical write bytes' then
      s1.stat_value
    end app_gb_reads,
    case when s1.stat_name ='physical write bytes'  and s2.stat_name = 'physical read bytes'  then
      s1.stat_value
    end app_gb_writes
from
(
select s1.snap_id, s1.stat_id, s1.stat_name,
      case when stat_name = lag(stat_name) over (order by s1.stat_name,s1.instance_number,s1.snap_id)  and
          s1.instance_number = lag(s1.instance_number) over (order by s1.stat_name,s1.instance_number,s1.snap_id) and
         value >= lag(value) over (order by s1.stat_name,s1.instance_number,s1.snap_id) then
         value - lag(value) over (order by s1.stat_name,s1.instance_number,s1.snap_id)
       end stat_value,
  s1.instance_number
from dba_hist_sysstat s1 where
   s1.stat_name
     in (
          'physical read total bytes',
          'physical read bytes',
          'physical read total IO requests',
          'physical read IO requests',
          'physical write total bytes',
          'physical write bytes',
          'physical write total IO requests',
          'physical write IO requests'
         )
  and s1.snap_id between :bsnap and :esnap
) s1,
(
select s2.snap_id, s2.stat_id, s2.stat_name,
      case when stat_name = lag(stat_name) over (order by s2.stat_name,s2.instance_number,s2.snap_id)  and
          s2.instance_number = lag(s2.instance_number) over (order by s2.stat_name,s2.instance_number,s2.snap_id) and
         value >= lag(value) over (order by s2.stat_name,s2.instance_number,s2.snap_id) then
         value - lag(value) over (order by s2.stat_name,s2.instance_number,s2.snap_id)
       end stat_value,
  s2.instance_number
from  dba_hist_sysstat s2 where
   s2.stat_name
     in (
          'physical read IO requests',
          'physical write IO requests',
          'physical read bytes',
          'physical write bytes'
         )
  and s2.snap_id between :bsnap and :esnap
) s2
 where s1.snap_id = s2.snap_id
     and s1.instance_number = s2.instance_number
     and s1.stat_name <> s2.stat_name
) s3,
  dba_hist_snapshot s
  where
   s.snap_id between :bsnap + 1  and  :esnap
   and s3.snap_id = s.snap_id
   and s3.instance_number = s.instance_number
group by rpad(to_char(s.instance_number),6), trunc(end_interval_time,'HH24')
order by rpad(to_char(s.instance_number),6), trunc(end_interval_time,'HH24');


PROMPT
PROMPT "Segment Statistics"
PROMPT "~~~~~~~~~~~~~~~~~~"

col c1 heading '.|Logical|Reads'             jus r null 'N/A' format 999,999,999
col c2 heading 'Buffer|Busy|Waits'             jus r null 'N/A' format 999,999
col c3 heading 'DB|Block|Changes'      jus r null 'N/A' format 999,999
col c4 heading '.|Phy|Reads'      jus r null 'N/A' format 999,999
col c5 heading '.|Phy|Writes'          jus r null 'N/A' format 9,999,999
col c6 heading 'Phy|Reads|Direct' jus r null 'N/A' format 999,999
col c7 heading 'Phy|Writes|Direct' jus r null 'N/A' format 999,999
col c8 heading '.|ITL|Waits'             jus r null 'N/A' format 999,999
col c9 heading 'Row|Lock|Waits'             jus r null 'N/A' format 999,999
col c10 heading 'GC.CR|Blocks|Served'      jus r null 'N/A' format 999,999
col c11 heading 'GC.CU|Blocks|Served'      jus r null 'N/A' format 999,999
col c12 heading 'GC|Buffer|Busy'          jus r null 'N/A' format 9,999,999
col c13 heading 'GC.CR|Blocks|Received' jus r null 'N/A' format 999,999
col c14 heading 'GC.CU|Blocks|Received' jus r null 'N/A' format 999,999
col c15 heading '.|Table|Scan' jus r null 'N/A' format 999,999
col time jus r null 'N/A' format a35

col object_name heading '.|Object|Name' jus r null 'N/A' format a25
col object_type heading '.|Object|Type' jus r null 'N/A' format a25
col c1 heading '.|Logical|Reads(k)'             jus r null 'N/A' format 999,999
col c2 heading 'Buffer|Busy|Waits'             jus r null 'N/A' format 999,999,999
col c3 heading 'DB|Block|Changes'      jus r null 'N/A' format 99,999,999,999
col c4 heading '.|Phy|Reads'      jus r null 'N/A' format 999,999
col c5 heading '.|Phy|Writes'          jus r null 'N/A' format 9,999,999
col c6 heading 'Phy|Reads|Direct' jus r null 'N/A' format 999,999,999
col c7 heading 'Phy|Writes|Direct' jus r null 'N/A' format 999,999,999
col c8 heading '.|ITL|Waits'             jus r null 'N/A' format 9,999,999
col c9 heading 'Row|Lock|Waits'             jus r null 'N/A' format 99,999
col c10 heading 'GC_CR|Blocks|Served'      jus r null 'N/A' format 999,999,999
col c11 heading 'GC_CU|Blocks|Served'      jus r null 'N/A' format 999,999,999
col c12 heading 'GC|Buffer|Busy'          jus r null 'N/A' format 99,999,999,999
col c13 heading 'GC_CR|Blocks|Received' jus r null 'N/A' format 999,999,999
col c14 heading 'GC_CU|Blocks|Received' jus r null 'N/A' format 999,999,999
col c15 heading '.|Table|Scan' jus r null 'N/A' format 999,999
col inst_no heading '.|Inst|No' jus r null 'N/A' format a6

select  'Global' inst_no,
sego.object_name, '"' || sego.object_type || '"' object_type,
sum(BUFFER_BUSY_WAITS_DELTA) c2,
sum(DB_BLOCK_CHANGES_DELTA) c3,
sum(ITL_WAITS_DELTA) c8,
sum(ROW_LOCK_WAITS_DELTA) c9,
sum(GC_CR_BLOCKS_SERVED_DELTA) c10,
sum(GC_CU_BLOCKS_SERVED_DELTA) c11,
sum(GC_BUFFER_BUSY_DELTA) c12,
sum(GC_CR_BLOCKS_RECEIVED_DELTA) c13,
sum(GC_CU_BLOCKS_RECEIVED_DELTA) c14
from
   dba_hist_seg_stat        seg,
   dba_hist_seg_stat_obj    sego
where
    seg.snap_id between :bsnap + 1 and  :esnap
   and seg.obj# = sego.obj# and sego.owner = 'ES_MAIL'
group by sego.object_name , sego.object_type
order by c2;



PROMPT
PROMPT "GLOBAL CACHE INSTANCE TRANSFER"
PROMPT "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

col cr_data_block heading 'CR|Data|Blocks'           jus r null 'N/A' format 99,999,999
col cr_undo_block heading 'CR|Undo|Blocks'           jus r null 'N/A' format 9,999,999
col cr_undo_header heading 'CR|Undo|Header'          jus r null 'N/A' format 9,999,999
col cr_others heading 'CR|-|Others'                  jus r null 'N/A' format 9,999,999
col cr_busy_data_block heading 'CR_Busy|Data|Blocks'           jus r null 'N/A' format 9,999,999
col cr_busy_undo_block heading 'CR_Busy|Undo|Blocks'           jus r null 'N/A' format 9,999,999
col cr_busy_undo_header heading 'CR_Busy|Undo|Header'          jus r null 'N/A' format 9,999,999
col cr_busy_others heading 'CR_Busy|-|Others'                  jus r null 'N/A' format 9,999,999
col cr_con_data_block heading 'CR_Con|Data|Blocks'           jus r null 'N/A' format 9,999,999
col cr_con_undo_block heading 'CR_Con|Undo|Blocks'           jus r null 'N/A' format 9,999,999
col cr_con_undo_header heading 'CR_Con|Undo|Header'          jus r null 'N/A' format 9,999,999
col cr_con_others heading 'CR_Con|-|Others'                  jus r null 'N/A' format 9,999,999

col cu_data_block heading 'CU|Data|Blocks'           jus r null 'N/A' format 99,999,999
col cu_undo_block heading 'CU|Undo|Blocks'           jus r null 'N/A' format 9,999,999
col cu_undo_header heading 'CU|Undo|Header'          jus r null 'N/A' format 9,999,999
col cu_others heading 'CU|-|Others'                  jus r null 'N/A' format 9,999,999
col cu_busy_data_block heading 'CU_Busy|Data|Blocks'           jus r null 'N/A' format 9,999,999
col cu_busy_undo_block heading 'CU_Busy|Undo|Blocks'           jus r null 'N/A' format 9,999,999
col cu_busy_undo_header heading 'CU_Busy|Undo|Header'          jus r null 'N/A' format 9,999,999
col cu_busy_others heading 'CU_Busy|-|Others'                  jus r null 'N/A' format 9,999,999
col cu_con_data_block heading 'CU_Con|Data|Blocks'           jus r null 'N/A' format 9,999,999
col cu_con_undo_block heading 'CU_Con|Undo|Blocks'           jus r null 'N/A' format 9,999,999
col cu_con_undo_header heading 'CU_Con|Undo|Header'          jus r null 'N/A' format 9,999,999
col cu_con_others heading 'CU_Con|-|Others'                  jus r null 'N/A' format 9,999,999


col class jus r null 'N/A' format a11


select 
        rpad(to_char(instance_number),6) instance_number, 
        ttime,
	sum(cr_data_block)  cr_data_block, 
	sum(cr_undo_block) cr_undo_block, 
	sum(cr_undo_header) cr_undo_header, 
	nvl(sum(cr_others),0) cr_others,
	nvl(sum(cr_busy_data_block),0)  cr_busy_data_block, 
	nvl(sum(cr_busy_undo_block),0) cr_busy_undo_block, 
	nvl(sum(cr_busy_undo_header),0) cr_busy_undo_header, 
	nvl(sum(cr_busy_others),0) cr_busy_others,
	nvl(sum(cr_con_data_block),0)  cr_con_data_block, 
	nvl(sum(cr_con_undo_block),0) cr_con_undo_block, 
	nvl(sum(cr_con_undo_header),0) cr_con_undo_header, 
	nvl(sum(cr_con_others),0) cr_con_others,
	nvl(sum(cu_data_block),0)  cu_data_block, 
	nvl(sum(cu_undo_block),0) cu_undo_block, 
	nvl(sum(cu_undo_header),0) cu_undo_header, 
	nvl(sum(cu_others),0) cu_others,
	nvl(sum(cu_busy_data_block),0)  cu_busy_data_block, 
	nvl(sum(cu_busy_undo_block),0) cu_busy_undo_block, 
	nvl(sum(cu_busy_undo_header),0) cu_busy_undo_header, 
	nvl(sum(cu_busy_others),0) cu_busy_others,
	nvl(sum(cu_con_data_block),0)  cu_con_data_block, 
	nvl(sum(cu_con_undo_block),0) cu_con_undo_block, 
	nvl(sum(cu_con_undo_header),0) cu_con_undo_header, 
	nvl(sum(cu_con_others),0) cu_con_others
from
(
select snap_id, trunc(ttime,'HH24') ttime, instance_number,
   case when  class = 'data block' then sum(cr_blocks) end cr_data_block,
   case when  class = 'undo block' then sum(cr_blocks) end cr_undo_block,
   case when  class = 'undo header' then sum(cr_blocks) end cr_undo_header,
   case when  class = 'Others' then sum(cr_blocks) end cr_others,
   case when  class = 'data block' then sum(cr_busy) end cr_busy_data_block,
   case when  class = 'undo block' then sum(cr_busy) end cr_busy_undo_block,
   case when  class = 'undo header' then sum(cr_busy) end cr_busy_undo_header,
   case when  class = 'Others' then sum(cr_busy) end cr_busy_others,
   case when  class = 'data block' then sum(cr_congested) end cr_con_data_block,
   case when  class = 'undo block' then sum(cr_congested) end cr_con_undo_block,
   case when  class = 'undo header' then sum(cr_congested) end cr_con_undo_header,
   case when  class = 'Others' then sum(cr_congested) end cr_con_others,
   case when  class = 'data block' then sum(current_block) end cu_data_block,
   case when  class = 'undo block' then sum(current_block) end cu_undo_block,
   case when  class = 'undo header' then sum(current_block) end cu_undo_header,
   case when  class = 'Others' then sum(current_block) end cu_others,
   case when  class = 'data block' then sum(current_busy) end cu_busy_data_block,
   case when  class = 'undo block' then sum(current_busy) end cu_busy_undo_block,
   case when  class = 'undo header' then sum(current_busy) end cu_busy_undo_header,
   case when  class = 'Others' then sum(current_Busy) end cu_busy_others,
   case when  class = 'data block' then sum(current_congested) end cu_con_data_block,
   case when  class = 'undo block' then sum(current_congested) end cu_con_undo_block,
   case when  class = 'undo header' then sum(current_congested) end cu_con_undo_header,
   case when  class = 'Others' then sum(current_congested) end cu_con_others
from
(
select  ct.snap_id, s.end_interval_time ttime,  ct.instance_number, instance,class,
  cr_block,
  case when
       class = lag(class) over (order by class, ct.instance_number, instance, ct.snap_id) and
       instance = lag(instance) over (order by class, ct.instance_number, instance, ct.snap_id) and
       ct.instance_number = lag(ct.instance_number) over (order by class, ct.instance_number, instance, ct.snap_id) and
       cr_block > lag (cr_block) over (order by class, ct.instance_number, instance, ct.snap_id) then
     cr_block - lag (cr_block) over (order by class, ct.instance_number, instance, ct.snap_id)
  end  cr_blocks,
  case when
       class = lag(class) over (order by class, ct.instance_number, instance, ct.snap_id) and
       instance = lag(instance) over (order by class, ct.instance_number, instance, ct.snap_id) and
       ct.instance_number = lag(ct.instance_number) over (order by class, ct.instance_number, instance, ct.snap_id) and
       cr_busy > lag (cr_busy) over (order by class, ct.instance_number, instance, ct.snap_id) then
     cr_busy - lag (cr_busy) over (order by class, ct.instance_number, instance, ct.snap_id)
  end  cr_busy,
  case when
       class = lag(class) over (order by class, ct.instance_number, instance, ct.snap_id) and
       instance = lag(instance) over (order by class, ct.instance_number, instance, ct.snap_id) and
       ct.instance_number = lag(ct.instance_number) over (order by class, ct.instance_number, instance, ct.snap_id) and
       cr_congested > lag (cr_congested) over (order by class, ct.instance_number, instance, ct.snap_id) then
     cr_congested - lag (cr_congested) over (order by class, ct.instance_number, instance, ct.snap_id)
  end  cr_congested,
  case when
       class = lag(class) over (order by class, ct.instance_number, instance, ct.snap_id) and
       instance = lag(instance) over (order by class, ct.instance_number, instance, ct.snap_id) and
       ct.instance_number = lag(ct.instance_number) over (order by class, ct.instance_number, instance, ct.snap_id) and
       current_block > lag (current_block) over (order by class, ct.instance_number, instance, ct.snap_id) then
     current_block - lag (current_block) over (order by class, ct.instance_number, instance, ct.snap_id)
  end  current_block,
  case when
       class = lag(class) over (order by class, ct.instance_number, instance, ct.snap_id) and
       instance = lag(instance) over (order by class, ct.instance_number, instance, ct.snap_id) and
       ct.instance_number = lag(ct.instance_number) over (order by class, ct.instance_number, instance, ct.snap_id) and
       current_busy > lag (current_busy) over (order by class, ct.instance_number, instance, ct.snap_id) then
     current_busy - lag (current_busy) over (order by class, ct.instance_number, instance, ct.snap_id)
  end  current_busy,
  case when
       class = lag(class) over (order by class, ct.instance_number, instance, ct.snap_id) and
       instance = lag(instance) over (order by class, ct.instance_number, instance, ct.snap_id) and
       ct.instance_number = lag(ct.instance_number) over (order by class, ct.instance_number, instance, ct.snap_id) and
       current_congested > lag (current_congested) over (order by class, ct.instance_number, instance, ct.snap_id) then
     current_congested - lag (current_congested) over (order by class, ct.instance_number, instance, ct.snap_id)
  end  current_congested
from dba_hist_inst_cache_transfer ct,
      dba_hist_snapshot s
 where ct.snap_id between :bsnap and  :esnap
     and ct.snap_id = s.snap_id
     and ct.instance_number = s.instance_number
order by class, ct.instance_number, instance, ct.snap_id
)
group by  instance_number, snap_id, trunc(ttime,'HH24'),  class
)
 where  snap_id > :bsnap
group by rpad(to_char(instance_number),6), ttime
order by instance_number, ttime;




PROMPT
PROMPT "GLOBAL CACHE - CU SERVED STATS"
PROMPT "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

col Pin jus r null 'N/A' format 99,999,999
col Flush jus r null 'N/A' format 999,999
col Write jus r null 'N/A' format 999,999
col c1 heading '%<1ms'  jus r null 'N/A' format 999.99
col c2 heading '%<10ms'  jus r null 'N/A' format 99.99
col c3 heading '%<100ms'  jus r null 'N/A' format 99.99
col c4 heading '%<1s'  jus r null 'N/A' format 99.99
col c5 heading '%<10s'  jus r null 'N/A' format 99.99

col c6 heading '%<1ms'  jus r null 'N/A' format 99.99
col c7 heading '%<10ms'  jus r null 'N/A' format 99.99
col c8 heading '%<100ms'  jus r null 'N/A' format 99.99
col c9 heading '%<1s'  jus r null 'N/A' format 99.99
col c10 heading '%<10s'  jus r null 'N/A' format 99.99

col c11 heading '%<1ms'  jus r null 'N/A' format 99.99
col c12 heading '%<10ms'  jus r null 'N/A' format 99.99
col c13 heading '%<100ms'  jus r null 'N/A' format 99.99
col c14 heading '%<1s'  jus r null 'N/A' format 99.99
col c15 heading '%<10s'  jus r null 'N/A' format 99.99


var tp number;
var tf number;
var tw number;
var c1 number;
var c2 number;
var c3 number;
var c4 number;
var c5 number;
var c6 number;
var c7 number;
var c8 number;
var c9 number;
var c10 number;
var c11 number;
var c12 number;
var c13 number;
var c14 number;
var c15 number;


col class jus r null 'N/A' format a11


select 
       rpad(to_char(s.instance_number),6) instance_number,
       trunc(end_interval_time,'HH24') ttime,
              sum(Pin) Pin, 
              sum(c1) c1,
              sum(c2) c2,
              sum(c3) c3,
              sum(c4) c4,
              sum(c5) c5,
              sum(Flush) Flush, 
              sum(c6) c6,
              sum(c7) c7,
              sum(c8) c8,
              sum(c9) c9,
              sum(c10) c10,
              Sum(Write) Write, 
              sum(c11) c11,
              sum(c12) c12,
              sum(c13) c13,
              sum(c14) c14,
              sum(c15) c15
from
(
select snap_id, instance_number, 
  case when grouping_id(tp) || grouping_id(tf) || grouping_id(tw) = '011' then tp end Pin,
  case when grouping_id(tp) || grouping_id(tf) || grouping_id(tw) = '011' then c1 end c1,
  case when grouping_id(tp) || grouping_id(tf) || grouping_id(tw) = '011' then c2 end c2,
  case when grouping_id(tp) || grouping_id(tf) || grouping_id(tw) = '011' then c3 end c3,
  case when grouping_id(tp) || grouping_id(tf) || grouping_id(tw) = '011' then c4 end c4,
  case when grouping_id(tp) || grouping_id(tf) || grouping_id(tw) = '011' then c5 end c5,
  case when grouping_id(tp) || grouping_id(tf) || grouping_id(tw) = '101' then tf end Flush,
  case when grouping_id(tp) || grouping_id(tf) || grouping_id(tw) = '101' then c6 end c6,
  case when grouping_id(tp) || grouping_id(tf) || grouping_id(tw) = '101' then c7 end c7,
  case when grouping_id(tp) || grouping_id(tf) || grouping_id(tw) = '101' then c8 end c8,
  case when grouping_id(tp) || grouping_id(tf) || grouping_id(tw) = '101' then c9 end c9,
  case when grouping_id(tp) || grouping_id(tf) || grouping_id(tw) = '101' then c10 end c10,
  case when grouping_id(tp) || grouping_id(tf) || grouping_id(tw) = '110' then tw end Write,
  case when grouping_id(tp) || grouping_id(tf) || grouping_id(tw) = '110' then c11 end c11,
  case when grouping_id(tp) || grouping_id(tf) || grouping_id(tw) = '110' then c12 end c12,
  case when grouping_id(tp) || grouping_id(tf) || grouping_id(tw) = '110' then c13 end c13,
  case when grouping_id(tp) || grouping_id(tf) || grouping_id(tw) = '110' then c14 end c14,
  case when grouping_id(tp) || grouping_id(tf) || grouping_id(tw) = '110' then c15 end c15
from
(
 select  snap_id, instance_number,
   sum(tp) tp, sum(tf) tf, sum(tw) tw,
  round( sum(p1)/sum(tp)*100,2) c1,
  round( sum(p10)/sum(tp)*100,2) c2,
  round( sum(p100)/sum(tp)*100,2) c3,
  round( sum(p1000)/sum(tp)*100,2) c4,
  round( sum(p10000)/sum(tp)*100,2) c5,
  round( sum(f1)/sum(tf)*100,2) c6,
  round( sum(f10)/sum(tf)*100,2) c7,
  round( sum(f100)/sum(tf)*100,2) c8,
  round( sum(f1000)/sum(tf)*100,2) c9,
  round( sum(f10000)/sum(tf)*100,2) c10,
  round( sum(w1)/sum(tw)*100,2) c11,
  round( sum(w10)/sum(tw)*100,2) c12,
  round( sum(w100)/sum(tw)*100,2) c13,
  round( sum(w1000)/sum(tw)*100,2) c14,
  round( sum(w10000)/sum(tw)*100,2) c15
from
(select ct.snap_id, ct.instance_number,
	case when  ct.instance_number = lag(ct.instance_number) over (order by ct.instance_number,ct.snap_id) and
              pin1 > lag(pin1) over(order by ct.instance_number, ct.snap_id) then
              pin1 - lag(pin1) over(order by ct.instance_number, ct.snap_id) 
        end p1,
	case when  ct.instance_number = lag(ct.instance_number) over (order by ct.instance_number,ct.snap_id) and
              pin10 > lag(pin10) over(order by ct.instance_number, ct.snap_id) then
              pin10 - lag(pin10) over(order by ct.instance_number, ct.snap_id) 
        end p10,
	case when  ct.instance_number = lag(ct.instance_number) over (order by ct.instance_number,ct.snap_id) and
              pin100 > lag(pin100) over(order by ct.instance_number, ct.snap_id) then
              pin100 - lag(pin100) over(order by ct.instance_number, ct.snap_id) 
        end p100,
	case when  ct.instance_number = lag(ct.instance_number) over (order by ct.instance_number,ct.snap_id) and
              pin1000 > lag(pin1000) over(order by ct.instance_number, ct.snap_id) then
              pin1000 - lag(pin1000) over(order by ct.instance_number, ct.snap_id) 
        end p1000,
	case when  ct.instance_number = lag(ct.instance_number) over (order by ct.instance_number,ct.snap_id) and
              pin10000 > lag(pin10000) over(order by ct.instance_number, ct.snap_id) then
              pin10000 - lag(pin10000) over(order by ct.instance_number, ct.snap_id) 
        end p10000,
	case when  ct.instance_number = lag(ct.instance_number) over (order by ct.instance_number,ct.snap_id) and
              flush1 > lag(flush1) over(order by ct.instance_number, ct.snap_id) then
              flush1 - lag(flush1) over(order by ct.instance_number, ct.snap_id) 
        end f1,
	case when  ct.instance_number = lag(ct.instance_number) over (order by ct.instance_number,ct.snap_id) and
              flush10 > lag(flush10) over(order by ct.instance_number, ct.snap_id) then
              flush10 - lag(flush10) over(order by ct.instance_number, ct.snap_id) 
        end f10,
	case when  ct.instance_number = lag(ct.instance_number) over (order by ct.instance_number,ct.snap_id) and
              flush100 > lag(flush100) over(order by ct.instance_number, ct.snap_id) then
              flush100 - lag(flush100) over(order by ct.instance_number, ct.snap_id) 
        end f100,
	case when  ct.instance_number = lag(ct.instance_number) over (order by ct.instance_number,ct.snap_id) and
              flush1000 > lag(flush1000) over(order by ct.instance_number, ct.snap_id) then
              flush1000 - lag(flush1000) over(order by ct.instance_number, ct.snap_id) 
        end f1000,
	case when  ct.instance_number = lag(ct.instance_number) over (order by ct.instance_number,ct.snap_id) and
              flush10000 > lag(flush10000) over(order by ct.instance_number, ct.snap_id) then
              flush10000 - lag(flush10000) over(order by ct.instance_number, ct.snap_id) 
        end f10000,
	case when  ct.instance_number = lag(ct.instance_number) over (order by ct.instance_number,ct.snap_id) and
              write1 > lag(write1) over(order by ct.instance_number, ct.snap_id) then
              write1 - lag(write1) over(order by ct.instance_number, ct.snap_id) 
        end w1,
	case when  ct.instance_number = lag(ct.instance_number) over (order by ct.instance_number,ct.snap_id) and
              write10 > lag(write10) over(order by ct.instance_number, ct.snap_id) then
              write10 - lag(write10) over(order by ct.instance_number, ct.snap_id) 
        end w10,
	case when  ct.instance_number = lag(ct.instance_number) over (order by ct.instance_number,ct.snap_id) and
              write100 > lag(write100) over(order by ct.instance_number, ct.snap_id) then
              write100 - lag(write100) over(order by ct.instance_number, ct.snap_id) 
        end w100,
	case when  ct.instance_number = lag(ct.instance_number) over (order by ct.instance_number,ct.snap_id) and
              write1000 > lag(write1000) over(order by ct.instance_number, ct.snap_id) then
              write1000 - lag(write1000) over(order by ct.instance_number, ct.snap_id) 
        end w1000,
	case when  ct.instance_number = lag(ct.instance_number) over (order by ct.instance_number,ct.snap_id) and
              write10000 > lag(write10000) over(order by ct.instance_number, ct.snap_id) then
              write10000 - lag(write10000) over(order by ct.instance_number, ct.snap_id) 
        end w10000,
	case when  ct.instance_number = lag(ct.instance_number) over (order by ct.instance_number,ct.snap_id) and
              pin1 > lag(pin1) over(order by ct.instance_number, ct.snap_id) then
        ( pin1 + pin10 + pin100 + pin1000 + pin10000 ) -
              lag (pin1 + pin10 + pin100 + pin1000 + pin10000) over (order by ct.instance_number,ct.snap_id) 
        end tp,
	case when  ct.instance_number = lag(ct.instance_number) over (order by ct.instance_number,ct.snap_id) and
              flush1 > lag(flush1) over(order by ct.instance_number, ct.snap_id) then
        ( flush1 + flush10 + flush100 + flush1000 + flush10000) -
              lag (flush1 + flush10 + flush100 + flush1000 + flush10000) over (order by ct.instance_number,ct.snap_id) 
         end tf,
	case when  ct.instance_number = lag(ct.instance_number) over (order by ct.instance_number,ct.snap_id) and
              write1 > lag(write1) over(order by ct.instance_number, ct.snap_id) then
        ( write1 + write10 + write100 + write1000 + write10000) -
              lag (write1 + write10 + write100 + write1000 + write10000) over (order by ct.instance_number,ct.snap_id) 
         end tw
  from dba_hist_current_block_server ct
where
   ct.snap_id between :bsnap and   :esnap
) group by instance_number, snap_id )
 group by instance_number, snap_id, grouping sets ((tp,c1,c2,c3,c4,c5),(tf,c6,c7,c8,c9,c10),(tw,c11,c12,c13,c14,c15)) 
) s3,
  dba_hist_snapshot s
  where
   s.snap_id between :bsnap + 1 and  :esnap
   and s3.snap_id = s.snap_id
   and s3.instance_number = s.instance_number
group by rpad(to_char(s.instance_number),6), trunc(end_interval_time,'HH24')
order by rpad(to_char(s.instance_number),6), trunc(end_interval_time,'HH24');

-- break on instance_number on ttime skip 1

PROMPT
PROMPT "GLOBAL CACHE - Busy/Congestion"
PROMPT "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

col INSTANCE_NUMBER heading 'In|No' jus r null 'N/A' format 99
col c1 heading 'CR.Blocks|Received'           jus r null 'N/A' format 99,999,999
col c2 heading 'CR.%|Immed'                 jus r null 'N/A' format 999.99
col c3 heading 'CR.%|Busy'             jus r null 'N/A' format 999.99
col c4 heading 'CR.%|Congst'             jus r null 'N/A' format 999.99
col c5 heading 'CU.Blocks|Received'           jus r null 'N/A' format 99,999,999
col c6 heading 'CU.%|Immed'                 jus r null 'N/A' format 999.99
col c7 heading 'CU.%|Busy'             jus r null 'N/A' format 999.99
col c8 heading 'CU.%|Congst'             jus r null 'N/A' format 999.99
col instance heading '.|Inst' jus r null 'N/A' format 99


select 
         rpad(to_char(s.instance_number),6) instance_number, 
         trunc(end_interval_time,'HH24')  ttime, 
         instance,
              sum(cr_delta) c1,
              case when sum(cr_delta) =  0 then 0 else
              round(sum(cr_block)/sum(cr_delta)*100,1)   end c2,
              case when sum(cr_delta) =  0 then 0 else
              round(sum(cr_busy)/sum(cr_delta)*100,1) end c3,
              case when sum(cr_delta) =  0 then 0 else
              round(sum(cr_congested)/sum(cr_delta)*100,1)  end c4,
              sum(cu_delta) c5,
              case when sum(cu_delta) =  0 then 0 else
              round(sum(current_block)/sum(cu_delta)*100,1)  end c6,
              case when sum(cu_delta) =  0 then 0 else
              round(sum(current_busy)/sum(cu_delta)*100,1) end c7,
              case when sum(cu_delta) =  0 then 0 else
              round(sum(current_congested)/sum(cu_delta)*100,1)  end c8
from
(
select  snap_id, instance_number, instance , class,
       case when lag(class) over (order by instance, class, instance_number, snap_id)  = class and
              (cr_block) >= lag(cr_block ) over (order by instance, class, instance_number, ct.snap_id) then
              (cr_block) - lag(cr_block ) over (order by instance, class, instance_number, ct.snap_id)
       end cr_block,
       case when lag(class) over (order by instance, class, instance_number, snap_id)  = class and
              (cr_busy) >= lag(cr_busy ) over (order by instance, class, instance_number,  ct.snap_id) then
              (cr_busy) - lag(cr_busy ) over (order by instance, class, instance_number,  ct.snap_id)
       end cr_busy,
       case when lag(class) over (order by instance, class, instance_number, snap_id)  = class and
               (cr_congested) >= lag(cr_congested ) over (order by instance, class, instance_number,  ct.snap_id) then
               (cr_congested) - lag(cr_congested ) over (order by instance, class, instance_number,  ct.snap_id)
       end cr_congested,
       case when lag(class) over (order by instance, class, instance_number, snap_id)  = class and
               (current_block) >= lag(current_block ) over (order by instance, class, instance_number,  ct.snap_id) then
               (current_block) - lag(current_block ) over (order by instance, class, instance_number,  ct.snap_id)
       end current_block,
       case when lag(class) over (order by instance, class, instance_number, snap_id)  = class and
                (current_busy) >= lag(current_busy ) over (order by instance, class, instance_number,  ct.snap_id) then
                (current_busy) - lag(current_busy ) over (order by instance, class, instance_number,  ct.snap_id)
       end current_busy,
       case when lag(class) over (order by instance, class, instance_number, snap_id)  = class and
                 (current_congested) >= lag(current_congested ) over (order by instance, class, instance_number, ct.snap_id) then
                 (current_congested) - lag(current_congested ) over (order by instance, class, instance_number, ct.snap_id)
       end current_congested,
       case when lag(class) over (order by instance, class, instance_number, snap_id)  = class and
       (cr_block + cr_busy + cr_congested) >= lag(cr_block + cr_busy + cr_congested) over (order by instance, class, instance_number, ct.snap_id) then
       (cr_block + cr_busy + cr_congested) - lag(cr_block + cr_busy + cr_congested) over (order by instance, class, instance_number, ct.snap_id)
       end cr_delta,
       case when lag(class) over (order by instance, class, instance_number, snap_id)  = class and
       (current_block + current_busy + current_congested) >=
       lag(current_block + current_busy + current_congested) over (order by instance, class,instance_number, ct.snap_id) then
       (current_block + current_busy + current_congested) -
       lag(current_block + current_busy + current_congested) over (order by instance, class,instance_number, ct.snap_id)
       end cu_delta
  from dba_hist_inst_cache_transfer ct
where
     ct.snap_id between :bsnap - 1 and :esnap
) ct,
       dba_hist_snapshot s
where
    s.snap_id = ct.snap_id and
    s.instance_number = ct.instance_number and
    s.snap_id > :bsnap
 group by rpad(to_char(s.instance_number),6), trunc(end_interval_time,'HH24'), instance
 order by rpad(to_char(s.instance_number),6), ttime, instance;

-- break on instance_number skip 1

PROMPT
PROMPT "PGA TARGET"
PROMPT "~~~~~~~~~~"


col aggr_target heading 'PGA|Aggr|Target(M)' jus r null 'N/A' format 999,999,999
col auto_target heading 'Auto|PGA|Target(M)' jus r null 'N/A' format 999,999,999
col total_alloc heading 'PGA|Mem|Alloc(M)' jus r null 'N/A' format 999,999,999
col tot_tun_used heading 'W/A|PGA|Used(M)' jus r null 'N/A' format 999,999,999
col pct_tun heading '%PGA|W/A|Mem' jus r null 'N/A' format 999.9
col pct_auto_tun heading '%Auto|W/A|Mem' jus r null 'N/A' format 999.9
col pct_man_tun heading '%Man|W/A|Mem' jus r null 'N/A' format 999.9
col glo_mem_bnd heading 'Global|Mem|Bound(K)' jus r null 'N/A' format 999,999,999

select 
       rpad(to_char(mu.instance_number),6) instance_number,
       ttime,
       to_number(p.value)/1024/1024 aggr_target,
       mu.pat/1024/1024    auto_target,
       mu.PGA_alloc/1024/1024    total_alloc,
       (mu.PGA_used_auto + mu.PGA_used_man)/1024/1024  tot_tun_used,
       100*(mu.PGA_used_auto + mu.PGA_used_man) / PGA_alloc  pct_tun,
       decode(mu.PGA_used_auto + mu.PGA_used_man, 0, 0, 100* mu.PGA_used_auto/(mu.PGA_used_auto + mu.PGA_used_man)) pct_auto_tun,
       decode(mu.PGA_used_auto + mu.PGA_used_man, 0, 0, 100* mu.PGA_used_man  / (mu.PGA_used_auto + mu.PGA_used_man))  pct_man_tun,
       mu.glob_mem_bnd/1024 glo_mem_bnd
from (
    select s.snap_id, s.instance_number,  trunc(end_interval_time,'HH24') ttime,
           sum(case when name = 'total PGA allocated'then value else 0 end)  PGA_alloc,
           sum(case when name = 'total PGA used for auto workareas'then value else 0 end) PGA_used_auto,
           sum(case when name = 'total PGA used for manual workareas'then value else 0 end) PGA_used_man,
           sum(case when name = 'global memory bound' then value else 0 end)               glob_mem_bnd,
           sum(case when name = 'aggregate PGA auto target' then value else 0 end)               pat
      from dba_hist_pgastat pg,
           dba_hist_snapshot s
	    where s.snap_id between :bsnap + 1 and  :esnap
   	    and pg.snap_id = s.snap_id
   	    and pg.instance_number = s.instance_number
           group by s.instance_number, s.snap_id, trunc(end_interval_time,'HH24')
           ) mu
             , dba_hist_parameter p
     where p.snap_id = mu.snap_id
       and p.instance_number = mu.instance_number
       and p.parameter_name     = 'pga_aggregate_target'
       and p.value             != '0'
order by rpad(to_char(mu.instance_number),6), ttime;


-- break on instance_number  skip 1

PROMPT
PROMPT "UNDO STATISTICS"
PROMPT "~~~~~~~~~~~~~~~"

col tsname heading '.|-|Tablespace' jus r null 'N/A' format a10
col tsize heading '.|TBS|Size(mb)' jus r null 'N/A' format 999,999.99
col tmaxsize heading '.|TBS|Max.Size(mb)' jus r null 'N/A' format 999,999.99
col tusedsize heading '.|TBS|Used.Size(mb)' jus r null 'N/A' format 999,999.99
col unxpstealcnt heading '.|UnExp|Steal.Cnt' jus r null 'N/A' format 999,999
col unxpblkrelcnt heading 'UnExp|Block|Rel.Cnt' jus r null 'N/A' format 999,999
col unxpblkreucnt heading 'UnExp|Block|Reuse.Cnt' jus r null 'N/A' format 999,999
col expstealcnt  heading 'Expired|Steal.Cnt' jus r null 'N/A' format 999,999
col expblkrelcnt heading 'Expired|Block|Rel.Cnt' jus r null 'N/A' format 999,999
col expblkreucnt heading 'Expired|Block|Reuse.Cnt' jus r null 'N/A' format 999,999
col activeblks heading '.|Active|Blocks' jus r null 'N/A' format 999,999
col unexpiredblks heading '.|UnExpired|Blocks' jus r null 'N/A' format 999,999,999
col expiredblks  heading '.|Expired|Blocks' jus r null 'N/A' format 999,999
col tuned_undoretention heading '.|Tuned|Undo.Ret' jus r null 'N/A' format 999,999


select 
rpad(to_char(u.instance_number),6) instance_number,
trunc(begin_time,'HH24') begin_time,
ts.tsname,
sum(su.tablespace_size)/1024/1024 tsize,
sum(su.tablespace_maxsize)/1024/1024 tmaxsize,
sum(su.tablespace_usedsize)/1024/1024 tusedsize,
sum(UNXPSTEALCNT) unxpstealcnt,
sum(UNXPBLKRELCNT) unxpblkrelcnt,
sum(UNXPBLKREUCNT) unxpblkreucnt,
sum(EXPSTEALCNT) expstealcnt,
sum(EXPBLKRELCNT) expblkrelcnt,
sum(EXPBLKREUCNT) expblkreucnt,
sum(ACTIVEBLKS) activeblks,
sum(UNEXPIREDBLKS) unexpiredblks,
sum(EXPIREDBLKS) expiredblks,
max(tuned_undoretention) tuned_undoretention
from dba_hist_undostat u,
     dba_hist_tbspc_space_usage su,
     dba_hist_tablespace_stat ts
  where u.snap_id between :bsnap + 1 and  :esnap
       and u.snap_id = su.snap_id
       and u.snap_id = ts.snap_id
       and u.instance_number = ts.instance_number
       and u.undotsn = su.tablespace_id
       and u.undotsn = ts.ts#
group by rpad(to_char(u.instance_number),6), trunc(begin_time,'HH24'),  ts.tsname
order by rpad(to_char(u.instance_number),6), begin_time;


col begin_time   heading "Begin.Time" jus r null 'N/A' format a20
col end_time   heading "End.Time" jus r null 'N/A' format a20
col maxquerysqlid   heading "Max Query|SQLID" jus r null 'N/A' format a15
col undoblks heading "Undo Blks" jus r null 'N/A' format 99,999
col undotsn heading "Last|Active Undo" jus r null 'N/A' format 99,999
col txncount heading "Txn|Count" jus r null 'N/A' format 99,999,999
col maxquerylen heading "Max|Query.Length" jus r null 'N/A' format 99,999
col maxconcurrency heading "Max|Concurrency" jus r null 'N/A' format 99,999
col ssolderrcnt heading "SnapShot|Too.Old.Cnt" jus r null 'N/A' format 99,999


select
maxquerysqlid,
undotsn,
max(undoblks) undoblks,
max(txncount) txncount,
max(maxquerylen) maxquerylen,
max(maxconcurrency) maxconcurrency,
max(ssolderrcnt) ssolderrcnt
from dba_hist_undostat
  where snap_id between :bsnap and :esnap
group by undotsn, maxquerysqlid
order by maxconcurrency;



select
trunc(begin_time,'HH24') begin_time,
trunc(end_time, 'HH24') end_time,
maxquerysqlid,
undotsn,
max(undoblks) undoblks,
max(txncount) txncount,
max(maxquerylen) maxquerylen,
max(maxconcurrency) maxconcurrency,
max(ssolderrcnt) ssolderrcnt
from dba_hist_undostat
  where snap_id between :bsnap and :esnap
group by trunc(begin_time,'HH24'),trunc(end_time, 'HH24'), undotsn, maxquerysqlid
order by  begin_time;



spool off
