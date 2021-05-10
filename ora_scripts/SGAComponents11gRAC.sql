REM  Investigate SGA components
REM     These queries do not impact performance on the database and you can run them 
REM     as often as you like

set lines 132
set pages 999
set termout off
set trimout on
set trimspool on

spool components.out
col component for a25 head "Component"
col status format a10 head "Status"
col initial_size for 999,999,999,999 head "Initial"
col parameter for a25 heading "Parameter"
col final_size for 999,999,999,999 head "Final"
col changed head "Changed At"
col current_size for 999,999,999,999 head "Current Size"
col user_specified_size for 999,999,999,999 head "Explicit Setting"
col min_size for 999,999,999,999 head "Min Size"
col max_size for 999,999,999,999 head "Max Size"
col granule_size for 999,999,999,999 head "Granule Size"

break on report
compute sum of current_size on report


select inst_id, component, user_specified_size, current_size, granule_size
from gv$memory_dynamic_components
order by component, inst_id
/

col last_oper_type for a15   head "Operation|Type"
col last_oper_mode for a15  head "Operation|Mode"
col lasttime for a25 head "Timestamp"

select inst_id, component, last_oper_type, last_oper_mode, 
  to_char(last_oper_time, 'mm/dd/yyyy hh24:mi:ss') lasttime
from gv$memory_dynamic_components
order by 2, 1
/

select inst_id, component, parameter, initial_size, final_size, status, 
to_char(end_time ,'mm/dd/yyyy hh24:mi:ss') changed
from gv$memory_resize_ops
order by 1, 7
/

REM These values tend to help find explicit (minimum settings)
REM for the components to help auto-tuning
REM steer clear of over-aggressive moving of memory
REM withing the SGA

col low format 999,999,999,999 head "Lowest"
col high format 999,999,999,999 head "Highest"
col lowMB format 999,999 head "MBytes"
col highMB format 999,999 head "MBytes"

select inst_id, component, min(final_size) low, (min(final_size/1024/1024)) lowMB,
max(final_size) high, (max(final_size/1024/1024)) highMB
from gv$memory_resize_ops
group by component, inst_id
/


clear breaks

col name format a40 head "Name"
col resizeable format a4 head "Auto?"

select * from gv$sgainfo order by inst_id
/

spool off
set termout on
set trimout off
set trimspool off
clear col
