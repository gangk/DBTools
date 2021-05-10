accept master_link prompt 'Enter master_link ( enter to pick all ) : '
set linesize 500
col last_refresh_date for a20
col refresh_group for a25 trunc
column interval format 999999
column "Minutes Behind" format 999999.99 heading "Minutes|Behind"
column "master link" format a18
column "mview owner" format a10 heading "Mview|Owner"
column next_date format a20

select * from 
(SELECT mv.owner as "mview owner",
mv.mview_name as "mview name",
mv.master_link as "master link",
1440*(sysdate - mv.last_refresh_date) as "Minutes Behind",
mv.last_refresh_date,
int.next_date,
int.interval,
gr.refresh_group
FROM dba_mviews mv,
(
SELECT child.owner,
child.name,
job.next_date,
job.next_date - job.last_date as interval
FROM dba_refresh ref,
dba_refresh_children child,
dba_jobs job
WHERE ref.rname = child.rname
AND ((upper(job.what) LIKE '%'||ref.rname||'%')
      OR (upper(job.what) LIKE '%'||ref.rname||'%'))
) int,
mview_refresh_groups  gr
WHERE mv.owner = int.owner(+)
AND mv.mview_name = int.name(+)
AND mv.refresh_method = 'FAST'
and mv.mview_name = gr.mview_name
and upper(mv.master_link) like upper('%&master_link%')
ORDER BY (sysdate - mv.last_refresh_date) * 1440 DESC, mv.owner, mv.mview_name)
where rownum <21;


