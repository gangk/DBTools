col resource_name for a25
col state for a10
col mast for 9999
col grnt for 9999
col cnvt for 9999

select a.resource_name,b.state,a.master_mode mast,a.on_convert_q cnvt,a.on_grant_q grnt, b.request_level,b.grant_level from v$dlm_res a,v$ges_enqueue b
where upper(a.resource_name)=upper(b.resource_name1)
and a.resource_name like '%&res_hex_name%';

