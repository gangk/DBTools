select a.cursors, a.sql_id,b.sql_text
from
(
select count(*) as cursors, ssc.sql_id
from v$sql_shared_cursor ssc
group by ssc.sql_id
order by cursors desc
) a,
(
select sa.sql_id, sa.sql_text from v$sqlarea sa
) b
where a.sql_id=b.sql_id
and a.cursors >100
order by a.cursors;
