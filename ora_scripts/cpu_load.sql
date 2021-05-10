select event,  cnt,
(ratio_to_report(cnt) over ())*100 "%age of wait" from (
select event, sum(cnt) cnt from (
select case when event='latch free' and p2=157 then event||'. Library Cache' else  
event end event, 1 cnt from v$session_wait) group by event
order by 2)
/