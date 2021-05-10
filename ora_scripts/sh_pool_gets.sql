select child#, gets
    from v$latch_children
    where name = 'shared pool'
    order by child#;

