set long 9999999
select text from dba_views where view_name=upper('&view');
undef view
