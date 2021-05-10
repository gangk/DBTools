
REM   10.2.x Version
REM
REM   CandidateSearch
REM
REM   These two queries look at the objects loaded in cache
REM   from two perspectives.   First we find
REM   those objects that are being reloaded over time
REM   that require a big memory footprint.  These objects
REM   being loaded over and over will increse fragmentation
REM   problems.   The second query looks at the objects
REM   in the Shared Pool that are being loaded frequently.
REM   Objects loaded due to invalidations are not as bad 
REM   an impact on the Shared Pool.   Those being loaded
REM   because they are aging out too quickly may be 
REM   candidates to pin.   Particularly if they are being executed
REM   many times.

set pages 999
set lines 120

col namespace format a30 heading "Object Type"
col name format a25 word_wrapped heading "Code Loaded"
col sharable_mem format 999,999,999,999 heading "Memory Footprint"
col invalidations format 999,999,999 heading "Invalidations"
col loads format 999,999,999 heading "Loads"
col executions format 999,999,999,999 heading "Executions"

select namespace, name, sharable_mem, invalidations, loads, executions from gv$db_object_cache
where loads > invalidations
and sharable_mem > 1000000
order by sharable_mem desc
/

select namespace, name, sharable_mem, invalidations, loads from gv$db_object_cache
where loads > invalidations+5
and sharable_mem > 100000
order by loads desc
/
