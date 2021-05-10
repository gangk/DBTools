set pagesize 25
set linesize 120
accept start_time prompt 'Enter start_time (MM/DD) :- '
accept end_time    prompt 'Enter end_time  (MM/DD/YYYY HH24:MI:SS) :- '

select
          to_char(begin_time,'MM/DD/YYYY HH24:MI') begin_time, 
          UNXPSTEALCNT "# Unexpired|Stolen", 
          EXPSTEALCNT "# Expired|Reused", 
          SSOLDERRCNT "ORA-1555|Error", 
          NOSPACEERRCNT "Out-Of-space|Error", 
          MAXQUERYLEN "Max Query|Length"
from v$undostat
where to_char(begin_time,'MM/DD/YYYY HH24:MI:SS') between 
     '&start_time'
and 
     '&end_time'
order by  begin_time;

undef start_time
undef end_time
