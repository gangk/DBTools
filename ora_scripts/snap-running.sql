REM -----------------------------------------------------
REM $Id: snap-running.sql,v 1.1 2002/03/14 00:25:42 hien Exp $
REM Author      : Murray, Ed
REM #DESC       : Display info about currently running snapshot refresh jobs
REM Usage       : No parameters
REM Description : Display info about currently running snapshot refresh jobs
REM -----------------------------------------------------

select spid, sid, v$process.program
 from v$session, v$process where addr = paddr
and v$process.program like '%SNP%'
/
