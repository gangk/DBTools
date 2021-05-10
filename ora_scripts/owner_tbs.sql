COLUMN owner           FORMAT A15                  HEADING "Owner"
COLUMN tablespace_name FORMAT a30                  HEADING "Tablespace Name"
COLUMN segment_type    FORMAT A18                  HEADING "Segment Type"
COLUMN bytes           FORMAT 9,999,999,999,999    HEADING "Size (in Bytes)"
COLUMN seg_count       FORMAT 9,999,999,999        HEADING "Segment Count"

break on report on owner skip 2
compute sum label ""                of seg_count bytes on owner
compute sum label "Grand Total: "   of seg_count bytes on report

SELECT
    owner
  , tablespace_name
  , segment_type
  , sum(bytes)  bytes
  , count(*)    seg_count
FROM
    dba_segments
GROUP BY
    owner
  , tablespace_name
  , segment_type
ORDER BY
    owner
  , tablespace_name
  , segment_type
/
