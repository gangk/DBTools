SELECT
 gc_current_block_receive_time AS "Receive Time",
 gc_current_blocks_received AS "Blocks Received",
 (gc_current_block_receive_time * 10) / gc_current_blocks_received
 AS "Average (MS)"
 FROM
 (
 SELECT value AS gc_current_block_receive_time
 FROM v$sysstat
 WHERE name = 'gc current block receive time'
 ),
 (
 SELECT value AS gc_current_blocks_received
 FROM v$sysstat
 WHERE name = 'gc current blocks received'
)
/