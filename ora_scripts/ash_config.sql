@plusenv

COLUMN parameter           FORMAT a40
COLUMN description         FORMAT a75 WORD_WRAPPED
COLUMN "Session VALUE"     FORMAT a20
COLUMN "Instance VALUE"    FORMAT a20

SELECT
   a.ksppinm  "Parameter",
   b.ksppstvl "Session Value",
   c.ksppstvl "Instance Value",
   a.ksppdesc "Description"
FROM
   x$ksppi a,
   x$ksppcv b,
   x$ksppsv c
WHERE
   a.indx = b.indx
   AND
   a.indx = c.indx
and a.ksppinm in 
(
 	 '_ash_compression_enable'
	,'_ash_disk_filter_ratio'
	,'_ash_disk_write_enable'
	,'_ash_dummy_test_param'
	,'_ash_eflush_trigger'
	,'_ash_enable'
	,'_ash_min_mmnl_dump'
	,'_ash_sample_all'
	,'_ash_sampling_interval'
	,'_ash_size'
)
order by 1
;

prompt == second line is PDT ===;
col cdate	format a20
col mindate	format a20
col maxdate	format a20
col duration	format a25
select 	 to_char(sysdate,'MM/DD/YY HH24:MI:SS') cdate
	,to_char(min(SAMPLE_TIME),'MM/DD/YY HH24:MI:SS') mindate
	,to_char(max(SAMPLE_TIME),'MM/DD/YY HH24:MI:SS') maxdate
	,max(SAMPLE_TIME) - min(SAMPLE_TIME)		duration
from v$active_session_history
union all
select 	 to_char(new_time(sysdate,'GMT','PDT'),'MM/DD/YY HH24:MI:SS') cdate
	,to_char(min(new_time(SAMPLE_TIME,'GMT','PDT')),'MM/DD/YY HH24:MI:SS') mindate
	,to_char(max(new_time(SAMPLE_TIME,'GMT','PDT')),'MM/DD/YY HH24:MI:SS') maxdate
	,max(SAMPLE_TIME) - min(SAMPLE_TIME)		duration
from v$active_session_history
;

col kb		format 99,999,999.99

break on pool skip 1
compute sum of kb on pool

select pool, name, bytes/1024 kb
from v$sgastat
where name = 'ASH buffers'
order by pool, bytes;
