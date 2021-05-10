REM ------------------------------------------------------------------------------------------------
REM $Id: bloated-idx.sql,v 1.1 2002/04/01 22:34:38 hien Exp $
REM Author     : hien
REM #DESC      : Indexes that might be bloated (> 80% of table size and > 10M)
REM Usage      : Input parameter: none
REM Description: Report column description:
REM              U      = flag indicating whether index is unique
REM              F      = flag indicating whether index is larger than table
REM              Ext    = extent(s)
REM              PI-PF  = pctincrease-pctfree
REM              IT|FL  = initrans|freelists
REM              BL     = Btree index level
REM ------------------------------------------------------------------------------------------------

col towner      format a8               head 'Table|Owner'              trunc
col tname       format a30              head 'Table|Name'
col iowner      format a8               head 'Index|Name'               trunc
col iname       format a30              head 'Index|Name'
col tsize       format 99999.9          head 'Table|Size MB'
col isize       format 99999.9          head 'Index|Size MB'
col initM       format 999.9            head 'Initial|Ext MB'
col nextM       format 999.9            head 'Next|Ext MB'
col ext         format 9999             head 'Ext'
col pipf        format a05              head 'PI-PF'
col itfl        format a03              head 'I-F|T-L'
col bl          format 9                head 'BL'
col pct         format 999              head 'Pct|Of|Tab'
col uniq        format a01              head 'U'

break on towner on tname on tsize on iowner

set line 999
set pagesize 999

select iowner,iname,isize from 
(
SELECT  /*+ RULE */
         st.owner                                       towner
        ,st.segment_name                                tname
        ,round(st.bytes/(1024*1024),2)                  tsize
        ,decode(si.owner,st.owner,null,si.owner)        iowner
        ,decode(i.uniqueness,'UNIQUE','x',' ')          uniq
        ,si.segment_name                                iname
        ,round(si.bytes/(1024*1024),2)                  isize
        ,decode(sign(st.bytes - si.bytes),-1,'x',' ')   F
        ,least(100*round(si.bytes/st.bytes,2),999)      pct
        ,round(si.initial_extent/(1024*1024),2)         initM
        ,round(si.next_extent/(1024*1024),2)            nextM
        ,si.extents                                     ext
        ,lpad(i.pct_increase,2,' ')||'-'||lpad(i.pct_free,2,' ')        pipf
        ,lpad(i.ini_trans,1,' ')||'-'||lpad(i.freelists,1,' ')          itfl
        ,i.blevel                                       bl
FROM     dba_indexes    i
        ,dba_segments   si
        ,dba_segments   st
WHERE    st.segment_name        = i.table_name
AND      st.owner               = i.table_owner
AND      si.segment_name        = i.index_name
AND      si.owner               = i.owner
AND      st.segment_type        = 'TABLE'
AND      si.segment_type        = 'INDEX'
AND      sign(st.bytes * .5 - si.bytes) = -1
  AND    si.bytes/(1024*1024)   > 10
  AND    si.extents             > 1
AND      st.owner not in ('SYS','ADMIN')
AND      round(si.bytes/(1024*1024),2) < 2500
ORDER BY pct desc,
        st.bytes desc
        ,st.segment_name
        ,si.segment_name
)
order by isize;
;

col command format a100
col command2 format a100
set linesize 90
select  'alter index '||iowner||'.'||iname||' shrink space compact;'
from
(
SELECT  /*+ RULE */
         st.owner                                       towner
        ,st.segment_name                                tname
        ,round(st.bytes/(1024*1024),2)                  tsize
        ,si.owner        iowner
        ,decode(i.uniqueness,'UNIQUE','x',' ')          uniq
        ,si.segment_name                                iname
        ,round(si.bytes/(1024*1024),2)                  isize
        ,decode(sign(st.bytes - si.bytes),-1,'x',' ')   F
        ,least(100*round(si.bytes/st.bytes,2),999)      pct
        ,round(si.initial_extent/(1024*1024),2)         initM
        ,round(si.next_extent/(1024*1024),2)            nextM
        ,si.extents                                     ext
        ,lpad(i.pct_increase,2,' ')||'-'||lpad(i.pct_free,2,' ')        pipf
        ,lpad(i.ini_trans,1,' ')||'-'||lpad(i.freelists,1,' ')          itfl
        ,i.blevel                                       bl
FROM     dba_indexes    i
        ,dba_segments   si
        ,dba_segments   st
WHERE    st.segment_name        = i.table_name
AND      st.owner               = i.table_owner
AND      si.segment_name        = i.index_name
AND      si.owner               = i.owner
AND      st.segment_type        = 'TABLE'
AND      si.segment_type        = 'INDEX'
AND      sign(st.bytes * .5 - si.bytes) = -1
  AND    si.bytes/(1024*1024)   > 10
  AND    si.extents             > 1
AND      st.owner not in ('SYS','ADMIN')
AND      round(si.bytes/(1024*1024),2) < 2500
ORDER BY pct desc,
        st.bytes desc
        ,st.segment_name
        ,si.segment_name
)
order by isize;
