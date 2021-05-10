select g.name as "GROUP", d.name as "DISK", d.failgroup, fcnt, pcnt,
decode(pcnt - fcnt, 0, 'MUST', 'SHOULD') as action from
(select gnum, DISK1, failgroup, count(failgroup) as fcnt from
(select gnum, DISK1
from
(
select d.group_number as gnum, disk as disk1,
count(distinct failgroup) as dfail
from x$kfdpartner, v$asm_disk_stat d where
number_kfdpartner=disk_number and grp=d.group_number
and active_kfdpartner=1
group by d.group_number, disk
), v$asm_disk_stat
where dfail < 3
and disk1=disk_number
and gnum=group_number),
x$kfdpartner, v$asm_disk_stat d where
number_kfdpartner=disk_number and grp=d.group_number and grp=gnum
and disk1=disk
and active_kfdpartner=1
group by gnum, disk1, failgroup),
(select grp, disk, count(disk) as pcnt from x$kfdpartner where
active_kfdpartner=1 group by grp, disk),
v$asm_diskgroup_stat g, v$asm_disk_stat d
where gnum=grp and gnum=g.group_number and gnum=d.group_number and
disk=disk1 and disk=disk_number and
((fcnt = 1 and (pcnt - fcnt) > 3) or ((pcnt - fcnt) = 0))
/