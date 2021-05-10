set pages 1000
break on Group# on Disk#
SELECT d.group_number "Group#", d.disk_number "Disk#", p.number_kfdpartner "Partner disk#"
FROM x$kfdpartner p, v$asm_disk d
WHERE p.disk=d.disk_number and p.grp=d.group_number
ORDER BY 1, 2, 3;