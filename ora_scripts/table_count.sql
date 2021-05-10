spool C:\tab_count.txt

SELECT  'select  '''||table_name||' : ''||count(rowid) from '||owner||'.'||table_name||' TABLE_COUNT ;'  from dba_tables where owner= '&owner' order by table_name;



spool off

@@C:\tab_count.txt









