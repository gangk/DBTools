rem
rem Retrieve statistics information for a table
rem Displays table, column, and index stats
rem Also includes partition stats (if partitioned), histograms (if collected)
rem

set echo off feed off

set serveroutput on for wra

alter session set nls_date_format = 'mm/dd/yyyy hh24:mi:ss';

set termout on
accept p_owner prompt 'Enter the owner name: '
accept p_table prompt 'Enter the table name: '

set termout on lines 200

declare
  v_query varchar2(4000)  ;
  v_owner varchar2(30) := upper('&p_owner');
  v_table varchar2(30) := upper('&p_table');
  v_max_colname   number ;
  v_max_ndv       number ;
  v_max_nulls     number ;
  v_max_bkts      number ;
  v_max_smpl      number ;
  v_max_endnum    number ;
  v_max_endval    number ;
  v_ct            number ;
  prev_col        varchar2(30) ;

	cn     number;
	cv     varchar2(70);
	cd     date;
	cnv    nvarchar2(70);
	cr     rowid;
	cc     char(70);
	
	cn1     number;
	cv1     varchar2(32);
	cd1     date;
	cnv1    nvarchar2(32);
	cr1     rowid;
	cc1     char(32);

	cn2     number;
	cv2     varchar2(32);
	cd2     date;
	cnv2    nvarchar2(32);
	cr2     rowid;
	cc2     char(32);
   
  cursor col_stats is
  select a.column_name,
         a.last_analyzed,
         a.nullable,
         a.num_distinct, a.density, a.num_nulls,
         a.histogram, a.num_buckets, a.avg_col_len, a.sample_size,
         a.low_value, a.high_value, a.data_type
    from all_tab_cols a
   where a.owner = v_owner
     and a.table_name = v_table ;

	cursor hist_stats (col_nm all_tab_histograms.column_name%TYPE) is
	select rownum bucket, pct_total||'%' hist_line
	-- lpad('+', pct_total, '+')||'('||pct_total||'%)' hist_line
	from
	(
	select endpoint_number curr_ep, 
	       lag(endpoint_number,1,0) over(order by endpoint_number) prev_ep, 
	       (endpoint_number - lag(endpoint_number,1,0) over (order by endpoint_number)) num_in_bkt,
	       max(endpoint_number) over () last_ep,
	       round((endpoint_number - lag(endpoint_number,1,0) over (order by endpoint_number)) / max(endpoint_number) over (), 2) * 100 pct_total,
	       row_number() over (order by endpoint_number) rn
	  from all_tab_histograms
	 where owner = v_owner
	   and table_name = v_table
	   and column_name = col_nm
	   and EXISTS (select null from all_tab_cols 
			where column_name = col_nm and table_name = v_table and owner = v_owner and num_buckets > 1)
	)
	where pct_total > 5
	;

    v_numrows   number;
    v_numblks   number;
    v_avgrlen   number ;
    v_stattab   varchar2(30) := null ;

    v_numirows  number;
    v_numlblks  number;
    v_numdist   number;
    v_avglblk   number;
    v_avgdblk   number;
    v_clstfct   number;
    v_indlevel  number;

    cursor tabs is
    select *
    from all_tables
    where table_name = UPPER(v_table)
    and owner = UPPER(v_owner) ;

    cursor parts is
    select *
    from all_tab_partitions
    where table_name = UPPER(v_table)
    and table_owner = UPPER(v_owner) ;

    cursor cols is
    select *
    from all_tab_cols
    where table_name = UPPER(v_table)
    and owner = UPPER(v_owner) ;

    cursor idxs is
    select index_name, index_type, last_analyzed, degree, partitioned, visibility
    from all_indexes
    where table_name = UPPER(v_table)
    and owner = UPPER(v_owner) ;

    v_minval    VARCHAR2(50);
    v_maxval    VARCHAR2(50);
    v_distcnt   NUMBER ;
    v_density   NUMBER ;
    v_nullcnt   NUMBER ;
    v_avgclen   NUMBER ;
    v_statrec   dbms_stats.StatRec;



begin
    dbms_output.put_line('===================================================================================================================================');
    dbms_output.put_line('  TABLE STATISTICS');
    dbms_output.put_line('===================================================================================================================================');


      for tabinfo in tabs loop
        dbms_output.put_line ('Owner         : ' || lower(tabinfo.owner)) ;
        dbms_output.put_line ('Table name    : ' || lower(tabinfo.table_name)) ;
        dbms_output.put_line ('Tablespace    : ' || lower(tabinfo.tablespace_name)) ;
        dbms_output.put_line ('Cluster name  : ' || lower(tabinfo.cluster_name)) ;
        dbms_output.put_line ('Partitioned   : ' || lower(tabinfo.partitioned)) ;
        dbms_output.put_line ('Last analyzed : ' || tabinfo.last_analyzed) ;
        dbms_output.put_line ('Sample size   : ' || tabinfo.sample_size) ;
        dbms_output.put_line ('Degree        : ' || to_number(tabinfo.degree)) ;
        dbms_output.put_line ('IOT Type      : ' || lower(tabinfo.iot_type)) ;
        dbms_output.put_line ('IOT name      : ' || lower(tabinfo.iot_name)) ;
        dbms_output.put_line ('# Rows        : ' || tabinfo.num_rows) ;
        dbms_output.put_line ('# Blocks      : ' || tabinfo.blocks ) ;
        dbms_output.put_line ('Empty Blocks  : ' || tabinfo.empty_blocks) ;
        dbms_output.put_line ('Avg Space     : ' || tabinfo.avg_space) ;
        dbms_output.put_line ('Avg Row Length: ' || tabinfo.avg_row_len ) ;
        dbms_output.put_line ('Monitoring?   : ' || lower(tabinfo.monitoring )) ;
        dbms_output.put_line ('Status        : ' || lower(tabinfo.status )) ;
        
        v_numblks := tabinfo.blocks ;
        v_numrows := tabinfo.num_rows ;
      end loop;

  v_ct := 0 ;

  select count(1)
    into v_ct
    from all_tab_partitions
   where table_owner = UPPER(v_owner)
     and table_name = UPPER(v_table);

  if v_ct > 0 then
      dbms_output.put_line('');
      dbms_output.put_line('===================================================================================================================================');
      dbms_output.put_line('  PARTITION INFORMATION');
      dbms_output.put_line('===================================================================================================================================');

      for partinfo in parts loop
        dbms_output.put_line ('Owner         : ' || lower(partinfo.table_owner)) ;
        dbms_output.put_line ('Table name    : ' || lower(partinfo.table_name)) ;
        dbms_output.put_line ('Partition Name: ' || lower(partinfo.partition_name)) ;
        dbms_output.put_line ('Tablespace    : ' || lower(partinfo.tablespace_name)) ;
        dbms_output.put_line ('Composite     : ' || lower(partinfo.composite )) ;
        dbms_output.put_line ('High Value    : ' || substr(partinfo.high_value,1,80)) ;
        dbms_output.put_line ('Last analyzed : ' || partinfo.last_analyzed) ;
        dbms_output.put_line ('# Rows        : ' || partinfo.num_rows) ;
        dbms_output.put_line ('# Blocks      : ' || partinfo.blocks ) ;
        dbms_output.put_line ('Empty Blocks  : ' || partinfo.empty_blocks) ;
        dbms_output.put_line ('Avg Space     : ' || partinfo.avg_space) ;
        dbms_output.put_line ('Avg Row Length: ' || partinfo.avg_row_len ) ;
        dbms_output.put_line ('-----------------------------------------');

      end loop;

  end if ;

  select max(length(column_name)) + 1, max(length(num_distinct)) + 3,
         max(length(num_nulls)) + 1, max(length(num_buckets)) + 1,
         max(length(sample_size)) + 1
    into v_max_colname, v_max_ndv, v_max_nulls, v_max_bkts, v_max_smpl
    from all_tab_cols
   where owner = v_owner
     and table_name = v_table ;

  if v_max_nulls < 8 then
     v_max_nulls := 8 ;
  end if ;

  if v_max_bkts < 10 then
     v_max_bkts := 10 ;
  end if ;

  if v_max_smpl < 7 then
     v_max_smpl := 7;
  end if;


  dbms_output.put_line('');
  dbms_output.put_line('===================================================================================================================================');
  dbms_output.put_line('  COLUMN STATISTICS');
  dbms_output.put_line('===================================================================================================================================');
  dbms_output.put_line(' ' || rpad('Name',v_max_colname) || ' Analyzed             Null? ' ||
        rpad(' NDV',v_max_ndv) || '  ' || rpad(' Density',10) ||
        rpad('# Nulls',v_max_nulls) || '  ' || rpad('# Buckets',v_max_bkts) || '  ' ||
        rpad('Sample',v_max_smpl) || '  AvgLen  Lo-Hi Values');
  dbms_output.put_line('===================================================================================================================================');


  for v_rec in col_stats loop
      if v_rec.last_analyzed is not null then
          if v_rec.data_type = 'NUMBER' then 
             dbms_stats.convert_raw_value(v_rec.low_value, cn1);
             dbms_stats.convert_raw_value(v_rec.high_value, cn2);
	     cv := cn1 || ' | ' || cn2;
	   elsif (v_rec.data_type = 'VARCHAR2') then
             dbms_stats.convert_raw_value(v_rec.low_value, cv1);
             dbms_stats.convert_raw_value(v_rec.high_value, cv2);
	     cv := substr(trim(cv1),1,30) || ' | ' || substr(trim(cv2),1,30);
	   elsif (v_rec.data_type = 'DATE') then
             dbms_stats.convert_raw_value(v_rec.low_value, cd1);
             dbms_stats.convert_raw_value(v_rec.high_value, cd2);
	     cv := to_char(cd1,'mm/dd/yyyy hh24:mi:ss') || ' | ' || to_char(cd2,'mm/dd/yyyy hh24:mi:ss');
	   elsif (v_rec.data_type = 'NVARCHAR2') then
             dbms_stats.convert_raw_value(v_rec.low_value, cnv1);
             dbms_stats.convert_raw_value(v_rec.high_value, cnv2);
	     cv := substr(trim(to_char(cnv1)),1,30) || ' | ' || substr(trim(to_char(cnv2)),1,30);
	   elsif (v_rec.data_type = 'ROWID') then
             dbms_stats.convert_raw_value(v_rec.low_value, cr1);
             dbms_stats.convert_raw_value(v_rec.high_value, cr2);
	     cv := substr(trim(to_char(cr1)),1,30) || ' | ' || substr(trim(to_char(cr2)),1,30);
	   elsif (v_rec.data_type = 'CHAR') then
             dbms_stats.convert_raw_value(v_rec.low_value, cc1);
             dbms_stats.convert_raw_value(v_rec.high_value, cc2);
	     cv := substr(trim(cc1),1,30) || ' | ' || substr(trim(cc2),1,30);
	   else
	     cv:= 'UNKNOWN DATATYPE';
	   end if;
          
          dbms_output.put_line(rpad(lower(v_rec.column_name),v_max_colname) || '  ' ||
          v_rec.last_analyzed || '  ' ||
          rpad(v_rec.nullable,5) || '  ' ||
          rpad(v_rec.num_distinct,v_max_ndv) ||
          to_char(v_rec.density,'9.999999') || '  ' ||
          rpad(v_rec.num_nulls,v_max_nulls) || '  ' ||
          rpad(v_rec.num_buckets,v_max_bkts) || '  ' ||
          rpad(v_rec.sample_size,v_max_smpl) || '  ' ||
          rpad(v_rec.avg_col_len,9) || '  ' || rpad(cv,70));
      else
          dbms_output.put_line(rpad(lower(v_rec.column_name),v_max_colname));
      end if;
  end loop ;


  select count(1)
    into v_ct
    from all_tab_histograms b
   where b.owner = v_owner
     and b.table_name = v_table
     and (exists (select 1 from all_tab_columns
                   where num_buckets > 1
                     and owner = b.owner
                     and table_name = b.table_name
                     and column_name = b.column_name)
          or
          exists (select 1 from all_tab_histograms
                   where endpoint_number > 1
                     and owner = b.owner
                     and table_name = b.table_name
                     and column_name = b.column_name)
         );

  if v_ct > 0 then
      dbms_output.put_line('');  
      dbms_output.put_line('===================================================================================================================================');
      dbms_output.put_line('  HISTOGRAM STATISTICS');
      dbms_output.put_line('===================================================================================================================================');
      dbms_output.put_line('Note: Only columns with buckets containing > 5% of total values are shown.');
      dbms_output.put_line('');
      
      v_ct := 0 ;
      for v_rec in cols loop 		
          if v_rec.num_buckets > 1 then 
	     for v_hist_rec in hist_stats (v_rec.column_name) loop
          
		  if v_ct = 0 then
		     v_ct := 1 ;
		     prev_col := v_rec.column_name ;
		     dbms_output.put_line(v_rec.column_name||' (' || v_rec.num_buckets || ' buckets)');
		  elsif prev_col <> v_rec.column_name then
		     dbms_output.put_line('');
		     dbms_output.put_line(v_rec.column_name||' (' || v_rec.num_buckets || ' buckets)');
		     prev_col := v_rec.column_name ;
		  end if ;

		  dbms_output.put_line(v_hist_rec.bucket||' '||v_hist_rec.hist_line);
	     end loop;
	  end if;
      end loop ;
      dbms_output.put_line('');
  end if ;

  v_ct := 0;

  select count(1)
    into v_ct
    from all_indexes a
   where a.table_owner = v_owner
     and a.table_name = v_table;

  if v_ct > 0 then
      dbms_output.put_line('');
      dbms_output.put_line('===================================================================================================================================');
      dbms_output.put_line('  INDEX INFORMATION');
      dbms_output.put_line('===================================================================================================================================');
  end if;
end;
/

set verify off feed off numwidth 15 lines 500 heading on


column INDEX_NAME heading 'Index Name'
column INDEX_TYPE format a8 heading 'Type'
column STATUS format a8 heading 'Status'
column VISIBILITY format a4 heading 'Vis?'
column LAST_ANALYZED heading 'Last Analyzed'
column SAMPLE_SIZE heading 'Sample Size'
column DEGREE format a3 heading 'Deg'
column PARTITIONED format a5 heading 'Part?'
column UNIQUENESS format a5 heading 'Uniq?'
column BLEVEL format 999999 heading 'BLevel'
column LEAF_BLOCKS heading 'Leaf Blks'
column NUM_ROWS heading '# Rows'
column DISTINCT_KEYS heading 'Distinct Keys'
column AVG_LEAF_BLOCKS_PER_KEY heading 'Avg Lf/Blks/Key'
column AVG_DATA_BLOCKS_PER_KEY heading 'Avg Dt/Blks/Key'
column CLUSTERING_FACTOR heading 'Clustering Factor'
	

select INDEX_NAME,  
	BLEVEL, LEAF_BLOCKS, NUM_ROWS, DISTINCT_KEYS,
	AVG_LEAF_BLOCKS_PER_KEY, AVG_DATA_BLOCKS_PER_KEY, CLUSTERING_FACTOR,
	SAMPLE_SIZE, case when uniqueness = 'UNIQUE' then 'YES' else 'NO ' end UNIQUENESS,
	INDEX_TYPE, STATUS, DEGREE,
	PARTITIONED, case when visibility = 'VISIBLE' then 'YES' else 'NO ' end VISIBILITY, 
	LAST_ANALYZED
from all_indexes
where table_owner = UPPER('&p_owner')
and table_name = UPPER('&p_table')
order by index_name ;



column column_name format a30 heading 'Column Name'
column index_name heading 'Index Name'
column column_position format 999999999 heading 'Pos#'
column descend format a5 heading 'Order'
column column_expression format a40 heading 'Expression'

break on index_name skip 1

select lower(b.index_name) index_name, b.column_position, b.descend, lower(b.column_name) column_name,  e.column_expression
from all_ind_columns b, all_ind_expressions e
where b.table_owner = UPPER('&p_owner')
and b.table_name = UPPER('&p_table')
and b.index_name = e.index_name(+)
order by b.index_name, b.column_position, b.column_name
/

undefine p_owner
undefine p_table

clear columns
clear breaks

@henv
