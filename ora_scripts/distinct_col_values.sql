PROMPT
PROMPT *************************
PROMPT *** IDEAL SELECTIVITY IS 1 ***
PROMPT *************************


select owner,column_name, num_distinct from dba_tab_columns where table_name = '&table_name'; 


