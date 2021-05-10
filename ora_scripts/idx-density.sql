REM -----------------------------------------------------
REM $Id: idx-density.sql,v 1.1 2002/03/14 19:59:51 hien Exp $
REM Author      : Murray Ed
REM #DESC       : Check the density of an index
REM Usage       : p_index_name - index name
REM               p_owner - index owner
REM Description : Check the density of an index
REM -----------------------------------------------------
undefine p_index_name
undefine p_owner

accept p_index_name prompt 'Enter index name: '
accept p_owner  prompt 'Enter index owner: '
DEFINE BLOCK_SIZE=8192;

select /*+ ordered */
  u.name, o.name,100 * i.rowcnt * (sum(h.avgcln) + 11) / (i.leafcnt * (&BLOCK_SIZE - 66 - i.initrans * 24)) 
from
  sys.ind$  i,
  sys.icol$  ic,
  sys.hist_head$  h,
  sys.obj$  o,
  sys.user$  u
where
  i.leafcnt > 1 and
  i.type# in (1,4,6) and                -- exclude special types
  ic.obj# = i.obj# and
  h.obj# = i.bo# and
  h.intcol# = ic.intcol# and
  o.obj# = i.obj# and
  o.owner# != 0 and
  u.user# = o.owner#
  and u.name = UPPER('&p_owner')
  and o.name like UPPER('&p_index_name%')
group by
  u.name,
  o.name,
  i.rowcnt,
  i.leafcnt,
  i.initrans,
  i.pctfree$;

undefine p_index_name
undefine p_owner