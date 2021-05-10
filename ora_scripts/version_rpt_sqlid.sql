undef sql_id
-- Generate the report for cursor with sql_id 
-- need to run @version_rpt.sql first
select * from table(version_rpt('&&sql_id')); 
