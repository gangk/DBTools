 select * from (select module,ash_secs,100*ratio_to_report (ash_secs) over () pctio from (SELECT
                                               h.module
                                        ,      SUM(10) ash_secs
                                        ,ROW_NUMBER() OVER ( ORDER BY SUM(10) desc
                                                              ) AS rn
                                        FROM   dba_hist_snapshot x
                                        ,      dba_hist_active_sess_history h
                                        WHERE   x.begin_interval_time between sysdate -5 and sysdate
                                        AND    h.SNAP_id = X.SNAP_id
                                        AND    h.dbid = x.dbid
                                        AND    h.instance_number = x.instance_number
                                        AND    h.module not like 'DBMS%'
                                        and sql_id is not null
                                        GROUP BY h.module
                                        ORDER BY ash_secs desc) )where rownum<=20;
