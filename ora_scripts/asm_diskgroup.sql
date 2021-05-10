SET pages 32767 
SET lines 255 
SET numf 999,999


COLUMN NAME                      HEAD "DiskGroup"                   FORMAT A15
COLUMN type                      HEAD "Type"                        FORMAT A6
COLUMN compatibility             HEAD "ASM|Compat"                  FORMAT A10
COLUMN database_compatibility    HEAD "RDBMS|Compat"                FORMAT A10
COLUMN allocation_unit_size_MB   HEAD "AU|Size|(MB)"                FORMAT 999
COLUMN offline_disks             HEAD "Offline|Disks"
COLUMN TOTAL_GB                  HEAD "Total|(GB)"
COLUMN FREE_GB                   HEAD "Free|(GB)"
COLUMN used_GB                   HEAD "Used|(GB)"
COLUMN hot_used_GB               HEAD "Hot|Used|(GB)"
COLUMN cold_used_GB              HEAD "Cold|Used|(GB)"
COLUMN REQUIRED_MIRROR_FREE_GB   HEAD "Required|Free|Mirror|(GB)"  JUSTIFY RIGHT
COLUMN USABLE_GB                 HEAD "Usable|Free|(GB)"

TTITLE LEFT "A S M    D I S K G R O U P    S P A C E   U S A G E   R E P O R T"  

BREAK ON REPORT	
COMPUTE SUM LABEL 'Total' OF TOTAL_GB                 FORMAT 99,999,999  ON REPORT 
COMPUTE SUM LABEL 'Total' OF FREE_GB                  FORMAT 99,999,999 ON REPORT 
COMPUTE SUM LABEL 'Total' OF USED_GB              FORMAT 99,999,999 ON REPORT 
COMPUTE SUM LABEL 'Total' OF HOT_USED_GB              FORMAT 99,999,999 ON REPORT 
COMPUTE SUM LABEL 'Total' OF COLD_USED_GB             FORMAT 99,999,999 ON REPORT 
COMPUTE SUM LABEL 'Total' OF REQUIRED_MIRROR_FREE_GB  FORMAT 99,999,999 ON REPORT 
COMPUTE SUM LABEL 'Total' OF USABLE_GB                FORMAT 9,999,999 ON REPORT 


--  Note:
--  The GROUP_NUMBER, TOTAL_MB, and FREE_MB columns are only 
--  meaningful if the disk group is mounted by the instance. Otherwise, their values will be 0.


SELECT NAME
	 , state
	 , type
	 , compatibility
	 , database_compatibility
	 , allocation_unit_size/1024/1024 allocation_unit_size_MB
     , offline_disks
     , ROUND(TOTAL_MB/1024) TOTAL_GB
	 , ROUND(FREE_MB/1024)  FREE_GB
	 , ROUND((hot_used_mb + cold_used_mb) /1024) USED_GB
	 , ROUND(hot_used_mb/1024) HOT_USED_GB
	 , ROUND(cold_used_mb/1024) COLD_USED_GB
	 , ROUND(REQUIRED_MIRROR_FREE_MB/1024)  REQUIRED_MIRROR_FREE_GB
	 , ROUND(USABLE_FILE_MB /1024)  USABLE_GB
 FROM v$asm_diskgroup;