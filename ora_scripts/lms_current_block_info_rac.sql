 SELECT
 average_latency AS "Average Latency",
 average_pin_time AS "Average Pin Time",
 average_flush_time AS "Average Flush Time",
 average_send_time AS "Average Send Time",
 average_latency - average_pin_time - average_flush_time - average_send_time
 AS "Average LMS Service Time"
 FROM
 (
 SELECT
 (gc_current_block_receive_time * 10) / gc_current_blocks_received
 AS average_latency,
 (gc_current_block_pin_time * 10) / gc_current_blocks_served
 AS average_pin_time,
 (gc_current_block_flush_time * 10) / gc_current_blocks_served
 AS average_flush_time,
 (gc_current_block_send_time * 10) / gc_current_blocks_served
 AS average_send_time
 FROM
 (
 SELECT value AS gc_current_block_receive_time FROM v$sysstat
 WHERE name = 'gc current block receive time'
 ),
 (
 SELECT value AS gc_current_blocks_received FROM v$sysstat
 WHERE name = 'gc current blocks received'
),
 (
 SELECT value AS gc_current_block_pin_time FROM v$sysstat
 WHERE name = 'gc current block pin time'
 ),
 (
 SELECT value AS gc_current_block_flush_time FROM v$sysstat
 WHERE name = 'gc current block flush time'
 ),
 (
 SELECT value AS gc_current_block_send_time FROM v$sysstat
 WHERE name = 'gc current block send time'
),
 (
 SELECT value AS gc_current_blocks_served FROM v$sysstat
 WHERE name = 'gc current blocks served'
 )
)
/