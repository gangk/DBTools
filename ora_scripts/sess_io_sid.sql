COLUMN   block_gets             FORMAT   999,999,999   HEADING 'Block Gets'
COLUMN   consistent_gets        FORMAT   999,999,999   HEADING 'Consistent Gets'
COLUMN   physical_reads         FORMAT   999,999,999   HEADING 'Physical Reads'
COLUMN   block_changes          FORMAT   999,999,999   HEADING 'Block Changes'
COLUMN   consistent_changes     FORMAT   999,999,999   HEADING 'Consistent Changes'

SELECT     sio.block_gets,             
           sio.consistent_gets,        
           sio.physical_reads,        
           sio.block_changes,          
           sio.consistent_changes
FROM     v$sess_io sio
WHERE    sio.sid = &&user_sid
/
