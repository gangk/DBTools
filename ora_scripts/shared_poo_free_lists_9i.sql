REM --------------------------------------------------------------------------------------------------
REM Author: Riyaj Shamsudeen @OraInternals, LLC
REM         www.orainternals.com
REM
REM Thanks to Mark Bobak for making script output more readable
REM Functionality: This script is to show session waits quickly.
REM **************
REM
REM Copyright : @OraInternals www.orainternals.com
REM Note : 1. Keep window 160 columns for better visibility.
REM
REM Exectution type: Execute from sqlplus or any other tool.
REM
REM
REM No implied or explicit warranty
REM
REM Please send me an email to rshamsud@orainternals.com, if you encounter any bugs
REM --------------------------------------------------------------------------------------------------

set lines 140 pages 100
break on ksmchidx on ksmchdur
select
  ksmchidx,ksmchdur,
  case
        when ksmchsiz < 1672 then trunc((ksmchsiz-32)/8)
        when ksmchsiz < 4120 then trunc((ksmchsiz+7928)/48)
        when ksmchsiz < 8216 then 250
        when ksmchsiz < 16408 then 251
        when ksmchsiz < 32792 then 252
        when ksmchsiz < 65560 then 253
        when ksmchsiz >= 65560 then 253
   end bucket,
  sum(ksmchsiz)  free_space,
  count(*)  free_chunks,
  trunc(avg(ksmchsiz))  average_size,
  max(ksmchsiz)  biggest
from
  sys.x$ksmsp
where
  inst_id = userenv('Instance') and
  ksmchcls = 'free'
group by
  case
        when ksmchsiz < 1672 then trunc((ksmchsiz-32)/8)
        when ksmchsiz < 4120 then trunc((ksmchsiz+7928)/48)
        when ksmchsiz < 8216 then 250
        when ksmchsiz < 16408 then 251
        when ksmchsiz < 32792 then 252
        when ksmchsiz < 65560 then 253
        when ksmchsiz >= 65560 then 253
   end ,
  ksmchidx, ksmchdur
order by ksmchidx , ksmchdur
/