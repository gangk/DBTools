COLUMN sid                     FORMAT 99999            HEADING 'SID'
COLUMN serial_id               FORMAT 99999999         HEADING 'Serial ID'
COLUMN session_status          FORMAT a9               HEADING 'Status'          JUSTIFY right
COLUMN oracle_username         FORMAT a14              HEADING 'Oracle User'     JUSTIFY right
COLUMN os_username             FORMAT a12              HEADING 'O/S User'        JUSTIFY right
COLUMN os_pid                  FORMAT 9999999          HEADING 'O/S PID'         JUSTIFY right
COLUMN session_program         FORMAT a18              HEADING 'Session Program' TRUNC
COLUMN session_machine         FORMAT a15              HEADING 'Machine'         JUSTIFY right
COLUMN number_of_undo_records  FORMAT 999,999,999,999  HEADING "# Undo Records"
COLUMN used_undo_size          FORMAT 999,999,999,999  HEADING  "Used Undo Size"

SELECT
    s.sid                  sid
  , lpad(s.status,9)       session_status
  , lpad(s.username,14)    oracle_username
  , lpad(s.osuser,12)      os_username
  , lpad(p.spid,7)         os_pid
  , b.used_urec            number_of_undo_records
  , b.used_ublk * d.value  used_undo_size
  , s.program              session_program
  , lpad(s.machine,15)     session_machine
FROM
    v$process      p
  , v$session      s
  , v$transaction  b
  , v$parameter    d
WHERE
      b.ses_addr =  s.saddr
  AND p.addr (+) =  s.paddr
  AND s.audsid   <> userenv('SESSIONID')
  AND d.name     =  'db_block_size';
