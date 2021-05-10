SELECT
 average_latency AS "Average Latency",
 average_build_time AS "Average Build Time",
 average_flush_time AS "Average Flush Time",
 average_send_time AS "Average Send Time",
 average_latency - average_build_time - average_flush_time - average_send_time
 AS "Average LMS Service Time"
 FROM
(
 SELECT
 (gc_cr_block_receive_time * 10) / gc_cr_blocks_received AS average_latency,
 (gc_cr_block_build_time * 10) / gc_cr_blocks_served AS average_build_time,
 (gc_cr_block_flush_time * 10) / gc_cr_blocks_served AS average_flush_time,
 (gc_cr_block_send_time * 10) / gc_cr_blocks_served AS average_send_time
 FROM
 (
 SELECT value AS gc_cr_block_receive_time FROM v$sysstat
 WHERE name = 'gc cr block receive time'
 ),
 (
 SELECT value AS gc_cr_blocks_received FROM v$sysstat
 WHERE name = 'gc cr blocks received'
 ),
 (
 SELECT value AS gc_cr_block_build_time FROM v$sysstat
 WHERE name = 'gc cr block build time'
 ),
 (
 SELECT value AS gc_cr_block_flush_time FROM v$sysstat
 WHERE name = 'gc cr block flush time'
 ),
 (
 SELECT value AS gc_cr_block_send_time FROM v$sysstat
 WHERE name = 'gc cr block send time'
 ),
 (
 SELECT value AS gc_cr_blocks_served FROM v$sysstat
 WHERE name = 'gc cr blocks served'
 )
 )