SELECT table_schema "DB Name", table_name "Table Name",
        ROUND(SUM(data_length + index_length) / 1024 / 1024, 1) "DB Size in MB"
FROM information_schema.tables
GROUP BY table_schema,table_name order by 3;
