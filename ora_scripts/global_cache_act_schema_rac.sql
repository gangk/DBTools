SELECT
 table_name AS "Table Name",
 gc_buffer_busy AS "Buffer Busy",
 gc_cr_blocks_received AS "CR Blocks Received",
 gc_current_blocks_received AS "Current Blocks Received"
 FROM
(
SELECT table_name FROM dba_tables
 WHERE owner = 'TPCC'
 ) t,
 (
SELECT object_name,value AS gc_buffer_busy
 FROM v$segment_statistics
 WHERE owner = 'TPCC'
 AND object_type = 'TABLE'
 AND statistic_name = 'gc buffer busy'
 ) ss1,
 (
SELECT object_name,value AS gc_cr_blocks_received
 FROM v$segment_statistics
 WHERE owner = 'TPCC'
 AND object_type = 'TABLE'
 AND statistic_name = 'gc cr blocks received'
 ) ss2,
 (
SELECT object_name,value AS gc_current_blocks_received
 FROM v$segment_statistics
 WHERE owner = upper('&username')
 AND object_type = 'TABLE'
 AND statistic_name = 'gc current blocks received'
 ) ss3
 WHERE t.table_name = ss1.object_name
 AND t.table_name = ss2.object_name
 AND t.table_name = ss3.object_name
