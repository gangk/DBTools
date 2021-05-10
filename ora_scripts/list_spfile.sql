--- Listspfiles.sql
--- Purpose: Sample script to list spfiles kept in ASM instance
--- Usage: This should be run against an ASM instance,
--- Not a database instance.
---
--- Cut here --%<----%<----%<----%<----%<----%<--

- List all spfiles

set lines 120
col full_path for a110
SELECT full_path, dir, sys
FROM
(SELECT
CONCAT ('+'|| gname, SYS_CONNECT_BY_PATH (aname ,'/')) full_path,
dir, sys FROM
(SELECT g.name gname,
a.parent_index pindex, a.name aname,
a.reference_index rindex, a.ALIAS_DIRECTORY dir,
a.SYSTEM_CREATED sys
FROM v $ asm_alias a, v $ asm_diskgroup g
WHERE a.group_number = g.group_number)
START WITH (MOD (pindex, POWER (2, 24))) = 0
CONNECT BY PRIOR rindex = pindex
ORDER BY dir desc, full_path asc)
WHERE UPPER (full_path) LIKE '% SPFILE%'
/