select oid::regclass::text relation
from pg_class where relkind = 'r'
except
select distinct inhparent::regclass::text
from pg_inherits
except
select distinct inhrelid::regclass::text
from pg_inherits
;
