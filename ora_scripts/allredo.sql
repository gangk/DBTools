select SID,a.STATISTIC#,NAME,CLASS,VALUE from v$sesstat a, v$statname b
where a.STATISTIC# = b.STATISTIC# and value > 0 and
a.STATISTIC#=101 order by value
/
