select
c.oid as "Table ID",
s.oid as "Schema ID",
trim(c.relname) as "Name",
trim(s.nspname) as "Schema",
trim(u.usename) as "Owner",
coalesce(c.reltuples, 0)::bigint as "Rows",
coalesce(t.rows, 0) as "Rows with deleted",
coalesce(t.sorted_rows, 0) as "Sorted Rows",
coalesce(t.min_rows, 0) as "Min Rows",
coalesce(t.max_rows, 0) as "Max Rows",
coalesce(t.blocks, 0)/(1024^2) as "TBs",
coalesce(t.temp, 0) as "Temp Space",
c.relnatts as "Columns",
current_database() as db
from pg_catalog.pg_class c
join pg_catalog.pg_namespace s on s.oid = c.relnamespace
and s.nspname not in
(
'pg_catalog',
'information_schema',
'pg_toast',
'pg_bitmapindex',
'pg_internal',
'pg_aoseg'
)
join pg_catalog.pg_user u on u.usesysid = c.relowner
left join
(
select
p.id,
p.db_id,
sum(coalesce(p.rows, 0)) as rows,
sum(coalesce(p.sorted_rows, 0)) as sorted_rows,
sum(coalesce(p.temp, 0)) as temp,
min(coalesce(p.rows, 0)) as min_rows,
max(coalesce(p.rows, 0)) as max_rows,
sum(b.blocknum) as blocks
from (select distinct slice from pg_catalog.stv_blocklist) bl
left join pg_catalog.stv_tbl_perm p on p.slice = bl.slice
left join pg_catalog.pg_database d on d.datname = current_database()
left join
(
select
bl.tbl, bl.slice, count(bl.blocknum) as blocknum
from pg_catalog.stv_blocklist bl
group by bl.tbl, bl.slice
)
b on b.tbl = p.id
and b.slice = p.slice
group by p.id, p.db_id
)
t on t.id = c.oid
where c.relkind = 'r'
order by c.relname, s.nspname;
