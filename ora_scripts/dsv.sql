set termout off feedback off colsep &1

spool C:\output_&_connect_identifier..csv
/

spool off
set colsep " "
host start C:\output_&_connect_identifier..csv
set termout on feedback on
