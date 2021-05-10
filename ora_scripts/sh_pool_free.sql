select * from v$sgastat
    where pool = 'shared pool'
    and name = 'free memory';

