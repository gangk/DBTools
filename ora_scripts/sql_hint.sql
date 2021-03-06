----------------------------------------------------------------------------------------
--
-- File name:   sql_hints_.sql
--
-- Purpose:     List outline hints for a given cursor.
--
-- Author:      Kerry Osborne
--
-- Usage:       This scripts prompts for two values.
--
--              sql_id: the sql_id of the statement (must be in the shared pool)
--
--              child_no: the child_no of the statement from v$sql
--
--
-- Description: 
--
--              Pulls Outline Hints from the OTHER_XML field of V$SQL_PLAN.
--
--              See kerryosborne.oracle-guy.com for additional information.
---------------------------------------------------------------------------------------
select
extractvalue(value(d), '/hint') as outline_hints
from
xmltable('/*/outline_data/hint'
passing (
select
xmltype(other_xml) as xmlval
from
v$sql_plan
where
sql_id like nvl('&sql_id',sql_id)
and child_number = &child_no
and other_xml is not null
)
) d;