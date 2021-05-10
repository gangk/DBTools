select isspecified, count(*) from v$spparameter group by isspecified;

select decode(count(*), 1, 'spfile', 'pfile' )
from v$spparameter
where rownum=1
and isspecified='TRUE'
/