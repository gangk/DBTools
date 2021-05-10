select owner,table_name,to_char(LAST_ANALYZED,'DD-MM-YY HH24:MI:SS')LAST_ANALYZED_ON FROM DBA_TABLES WHERE OWNER LIKE UPPER('%&ONWER_name%') order by last_analyzed_on desc;
