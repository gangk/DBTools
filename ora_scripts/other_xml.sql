select v.sql_id,x.outline_hint from v$sql_plan v , xmltable('/other_xml/outline_data/hint' passing xmltype(v.other_xml) columns outline_hint varchar2(80) path '.' ) x where v.other_xml is not null;
