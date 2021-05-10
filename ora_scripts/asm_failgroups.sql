COLUMN DiskGroup FORMAT A10
COLUMN Disk FORMAT A30
COLUMN Partner_Disk FORMAT A30
COLUMN DiskGroup FORMAT A0
COLUMN FAILGROUP FORMAT A20
COLUMN PARTNER_FAILGROUP FORMAT A20
COLUMN path FORMAT A30
COLUMN PARTNER_PATH FORMAT A30

SELECT dg1.name DiskGroup
  , d1.NAME Disk
--  , d1.path
  , d1.FAILGROUP
  , d2.name Partner_Disk
  , d2.FAILGROUP PARTNER_FAILGROUP
--  , d2.path PARTNER_PATH
FROM x$kfdpartner p
  , v$asm_disk d1
  , v$asm_diskgroup dg1
  , v$asm_disk d2
WHERE dg1.group_number      = d1.group_number
    AND p.GRP               = dg1.group_number
    AND p.disk              = d1.DISK_NUMBER
    AND p.GRP               = d2.group_number (+)
    AND p.NUMBER_KFDPARTNER = d2.DISK_NUMBER  (+)
 AND dg1.name like '%%' --DiskGroup Name
 AND d1.name like '%%'  --Disk Name
ORDER BY dg1.name
       , d1.NAME;
