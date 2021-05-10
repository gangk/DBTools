select *
from v$enqueue_stat
where eq_type = 'SQ';
