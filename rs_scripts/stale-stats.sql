SELECT schema || '.' || "table" AS "table", stats_off FROM svv_table_info WHERE stats_off > 5 ORDER BY 2;
