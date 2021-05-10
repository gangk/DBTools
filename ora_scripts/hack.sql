set heading  off 
set verify   off 
set feedback off 
 
prompt 
accept username char prompt 'Enter username to hack into: '
 
prompt  
prompt Creating revert.sql in the current working directory
prompt 

set termout off 
spool       revert.sql 

select 'alter user &&username identified by values '||
       ''''||
       password||
       ''''||
       ';' 
from   sys.dba_users
where  username = upper('&&username')
/

spool       off 
set termout on 
 
prompt  
prompt Altering user password to 'welcome'
prompt 

set termout off 
 
alter user    &&username
identified by welcome
/
 
set termout on 
prompt 
prompt ************************************************* 
prompt   The file revert.sql is in the current working   
prompt   directory.  Run it to reset the password.   
prompt ************************************************* 
prompt 
prompt
