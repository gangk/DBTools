Prompt ==============================>Summary<=====================================
col dml_type for a10
col module for a48
col program for a10
col sql_text for a45
col machine for a20
col object_name for a30
select sql_id,module,decode(command,2,'INSERT',6,'UPDATE',7,'DELETE',189,'MERGE')as dml_type,count(*) from v$session where command in (2,6,7,189) group by sql_id,module,decode(command,2,'INSERT',6,'UPDATE',7,'DELETE',189,'MERGE') order by 4 desc;

prompt  ==============================>Detail Overview<=====================================
select distinct s.sid,s.serial#,nvl(s.module,substr(s.program,instr(s.program,'('),12)) module ,decode(s.command,2,'INSERT',6,'UPDATE',7,'DELETE',189,'MERGE')as dml_type,s.sql_id,substr(s.machine,1,20) machine,substr(sq.sql_text,1,45) sql_text
from v$session s, v$sql sq
where 
s.command in (2,6,7,189)
and s.sql_id=sq.sql_id;

