rem
rem   Script:           snap_9_kcbsw.sql
rem   Author:           Jonathan Lewis
rem   Dated:            March 2001
rem   Purpose:          Package to get snapshot start and delta of cache usage
rem
rem   Notes
rem   8i has column 'OTHER WAIT' which needs double quotes.
rem   9i has column 'OTHER_WAIT'
rem
rem   8.1.7.4 has 458 routines listed in x$kcbwh
rem   9.2.0.3 has 675
rem   9.2.0.6 has 677
rem   9.2.0.8 has 694
rem   10.1.0.1 has 773
rem   10.1.0.4 has 782
rem   10.2.0.1 has 802
rem   10.2.0.3 has 806
rem
rem   Some actions seem to change their choice of call as
rem   you go through different versions of Oracle - so
rem   perhaps many of the calls are there for historical
rem   reasons and 'just in case'.
rem
rem   Has to be run by SYS to create the package
rem   According to a note I found in Metalink on RAC:
rem         WHY2 is 'waits'
rem         OTHER_WAITS is 'caused waits'
rem   I take this to mean that both columns should sum
rem   to the same value, but one shows when a function
rem   had to wait, the other shows when a function was
rem   responsible for making another function wait.
rem
rem   Usage:
rem         set serveroutput on size 1000000 format wrapped
rem         set linesize 120
rem         set trimspool on
rem         execute snap_kcbsw.start_snap
rem         -- do something
rem         execute snap_kcbsw.end_snap
rem
rem   Calls seem to follow a naming convention based on the first
rem   two or three letters, for example:
rem         ktu         undo segments
rem         kd          data layer
rem         kdi         data layer - indexes
rem         kts         Space management
rem         kte         Extent management
rem
rem   A few guesses of details:
rem         ktuwh01: ktugus         Undo segment header to start transaction  Get Undo Segment ??
rem         ktuwh03: ktugnb         Undo segment header to Get Next undo Block
rem         ktuwh02: ktugus         Get Undo Segment header for commit
rem         ktuwh20: ktuabt         Updating undo segment headers on rollback (ABorT)
rem         ktuwh23: ktubko         Reading rollback blocks to apply undo records
rem         ktuwh24: ktubko         Reading rollback blocks to apply undo records
rem
rem         kdowh00: kdoiur         Applying rollback records to data blocks ??
rem         kduwh01: kdusru         Single row-piece update
rem         kddwh01: kdddel         Delete row
rem
 
create or replace package snap_kcbsw as
      procedure start_snap;
      procedure end_snap(i_limit in number default 0);
end;
/
 
create or replace package body snap_kcbsw as
 
      cursor c1 is
            select
                  indx,
                  why0,
                  why1,
                  why2,
--                "OTHER WAIT" other_wait       -- v8
                  other_wait              -- v9
            from
                  x$kcbsw
            ;
 
      type w_type1 is table of c1%rowtype index by binary_integer;
      w_list1           w_type1;
      empty_list        w_type1;
 
      w_sum1      c1%rowtype;
      w_count     number(6);
 
      cursor c2(i_task number) is
            select
                  kcbwhdes
            from x$kcbwh
            where
                  indx = i_task
            ;
 
      r2    c2%rowtype;
 
      m_start_time      date;
      m_start_flag      char(1);
      m_end_time        date;
 
procedure start_snap is
begin
 
      m_start_time := sysdate;
      m_start_flag := 'U';
      w_list1 := empty_list;
 
      for r in c1 loop
            w_list1(r.indx).why0 := r.why0;
            w_list1(r.indx).why1 := r.why1;
            w_list1(r.indx).why2 := r.why2;
            w_list1(r.indx).other_wait := r.other_wait;
      end loop;
 
end start_snap;
 
 
procedure end_snap(i_limit in number default 0) is
begin
 
      m_end_time := sysdate;
 
      dbms_output.put_line('---------------------------------');
      dbms_output.put_line('Buffer Cache - ' ||
                        to_char(m_end_time,'dd-Mon hh24:mi:ss')
      );
 
      if m_start_flag = 'U' then
            dbms_output.put_line('Interval:-  '  ||
                        trunc(86400 * (m_end_time - m_start_time)) ||
                        ' seconds'
            );
      else
            dbms_output.put_line('Since Startup:- ' ||
                        to_char(m_start_time,'dd-Mon hh24:mi:ss')
            );
      end if;
 
      if (i_limit != 0) then
            dbms_output.put_line('Lower limit:-  '  || i_limit);
      end if;
 
      dbms_output.put_line('---------------------------------');
 
 
      dbms_output.put_line(
            lpad('Why0',14) ||
            lpad('Why1',14) ||
            lpad('Why2',14) ||
            lpad('Other Wait',14)
      );
 
      dbms_output.put_line(
            lpad('----',14) ||
            lpad('----',14) ||
            lpad('----',14) ||
            lpad('----------',14)
      );
 
      w_sum1.why0 := 0;
      w_sum1.why1 := 0;
      w_sum1.why2 := 0;
      w_sum1.other_wait := 0;
      w_count := 0;
 
      for r in c1 loop
            if (not w_list1.exists(r.indx)) then
                  w_list1(r.indx).why0 := 0;
                  w_list1(r.indx).why1 := 0;
                  w_list1(r.indx).why2 := 0;
                  w_list1(r.indx).other_wait := 0;
            end if;
 
            if (
                     r.why0 > w_list1(r.indx).why0 + i_limit
                  or r.why1 > w_list1(r.indx).why1 + i_limit
                  or r.why2 > w_list1(r.indx).why2 + i_limit
                  or r.other_wait > w_list1(r.indx).other_wait + i_limit
            ) then
 
                  dbms_output.put(to_char(
                        r.why0 - w_list1(r.indx).why0,
                              '9,999,999,990')
                  );
                  dbms_output.put(to_char(
                        r.why1 - w_list1(r.indx).why1,
                              '9,999,999,990')
                  );
                  dbms_output.put(to_char(
                        r.why2 - w_list1(r.indx).why2,
                              '9,999,999,990')
                  );
                  dbms_output.put(to_char(
                        r.other_wait - w_list1(r.indx).other_wait,
                              '9,999,999,990')
                  );
 
                  open c2 (r.indx);
                  fetch c2 into r2;
                  close c2;
                  dbms_output.put(' '|| r2.kcbwhdes);
 
                  dbms_output.new_line;
 
                  w_sum1.why0 := w_sum1.why0 + r.why0 - w_list1(r.indx).why0;
                  w_sum1.why1 := w_sum1.why1 + r.why1 - w_list1(r.indx).why1;
                  w_sum1.why2 := w_sum1.why2 + r.why2 - w_list1(r.indx).why2;
                  w_sum1.other_wait := w_sum1.other_wait + r.other_wait - w_list1(r.indx).other_wait;
                  w_count := w_count + 1;
 
            end if;
 
      end loop;
 
      dbms_output.put_line(
            lpad('----',14) ||
            lpad('----',14) ||
            lpad('----',14) ||
            lpad('----------',14)
      );
 
      dbms_output.put(to_char(w_sum1.why0,'9,999,999,990'));
      dbms_output.put(to_char(w_sum1.why1,'9,999,999,990'));
      dbms_output.put(to_char(w_sum1.why2,'9,999,999,990'));
      dbms_output.put(to_char(w_sum1.other_wait,'9,999,999,990'));
      dbms_output.put(' Total: ' || w_count || ' rows');
      dbms_output.new_line;
 
end end_snap;
 
begin
      select
            startup_time, 'S'
      into
            m_start_time, m_start_flag
      from
            v$instance
      ;
 
end snap_kcbsw;
/
 
 
drop public synonym snap_kcbsw;
create public synonym snap_kcbsw for snap_kcbsw;
grant execute on snap_kcbsw to public;