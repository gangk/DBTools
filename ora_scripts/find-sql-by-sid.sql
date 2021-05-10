REM -----------------------------------------------------
REM $Id: find-sql-by-sid.sql,v 1.1 2002/03/14 00:01:52 hien Exp $
REM Author      : Kinney, Jamie
REM #DESC       : Find sql text given session id (sid)
REM Usage       : sid - session id
REM Description : Find sql text given session id (sid)
REM -----------------------------------------------------

undefine sid;

select sql_text
from v$sqlarea
where hash_value = (
	select sql_hash_value
	from v$session
	where sid = &sid);

undefine sid;
