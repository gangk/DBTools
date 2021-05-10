column o.object_name format a20
column Holder format a20
column Waiter format a20
column "Lock Type" format a20
SELECT DISTINCT O.OBJECT_NAME, SH.USERNAME||'('||SH.SID||')' "Holder",
       SW.USERNAME||'('||SW.SID||')' "Waiter",
       DECODE(LH.LMODE, 1, 'null', 2, 'row share', 3, 'row exclusive', 4, 'share', 5, 'share row exclusive' , 6, 'exclusive')
       "Lock Type"
FROM all_objects o, v$session sw, v$lock lw, v$session sh, v$lock lh
WHERE
lh.id1  = o.object_id AND
lh.id1  = lw.id1 AND
sh.sid  = lh.sid AND
sw.sid  = lw.sid AND
sh.lockwait is null
  and  sw.lockwait is not null
  and  lh.type = 'TM'
  and  lw.type = 'TM';
