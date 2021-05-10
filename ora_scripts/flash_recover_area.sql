set echo off
--
-- Show flashback database file destination
-- Oracle version 10g and up
--
-- 20050503  Mark D Powell   Save flashback area query
-- 20060120  Mark D Powell   Modify column display formatting
--
col name              format a65       fold_after
col number_of_files   format    99,999 heading "File Ct"
col space_limit       format 9,999,999 heading "Alloc (M)"
col space_used        format 9,999,999 heading "Usage (M)"
col space_reclaimable format 9,999,999 heading "Reclaimable"
 
prompt "no rows selected" response means flashback database is not configured
 
select
  name
 ,round(space_limit       / 1048576, 1) as space_limit
 ,round(space_used        / 1048576, 1) as space_used
 ,round(space_reclaimable / 1048576, 1) as space_reclaimable
 ,number_of_files
from
  v$recovery_file_dest
/