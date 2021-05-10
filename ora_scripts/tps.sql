select round(sum(s.value / (86400 * (SYSDATE - startup_time))),3) "TPS" from v$sysstat s ,v$instance i where s.NAME in ('user commits','transaction rollbacks');
