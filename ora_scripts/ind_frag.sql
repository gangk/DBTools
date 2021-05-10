set term off
set feedback off

drop table sql_text;

create table sql_text (
line_id  number,
sql_text varchar2(500));

drop table index_stats_ALL;

create table index_stats_ALL as
select * 
from   index_stats
where  1 = 2;

set term on
prompt creating validation scripts ...
set term off

declare
    cursor ind_cur IS
       select owner
       ,      index_name
       from   dba_indexes
       order by owner
       ,        index_name;


    l_sql_text         varchar2(500);
    l_curr_line_id     number(38) := NULL;

begin
    declare
           function write_out (
           p_line_id     IN  NUMBER,
           p_sql_text    IN  VARCHAR2 ) return NUMBER
           is
           l_line_id   number(38) := null;
           begin
             insert into sql_text
             values(p_line_id,p_sql_text);
             commit;
             l_line_id := p_line_id + 1;
             return(l_line_id);
           end write_out;
    begin
           l_curr_line_id := write_out(1,'-- start');
           for ind_rec in ind_cur LOOP
                --
                -- Firs get the prompts
                --
                l_sql_text := 'prompt ... processing index '||
                               ind_rec.owner||
                               '.'||
                               ind_rec.index_name||
                               ' ...';
                l_curr_line_id := write_out(l_curr_line_id,l_sql_text);
                --
                -- Second get the analyze commands
                --
                l_sql_text := 'analyze index '||
                               ind_rec.owner||
                               '.'||
                               ind_rec.index_name||
                               ' validate structure;';
                l_curr_line_id := write_out(l_curr_line_id,l_sql_text);
                --
                -- Third get the current statistics before it gets overwritten
                --
                l_sql_text := 'insert into index_stats_all select * from index_stats;';
                l_curr_line_id := write_out(l_curr_line_id,l_sql_text);
           end loop;
           --
           -- commit the whole thing
           --
           l_curr_line_id := write_out(l_curr_line_id,'commit;');
    end;
end;
/


set pages 0
col sql_text format a132

select sql_text from sql_text
order by line_id

spool ind.tmp
/
spool off

set term on
prompt running validation scripts ...

@ind.tmp

prompt ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
prompt Done !
prompt

set pages 90

select    name                                           "Index name"
,         ( del_lf_rows_len/decode(nvl(lf_rows_len,1),
                                 1,1,
                                 0,1,
                                   lf_rows_len) )*100    "% of Deleted Rows"
from    index_stats_all
where   ( del_lf_rows_len/decode(nvl(lf_rows_len,1),
                                 1,1,
                                 0,1,
                                   lf_rows_len) )*100 >= &pct_of_del_rows_USE_20

/