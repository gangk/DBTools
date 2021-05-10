SELECT
 gc_cr_block_receive_time AS "Receive Time",
 gc_cr_blocks_received AS "Blocks Received",
 (gc_cr_block_receive_time * 10) /
 gc_cr_blocks_received AS "Average Latency (MS)"
 FROM
 (
 SELECT value AS gc_cr_block_receive_time FROM v$sysstat
 WHERE name = 'gc cr block receive time'
 ),
 (
 SELECT value AS gc_cr_blocks_received FROM v$sysstat
 WHERE name = 'gc cr blocks received'
 )