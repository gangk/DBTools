column trace new_val T
select c.value || '/' || d.instance_name || '_ora_' ||
 a.spid || '.trc' ||
 case when e.value is not null then '_'||e.value end trace
 from v$process a, v$session b, v$parameter c, v$instance d, v$parameter e
 where a.addr = b.paddr
 and b.audsid = userenv('sessionid')
 and c.name = 'user_dump_dest'
 and e.name = 'tracefile_identifier'
 /
 