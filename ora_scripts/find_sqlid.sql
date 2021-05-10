--------------------------------------------------------------------------------
--
-- File name:   find_sqlid_h.sql
-- Purpose:     Search sqlids  in memory 
--
--
--------------------------------------------------------------------------------


set verify off
col sql_text format a100
col sid format 999

select distinct sql_id,sql_text
from v$sql s
where upper(sql_text) like upper(nvl('%&sql_text%',sql_text))
and sql_text not like '%from v$sql where sql_text like nvl(%';
