REM ##Notice the Function colunmn. This is a "YES" or "NO" depending on if this is a function based index, or just extended statistics##
column table_owner alias "owner" format a15
column table_name alias  "Table Name" format  a30
column function_index alias  "F Index" format  a8
column Index_name  alias  "Index Name"  format a30
column data_default alias  "Definition"  format a50
set pagesize 1000
select table_owner,
         table_name,
        nvl2(index_name,'YES','NO') function_index,
        index_name,
        data_default
        from
        (
select owner table_owner,table_name,
(select distinct index_name from dba_ind_columns b where a.column_name=b.column_name and a.owner=b.index_owner and a.table_name=b.table_name) index_name
,data_default
-- ,     DBMS_LOB.SUBSTR( to_lob(data_default),100,1)
 from dba_tab_cols a
  where virtual_column='YES' and hidden_column='YES'  and (owner not in ('SYS','WMSYS','XDB','SYSMAN','MDSYS','EXFSYS','PR_MDS') and owner not like 'APEX_%')
  )
order by table_owner,table_name;