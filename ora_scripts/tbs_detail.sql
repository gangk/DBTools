select tablespace_name,block_size,contents,extent_management,segment_space_management from dba_tablespaces;

select tablespace_name,count(*) NUM_OBJECTS,sum(bytes/1024/1024)MB, sum(blocks),sum(extents) from dba_segments group by rollup (tablespace_name);

