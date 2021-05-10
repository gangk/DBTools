select count(tmp.cnt) "Table Count", tmp.cnt "Missing Statistics" from (SELECT substring(trim(plannode),34,110) AS plannode ,COUNT(*) as cnt FROM stl_explain WHERE plannode LIKE ‘%missing statistics%’ AND plannode NOT LIKE ‘%redshift_auto_health_check_%’ GROUP BY plannode ORDER BY 2 DESC) tmp group by tmp.cnt;

