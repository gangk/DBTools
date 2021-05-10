select s.sid, s.serial#,
      substr(q.sql_text, 1, 100) as sql_text
    from
      v$session s, v$sql q
    where
      s.taddr = (select addr from v$transaction
          where bitand(flag,268435456) = 268435456)
      and ((s.prev_hash_value = q.hash_value and s.prev_sql_addr = q.address)
           or (s.sql_hash_value = q.hash_value and s.sql_address = q.address))
   ;
