select *
  from (
select owner, segment_name, 
       segment_type, block_id
  from dba_extents
 where file_id = 
   ( select file_id
       from dba_data_files
      where tablespace_name=UPPER('&tbs_name' ))
 order by block_id desc
       )
 where rownum <= 5;

