SELECT table_schema, substr(table_name,1,25), column_name,data_type,numeric_precision,numeric_scale from information_schema.columns where table_schema='booker' and data_type like 'num%' and numeric_scale=0 order by 2,3;
