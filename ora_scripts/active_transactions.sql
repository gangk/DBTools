select s.inst_id,s.sid, s.serial#, p.spid, s.username, s.program,
    t.xidusn, t.used_ublk, t.used_urec, s.last_call_et, sa.sql_text from
    gv$process p,gv$session s, gv$sqlarea sa, gv$transaction t
    where s.paddr=p.addr
    and s.taddr=t.addr
    and decode(s.sql_address,'00',s.prev_sql_addr,s.sql_address)=sa.address
    and decode(s.sql_hash_value,'0',s.prev_hash_value,null,s.prev_hash_value,s.sql_hash_value)=sa.hash_value
    order by s.inst_id;
