REM -----------------------------------------------------
REM $Id: snap-refr-grp.sql,v 1.1 2002/04/01 22:46:11 hien Exp $
REM Author      : Murray, Ed
REM #DESC       : Show snapshot refresh groups and associated snapshots
REM Usage       : No parameters
REM Description : Show snapshot refresh groups and associated snapshots
REM -----------------------------------------------------

select r.rname, s.owner, s.name
from dba_snapshots s, dba_refresh r
where s.refresh_group = r.refgroup
order by 1,2,3
/
