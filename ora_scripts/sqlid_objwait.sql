@plusenv
undef sql_id
col event	format a26	trunc
col objname	format a71	
col fno		format 999
col blkno	format 999999
select * from
(
select event,
        time_waited,
        current_file# fno,
        current_block# blkno,
        owner||'.'||rpad(object_name,30,' ')||'~ '||rpad(subobject_name,30,' ') objname
from    sys.v_$active_session_history a,
        sys.dba_objects b 
where   sql_id = '&&sql_id' and
        a.current_obj# = b.object_id and
        time_waited <> 0
order by time_waited desc
)
where rownum < 11;
