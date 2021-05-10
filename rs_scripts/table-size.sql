SELECT "table" tablename, SIZE size_in_mb FROM svv_table_info ti JOIN   (SELECT tbl,
    MIN(c) min_blocks_per_slice,
    MAX(c) max_blocks_per_slice,
    COUNT(DISTINCT slice) dist_slice    FROM
(SELECT b.tbl,
        b.slice,
        COUNT(*) AS c
FROM STV_BLOCKLIST b
GROUP BY b.tbl,
        b.slice)    WHERE tbl IN
(SELECT table_id
    FROM svv_table_info)    GROUP BY tbl) iq ON iq.tbl = ti.table_id ORDER BY SCHEMA,
    "Table";
