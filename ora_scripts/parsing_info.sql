select a.value total_parses,
  b.value hard_parses,
  a.value - b.value soft_parses,
  round((b.value/a.value)*100,1) hard_parse_percentage
  from v$sysstat a, v$sysstat b
  where a.name = 'parse count (total)'
  and   b.name = 'parse count (hard)';
