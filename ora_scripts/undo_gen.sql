select max(maxquerylen) from v$undostat;

select
  round(max(undoblks/600)*8192*max(maxquerylen)/(1024*1024)) as "UNDO in MB"
from v$undostat;
