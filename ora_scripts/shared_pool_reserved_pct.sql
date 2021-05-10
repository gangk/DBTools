 col Parameter for a30
 col "Session Value" for a15
 col "Instance Value" for a15


select a.ksppinm "Parameter",
 b.ksppstvl "Session Value",
 c.ksppstvl "Instance Value"
 from sys.x$ksppi a, sys.x$ksppcv b, sys.x$ksppsv c
 where a.indx = b.indx and a.indx = c.indx
 and a.ksppinm = '_shared_pool_reserved_pct'; 