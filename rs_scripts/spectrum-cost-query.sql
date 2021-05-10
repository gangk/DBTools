CREATE OR REPLACE VIEW public.svl_spectrum_query_cost AS
SELECT
  Q.usename AS username,
  Q.query,
  Q.starttime,
  Q.s3_gb_scanned,
  Q.s3_gb_scanned / 1024::numeric * 2.5 AS spectrum_cost,
  Q.s3_scanned_rows,
  Q.s3query_returned_rows AS s3_returned_rows,
  Q.s3_gb_returned,
  querytxt
FROM (
  SELECT u.usename, u.usesysid, s3s.userid, s3s.query, s3s.starttime,
  (s3s.s3_scanned_bytes::double precision / (1024^3))::numeric(12,3) AS s3_gb_scanned,
  s3s.s3_scanned_rows, s3s.s3query_returned_rows,
  (s3s.s3query_returned_bytes::double precision / (1024^3))::numeric(12,3) AS s3_gb_returned
  FROM svl_s3query_summary s3s
  LEFT JOIN pg_user u ON s3s.userid = u.usesysid
  LEFT JOIN stl_query sq ON sq.query = s3s.query
  WHERE s3s.aborted = 0 AND s3s.userid <> 1 AND s3s.s3_scanned_rows <> 0 ) Q;
