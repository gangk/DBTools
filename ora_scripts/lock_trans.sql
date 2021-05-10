col owner for a15
col object_name for a25
select
    owner               object_owner,
    object_name         object_name,
    session_id          oracle_sid,
    oracle_username     db_user,
    decode(LOCKED_MODE,
        0, 'None',
        1, 'Null',
        2, 'Row Share',
        3, 'Row Exclusive',
        4, 'Share',
        5, 'Sub Share Exclusive',
        6, 'Exclusive',
        locked_mode
    )                   locked_mode
    from v$locked_object lo,
        dba_objects do
    where
        (xidusn||'.'||xidslot||'.'||xidsqn)
            = ('&transid')
    and
        do.object_id = lo.object_id
/