set pages 1000
set long 10000
col sql_text    format a80 word_wrapped heading 'SQL Statement'

SELECT
         sql_id,
         sql_text
FROM
         v$sql
WHERE    executions     > 0
AND      hash_value     = &sql_hash
AND      rownum         = 1
;
undef sql_hash
