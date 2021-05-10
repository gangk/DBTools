@par_job
select /*+ full(tab) parallel(tab 3) */
distinct machine
from db_logons tab
where module in
('FOService'
,'rails_dispatcher.fcgi'
,'GASConfigurationManagerDaemon'
,'SmartAlarms3'
,'AlaskaService'
,'FetchIogMap.pm'
,'getMerchantConfigFromDB.pl'
,'index.cgi'
)
order by machine
;
