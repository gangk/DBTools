
      set lines 150 pages 999 hea off feedback off verify off       
      col child_number new_value v_child_number noprint
      
      -- throw error if child not found
      set serveroutput on 
      whenever sqlerror exit
      
      declare
          cur_cnt number := 0;
      begin
          select 1
          into   cur_cnt
          from   v$sql_shared_cursor
          where  sql_id = 'b6rudbvk08f54';
      exception
          when no_data_found then
              dbms_output.put_line('Error: No child cursor found for SQL_ID b6rudbvk08f54');
              dbms_output.put_line('Try "xplan b6rudbvk08f54" and enter SQL Text');
              raise;
          when others then 
              null;
      end;
/
      set serveroutput off
      
      select child_number
      from   
      (   select distinct child_number
          from   v$sql_shared_cursor
          where  sql_id = 'b6rudbvk08f54'
          order  by child_number asc
      )
      where  rownum = 1;
      
      select curs.* 
      from   table(
          dbms_xplan.display_cursor('b6rudbvk08f54', &v_child_number)
      ) curs;
  
