COLUMN name                HEADING "Name"                  FORMAT a25 
COLUMN value               HEADING "Current Value"         FORMAT a18 
COLUMN spfile_value        HEADING "SPFile Value"          FORMAT a18 


COLUMN component           HEADING "Component"             FORMAT a24
COLUMN user_specified_size HEADING "User|Specified|(MB)"   FORMAT 99,999,999
COLUMN current_size        HEADING "Current|(MB)"          FORMAT 99,999,999
COLUMN free_size           HEADING "Free|(MB)"             FORMAT 99,999,999
COLUMN min_size            HEADING "Min|(MB)"              FORMAT 99,999,999
COLUMN max_size            HEADING "Max|(MB)"              FORMAT 99,999,999
COLUMN GRANULE_SIZE        HEADING "Granule|(MB)"          FORMAT 9,999
COLUMN last_oper_type      HEADING "Last|Operation|Type"   FORMAT a12
COLUMN oper_count          HEADING "Operation|Count"       FORMAT 99,999,999
COLUMN last_oper_time      HEADING "Last|Operation|Time"   FORMAT a18 

BREAK ON REPORT
COMPUTE SUM LABEL 'Total' OF current_size FORMAT 99,999,999  ON REPORT 
COMPUTE SUM LABEL 'Total' OF free_size    FORMAT 99,999,999  ON REPORT 


select pp.name
     , pp.display_value value
     , sp.display_value spfile_value 
from v$system_parameter pp
   , v$spparameter sp
where pp.name = sp.name (+) 
and ( pp.name like '%sga%' or pp.name like '%memory%target')
/


SELECT c.component
     , ROUND(c.user_specified_size / 1024 / 1024) user_specified_size
     , ROUND(c.current_size        / 1024 / 1024) current_size
     , ROUND(NVL(s.bytes,0)        / 1024 / 1024) free_size
     , ROUND(c.min_size            / 1024 / 1024) min_size
     , ROUND(c.max_size            / 1024 / 1024) max_size
     , ROUND(c.GRANULE_SIZE        / 1024 / 1024) GRANULE_SIZE
     , c.oper_count
     , c.last_oper_type 
     , to_char(c.last_oper_time,'DD-MON-YY hh24:mi:Ss') last_oper_time
FROM  v$sga_dynamic_components c
    , V$SGASTAT s
WHERE c.component = s.pool (+)
  AND s.name (+) = 'free memory'  
ORDER BY c.current_size desc
/