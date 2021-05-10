--------------------------------------------------------------------------------
--
-- File name:   find_sqlid_h.sql
-- Purpose:     Search sqls in awr history for a given search key
--

-- Usage:      find_sqlid_h.sql
--
--------------------------------------------------------------------------------

set verify off
col sql_text format a100
col sqlid format a25

select sql_id,sql_text
from dba_hist_sqltext s
where upper(sql_text) like upper(nvl('%&sql_text%',sql_text))
and sql_text not like '%from v$sql where sql_text like nvl(%';