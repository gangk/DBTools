set serveroutput on

DECLARE
        TYPE RefCursor IS REF CURSOR;
       CURSOR mlogs is
       select mowner, master, log, flag from sys.mlog$;
       mcount number;
       tcount number;
       sdate  date;
       cdate  date;
       slog_stmnt  varchar2(2000);
       slog_stmnt1 varchar2(2000);
        pk_stmnt    varchar2(500);
        v_snapname  varchar2(30);
        v_snapsite  varchar2(128);
         v_snapid    number;
         uq_list     varchar2(500);
         v_colname   varchar2(30);
         v_snaptime date;
         slog_cur RefCursor;
         pk_cur RefCursor;
 BEGIN
          slog_stmnt := 'select snapid, r.name snapname, '|| 
        ' nvl(r.snapshot_site, ''not registered'') snapsite, ' || snaptime ' ||               
          'from sys.slog$ s, dba_registered_snapshots r ' ||   
          'where s.snapid=r.snapshot_id(+) ';
          FOR mlog_rec IN mlogs LOOP
          -- Compare the number of blocks pertaining to MLOG$_XXX and those of the
           -- master table. If MLOG$_XXX has more blocks than the master table then
            -- this can cause a performance problem during fast refresh. In that case
           -- MLOG$_XXX should be truncated.
           -- Find the number of blocks that belong to the snapshot log.
               EXECUTE IMMEDIATE
                         'select sum(blocks) from dba_extents where owner=:1 and segment_name=:2'
                 INTO mcount USING mlog_rec.mowner, mlog_rec.log;
          -- Find the number of blocks that belong to the master table.
                           EXECUTE IMMEDIATE
                     'select sum(blocks) from dba_extents where owner=:1 and segment_name=:2'
                       INTO tcount USING mlog_rec.mowner, mlog_rec.master;
            IF mcount>100 AND mcount> tcount THEN
                       dbms_output.put_line( mlog_rec.mowner ||'.'|| mlog_rec.log ||
                   ' is larger than its master which may be an indication of a high water mark problem.' );
          END IF;

-- Find the number of distinct changes in the log that are inserted after the last
-- refresh. If this number is greater than 50% of the cardinality of the table then 
-- -- complete refresh is better than the fast refresh.
 slog_stmnt1 := slog_stmnt || ' and mowner=''' || mlog_rec.mowner ||
'' and master=''' || mlog_rec.master || '''';
-- For each snapshot that uses the log, find whether it is more feasible to do
 -- a complete refresh instead of the fast refresh.
OPEN slog_cur FOR slog_stmnt1;
LOOP
-- find the last refresh time of the snapshot in question
   FETCH slog_cur INTO v_snapid, v_snapname, v_snapsite, v_snaptime;
EXIT WHEN slog_cur%NOTFOUND;
   uq_list := '1';
    -- The column list will be constructed from the PK columns in the log
    -- or M_ROW$$ column or both.
    -- add ROWID to the column list if it is a ROWID log
      IF (MOD(mlog_rec.flag,2) = 1 ) THEN
            uq_list := uq_list || '|| M_ROW$$';
        END IF;
 -- add primary key columns to the column list
           -- if it is a PK log
               IF bitand(mlog_rec.flag,2) = 2 THEN         
            pk_stmnt := 'select column_name '  ||                                       
           'from dba_constraints c, dba_cons_columns cc '   ||                                       
            'where c.constraint_name=cc.constraint_name and '||                
            '      c.table_name     =cc.table_name      and '||                                      
            '      c.owner          =cc.owner           and '||                                       
            '      c.constraint_type=''P''              and '||                                       
            '      c.table_name     =''' || mlog_rec.master  ||                                       
            '''' || ' and c.owner=''' || mlog_rec.mowner || '''';
            OPEN pk_cur FOR pk_stmnt;                           
            LOOP                              
            FETCH pk_cur INTO v_colname;                               
            EXIT WHEN pk_cur%NOTFOUND;                            
            uq_list := uq_list || '||'||v_colname;                        
            END LOOP;                          
            CLOSE pk_cur;        
        END IF;
EXECUTE   IMMEDIATE 'select count( distinct '|| uq_list || ') from ' 
||mlog_rec.mowner || '.' || mlog_rec.log || ' where snaptime$$>:1' INTO mcount
USING v_snaptime;
EXECUTE IMMEDIATE 'select count(*) from ' ||mlog_rec.mowner || '.' || mlog_rec.master
INTO tcount;
IF 
mcount > tcount * 0.5 THEN                           
           IF v_snapsite = 'not registered' then                              
            dbms_output.put_line( 'Complete refresh is better for snapid=' ||                               
            to_char(v_snapid) || ' at site:' || v_snapsite ||                                                   
            ' using the log: ' ||  mlog_rec.mowner ||'.'||                                                   
            mlog_rec.log );                          
            ELSE                               
            dbms_output.put_line( 'Complete refresh is better for ' || v_snapname ||                           
            ' at site:' || v_snapsite || ' using the log: ' ||                  
            mlog_rec.mowner ||'.'|| mlog_rec.log );
            END IF;
            END IF;
END LOOP;
CLOSE slog_cur;   
END LOOP;
END;
/