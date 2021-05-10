/* 
   Library Cache Pin/Lock Pile Up hangs the application 
*/

set lines 100
SELECT s.SID
     , kglpnmod "Mode"
     , kglpnreq "Req"
     , SPID "OS Process"
     , s.program
FROM v$session_wait w, sys.x$kglpn p, v$session s ,v$process o
WHERE p.kglpnuse=s.saddr
AND kglpnhdl=w.p1raw
AND w.event LIKE '%library cache lock%'
AND s.paddr=o.addr;