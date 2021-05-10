col name for a30
col value for 9999999
select
                        sn.name,ss.value
                from
                        v$session s,
                        v$sesstat ss,
                        v$statname sn
                where
                        s.sid = &sid
                        and s.sid = ss.sid
                        and ss.statistic# = sn.statistic#
                        and sn.name in ('table fetch continued row','table fetch by rowid','table scan rows gotten','db block changes',
                        'consistent changes','commit wait/nowait performed');
