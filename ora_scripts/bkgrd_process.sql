select
        A.SID,
        A.SERIAL#,
        A.PROGRAM,
        P.PID,
        P.SPID,
        A.OSUSER,       /* Who Started INSTANCE */
        A.TERMINAL,
        A.MACHINE,
        A.LOGON_TIME,
        B.NAME,
        B.Description
        ,P.PGA_USED_MEM
        ,P.PGA_FREEABLE_MEM
        ,P.PGA_MAX_MEM
from
        v$session       A,
        v$process       P,
        v$bgprocess     B
where
        A.PADDR=B.PADDR
AND     A.PADDR=P.ADDR
--and   A.type='BACKGROUND'
--Alternative (you can use BACKGROUND column from v$process )
--------------
AND     P.BACKGROUND=1
;
