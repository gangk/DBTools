column kghluops heading "PINS AND|RELEASES"
column kghlunfu heading "ORA-4031|ERRORS"
column kghlunfs heading "LAST ERROR|SIZE"
column kghlushrpool heading "SUBPOOL"  

select
kghlushrpool,
kghlurcr,
kghlutrn,
kghlufsh,
kghluops,
kghlunfu,
kghlunfs
from
sys.x$kghlu
where
inst_id = userenv('Instance') 
/