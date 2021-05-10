 PRINT###To discover which sessions are currently being blocked, first find this line in the preceding query:
 PRINT###> WHERE blocker = 1
 PRINT###Once you locate the line, change it to this instead:
 PRINT###> WHERE blocked = 1
 
 SELECT
 dl.inst_id,
 s.sid,
 p.spid,
 dl.resource_name1,
 decode (substr (dl.grant_level,1,8),
 'KJUSERNL','Null',
 'KJUSERCR','Row-S (SS)',
 'KJUSERCW','Row-X (SX)',
 'KJUSERPR','Share',
 'KJUSERPW','S/Row-X (SSX)',
 'KJUSEREX','Exclusive',
 request_level) as grant_level,
 decode(substr(dl.request_level,1,8),
 'KJUSERNL','Null',
 'KJUSERCR','Row-S (SS)',
 'KJUSERCW','Row-X (SX)',
 'KJUSERPR','Share',
 'KJUSERPW','S/Row-X (SSX)',
 'KJUSEREX','Exclusive',
 request_level) as request_level,
 decode(substr(dl.state,1,8),
 'KJUSERGR','Granted','KJUSEROP','Opening',
 'KJUSERCA','Cancelling',
 'KJUSERCV','Converting'
 ) as state,
sw.event,
 sw.seconds_in_wait sec
 FROM
 gv$ges_enqueue dl,
 gv$process p,
 gv$session s,
 gv$session_wait sw
 WHERE blocker = 1
 AND (dl.inst_id = p.inst_id AND dl.pid = p.spid)
 AND (p.inst_id = s.inst_id AND p.addr = s.paddr)
 AND (s.inst_id = sw.inst_id AND s.sid = sw.sid)
 ORDER BY sw.seconds_in_wait DESC 