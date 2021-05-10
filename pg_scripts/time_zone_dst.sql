select a.name,a.abbrev,a.utc_offset,a.is_dst from pg_timezone_names a,pg_timezone_abbrevs b where a.abbrev=b.abbrev and a.utc_offset=b.utc_offset and a.name='Europe/London';
