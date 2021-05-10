@plusenv

set lin 200 pages 200
col column_name for a45
col object_name for a50
col segment_name for a50
set echo off

accept tab_name         prompt 'Enter Table Name : '
-- Object Info
select owner,object_name,object_type from dba_objects where object_name=upper('&&tab_name');
-- Index Info
select index_name,column_name,column_position from dba_ind_columns where table_name=upper('&&tab_name') order by 1,3;
-- Table Size
select segment_name,bytes/1024/1024 sizeoftable from dba_segments where segment_name=upper('&&tab_name');
-- Index Size
--select segment_name,bytes/1024/1024 sizeofindex from dba_segments where segment_name in (select distinct index_name from dba_indexes where table_name=upper('&&tab_name'));
-- Triggers
select trigger_name from dba_triggers where table_name=upper('&&tab_name');

set echo off

