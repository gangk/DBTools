-- Simulate / calculate clustering factor
set verify off

set termout off

column ora10 new_value if_v10 noprint
column oralower10 new_value if_lower_v10 noprint

-- Determine version for regular expression support
select
decode(substr(banner, instr(banner, 'Release ') + 8, 1), '1', '', '--') as ora10
from
v$version
where
rownum = 1;

select
decode('&if_v10', '--', '', '--') as oralower10
from
dual;

set termout on

accept table_name prompt 'Enter table name: '

define sample_pct = 100

accept sample_pct number default &sample_pct prompt 'Enter sample percent (default &sample_pct): '

define p_degree = DEFAULT

accept p_degree default &p_degree prompt 'Enter parallel degree (default &p_degree): '

define history = 1

accept history number default &history prompt 'Enter number of blocks to remember (default &history): '

-- ideally comma separated without spaces surrounding the comma
accept col_list prompt 'Enter comma separated index column list: '

set termout off

column define_sample_block new_value sample_block noprint

select
case
when &sample_pct < 100
then 'sample block (&sample_pct)'
else ''
end as define_sample_block
from
dual;

column col_list_where_expr new_value col_list_where noprint

-- Try to get clever with the WHERE clause derived from the index expression
select
replace(
&if_v10 regexp_replace('&col_list', '( asc| desc)?( nulls (last|first))?', '')
&if_lower_v10 replace(replace(replace(replace(replace('&col_list', ' asc', ''), ' desc', ''), ' nulls', ''), ' last', ''), ' first', '')
, ','
, ' is not null or '
) || ' is not null' as col_list_where_expr
from
dual;

column p_degree_hint_expr new_value p_degree_hint noprint

select
case
when '&p_degree' != 'DEFAULT'
then 'parallel (t &p_degree)'
else ''
end as p_degree_hint_expr
from
dual;

-- set echo on verify on
set termout on

select
sys_op_countchg(substrb(row_id,1,15), &history)
* (100 / &sample_pct) as clustering_factor
, count(*)
* (100 / &sample_pct) as cnt
, count(distinct substrb(row_id,1,15))
* (100 / &sample_pct) as blocks
from
(
select /*+ no_merge no_eliminate_oby &p_degree_hint */
rowid as row_id
--, t.*
from
&table_name &sample_block t
where
&col_list_where
order by
&col_list
, rowid
);