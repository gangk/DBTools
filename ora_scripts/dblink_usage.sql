select t.addr, s.sid, s.username, s.machine, s.status,
            (sysdate - to_date(t.start_time, 'MM/DD/YY HH24:MI:SS')) * 24 as hours_active
            from v$transaction t, v$session s
            where t.addr = s.taddr;