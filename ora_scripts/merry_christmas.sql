set lines 180 pages 1000
select decode(sign(rownum-24),-1,
       replace(replace(lpad(' ', 25 - rownum+trunc(rownum / 8) * 3, ' ') ||
       rpad('^', rownum * 2 - 1 - trunc(rownum / 8) * 6, '^') ||
       rpad(' ', 25 - rownum+trunc(rownum / 8) * 3, ' '),' ^^^',' ^o^'),'^^^ ','^o^ '),
       lpad(' ', 23, ' ') ||
       rpad('^', 3, '^') ||
       rpad(' ', 23, ' ')
       ) "MERRY CHRISTMAS!"
  from dual
connect by rownum <= 26;

