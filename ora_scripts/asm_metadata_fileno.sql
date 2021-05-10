select NUMBER_KFFXP "ASM file number", DECODE (NUMBER_KFFXP,1, 'File directory', 2, 'Disk directory', 3, 'Active change directory', 4, 'Continuing operations directory',
5, 'Template directory', 6, 'Alias directory', 7, 'ADVM file directory', 8, 'Disk free space directory',
9, 'Attributes directory', 10, 'ASM User directory', 11, 'ASM user group directory', 12, 'Staleness directory',253, 'spfile for ASM instance', 254, 'Stale bit map space registry ', 255, 'Oracle Cluster Repository registry') "ASM metadata file name",
count(AU_KFFXP) "Allocation units"
from X$KFFXP
where GROUP_KFFXP=3 and NUMBER_KFFXP<256
group by NUMBER_KFFXP
order by 1;