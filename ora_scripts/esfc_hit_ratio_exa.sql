column c1 heading 'Event|Name' format a30 trunc
column c2 heading 'Total|Waits' format 99,999,999
column c3 heading 'Seconds|Waiting' format 9,999,999
column c5 heading 'Avg|Wait|(ms)' format 9999.9
column c6 heading 'Flash Cache Hits' for 999,999,999,999
col hit_ratio heading 'Hit Ratio' for 999.999
select
 'cell single + multiblock reads' c1,
 c2, c3, c5, c6,
 c6/decode(nvl(c2,0),0,1,c2) hit_ratio
 from (
 select
 sum(total_waits) c2,
 avg(value) c6,
 sum(time_waited / 100) c3,
 avg((average_wait /100)*1000) c5
 from
 sys.v_$system_event, v$sysstat ss
 where
 event in (
 'cell single block physical read',
 'cell multiblock physical read')
 and
 name like 'cell flash cache read hits'
 and
 event not like '%Idle%')
 order by
 c3
 ;