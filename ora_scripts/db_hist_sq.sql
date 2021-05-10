select distinct sql_id,module from dba_hist_active_sess_history where module 
like 'report-high-retail%';

