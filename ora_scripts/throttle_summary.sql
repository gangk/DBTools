Prompt ====================>ACTIVE JOBS<===================
col "OUTPUT TABLE" for a30
col ACTIVITY for a10
col "RUN ID" for 999999999
col type for a10
col PID for 99999
SELECT t.target_table AS "OUTPUT TABLE", t.sid AS "SID", t.serial# AS
"SERIAL#", activity AS "ACTIVITY",   TO_CHAR( activity_start_time,
'MM/DD/YYYY HH24:MI:SS' ) AS "START TIME",   ROUND( ( sysdate -
activity_start_time ) * 24*60*60 ) AS "RUN TIME",   t.run_id AS "RUN ID",   ROUND( ( SYSDATE - next_synch_window_start_time ) * ( 24 * 60 *
60 ) ) AS "DELAY",   NVL( merged_rows, 0 ) AS "ROWS MERGED", NVL(
deleted_rows, 0 ) AS "ROWS DELETED" FROM admin.throttle_snap_config t,
v$session s WHERE t.sid IS NOT NULL AND   t.sid = s.sid AND   t.serial#= s.serial# ORDER BY target_table;

Prompt ====================>ACTIVE Snapshot Refreshes <===================
SELECT currmvname_knstmvr AS "MVIEW NAME", r.target_table AS "OUTPUT TABLE",   a.sid AS "SID", a.serial# AS "SERIAL#",   DECODE(reftype_knstmvr, 0, 'FAST', 1, 'FAST', 2, 'COMPLETE', REFTYPE_KNSTMVR ) AS "TYPE",   DECODE(groupstate_knstmvr, 1, 'SETUP', 2, 'RUNNING',3,'WRAPUP', 'UNKNOWN' ) AS "STAGE",   total_inserts_knstmvr AS INSERTS,
total_updates_knstmvr AS UPDATES,   total_deletes_knstmvr AS DELETES,
b.spid AS "PID", c.event AS "EVENT" FROM x$knstmvr x, v$session a,
v$process b, v$session_wait c, admin.throttle_snap_config r WHERE
type_knst=6   AND a.paddr = b.addr   AND a.sid = c.sid   AND x.SID_KNST= a.sid   AND x.SERIAL_KNST = a.serial#   AND currmvname_knstmvr =r.source_table;
