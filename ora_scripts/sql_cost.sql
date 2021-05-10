set linesize 144
set verify off  

column        executions        new_value m_exe_ct
column        rows_processed        new_value m_row_ct
column        buffer_gets        new_value m_buf_ct
column        disk_reads        new_value m_dsk_ct  

define m_exe_ct = 0
define m_row_ct = 0
define m_buf_ct = 0
define m_dsk_ct = 0  

select
        sql_id,
        child_number,
        executions,
        executions - &m_exe_ct                         exe_delta,
        buffer_gets,
        buffer_gets - &m_buf_ct                 buf_delta,
        disk_reads,
        disk_reads - &m_dsk_ct                         dsk_delta,
        rows_processed,
        rows_processed - &m_row_ct                 row_delta,
        round(
                (rows_processed - &m_row_ct) /
                nullif(executions - &m_exe_ct,0)
        )                                        rows_per_exe,
        round(
                (buffer_gets - &m_buf_ct) /
                nullif(executions - &m_exe_ct,0)
        )                                        bufs_per_exe,
        round(
                (disk_reads - &m_dsk_ct) /
                nullif(executions - &m_exe_ct,0)
        )                                        dsks_per_exe
from
        v$sql
where
        sql_id = '&sql_id'
and        child_number = &child_number
;  