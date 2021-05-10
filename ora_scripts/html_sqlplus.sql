----------------------------------------
-- get the last SQL*Plus output in HTML
-- after Tanel Poder
----------------------------------------

set termout off

set markup HTML ON HEAD " -
 -
" -
BODY "" -
TABLE "border='1' align='center' summary='Script output'" -
SPOOL ON ENTMAP ON PREFORMAT OFF

spool myoutput.html

l
/

spool off
set markup html off spool off
host firefox myoutput.html
set termout on