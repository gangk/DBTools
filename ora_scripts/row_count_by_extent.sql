--
-- this script identifies the extent_id's and the rowid ranges for the table
-- use on  a non-partitioned table only
-- use part_row_count_by_extent.sql for a partitioned table
-- the output will contain row count for each extent
--
accept tab_owner	prompt 'Enter Table Owner: ' 
accept tab_name  	prompt 'Enter non-partitioned Table Name : ' 
set verify off

declare
ext_count       number(38) :=0;
tab_row_count   number(38) :=0;
ext_row_cnt     number(38) :=0;

cursor 	 rowid_cur IS
select 	 data_object_id 
	,object_name
	,extent_id 
	,dbms_rowid.rowid_create( 1, data_object_id, relative_fno, min_block_id, 0 ) 		min_rid
      	,dbms_rowid.rowid_create( 1, data_object_id, relative_fno, max_block_id, 10000 ) 	max_rid
from 
(
select   obj.data_object_id      data_object_id
       	,ext.relative_fno        relative_fno
       	,ext.extent_id           extent_id
       	,ext.block_id            min_block_id
       	,ext.block_id+ ext.blocks -1     max_block_id
       	,obj.object_name        object_name
from     dba_objects     	obj
       	,dba_extents     	ext
where    obj.owner		= ext.owner
and      obj.object_name	= ext.segment_name
and	 obj.object_type	='TABLE' 
and 	 obj.owner		= upper('&&tab_owner')
and 	 obj.object_name	= upper('&&tab_name') 
) 
order by data_object_id
	,extent_id
;

begin

EXECUTE IMMEDIATE 'alter session set db_file_multiblock_read_count=128';

FOR rowid_rec in rowid_cur LOOP
--Replace 'select/delete statement' below to whatever operation you want to do.
--Make sure to include the SQL hint as well as rowid filter in your select/update/delete statements.

  	select /*+ rowid(tab) */ count(*) into ext_row_cnt 
  	from &&tab_owner..&&tab_name tab
  	where rowid between rowid_rec.min_rid and rowid_rec.max_rid
	-- condition that will be used to backfill later
	and to_char(CREATION_DATE,'YYYY/MM') = '2012/08'
  	;
  	dbms_output.put_line('Row count for extent_id '||rowid_rec.extent_id||' -- between ' ||rowid_rec.min_rid||' and '||rowid_rec.max_rid||' : '||ext_row_cnt);

  	ext_count := ext_count + 1;
	tab_row_count := tab_row_count + ext_row_cnt;
END LOOP;

dbms_output.put_line('===');
dbms_output.put_line('total extents    => ' ||ext_count);
dbms_output.put_line('total row count  => ' ||tab_row_count);

exception
when others then
null;
end;
/
