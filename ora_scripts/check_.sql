set termout off;
set heading off;
set feedback off;


Prompt check Start

col filename new_value fname
col spoolfile new_value spf

select 'D:\clover\cloverdba\check\' filename from dual;
select '&fname' || 'CHECK_' || name || '_' || trunc(sysdate) || '.html' spoolfile from dual,V$database;
spool &spf

spool off;

Prompt check Stop

set termout on;
set heading on;
set feedback on;
