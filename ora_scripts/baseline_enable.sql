declare
                v_num number:=0;
                v_plan_name  dba_sql_plan_baselines.plan_name%type;
                v_sql_handle  dba_sql_plan_baselines.sql_handle%type;
                v_creator dba_sql_plan_baselines.creator%type;
                v_enabled  dba_sql_plan_baselines.enabled%type;
                v_accepted  dba_sql_plan_baselines.accepted%type;
                v_fixed  dba_sql_plan_baselines.fixed%type;
                i number :=0 ;
begin
    dbms_output.put_line('Generating the sql plan baseline for from cursor cache where it does not exist');
                for c1plan in (select distinct sql_id, plan_hash_value, module from v$sql a1 where
                                                sql_id in
                                                                (select  sql_id
                                                                from    (select distinct a.sql_id, a.plan_hash_value
                from    v$sql a
                where    a.sql_plan_baseline is null
                                                                and module not in ('DBMS_SCHEDULER','MMON_SLAVE','SQL*Plus','SQL Developer','sleepy-tuba-collect-tables','DBServicesMetadataCollection',
                                                                'sleepy-tuba-account-manager','dbaccess.cgi','agent-manager.pl','fcdbwsd.py')
                                                                and module not like 'sqlplus%'
                                                                and module not like 'rman%'
                                                                and module not like 'dgmgrl%'
                                                                )
                                                group by sql_id
                                                having count(*)>=1)
                                                and not exists (select sql_id from v$sql b where a1.sql_id=b.sql_id and b.sql_plan_baseline is not null )
                                                and command_type=3 and rownum < =5 )
                loop
                    begin
                                i:=i+1;
                    dbms_output.put_line(chr(10));
                                v_num  := dbms_spm.load_plans_from_cursor_cache(sql_id => c1plan.sql_id,plan_hash_value => c1plan.plan_hash_value);
                                                if (v_num <> 1) then
                                                dbms_output.put_line(chr(10)||'***ERROR***: Problem in loading plan from cursor cache into SQL plan baseline.'||v_num||' number of plans have been loaded.');
            dbms_output.put_line(chr(10)|| SQLCODE || '    '||substr(SQLERRM, 1, 200));                      
                                                end if;
                                                select rpad(sql_handle,30,' ') c0, rpad(plan_name,30,' ') c1, creator, ENABLED, ACCEPTED, FIXED   
             into v_sql_handle, v_plan_name, v_creator,v_enabled, v_accepted,v_fixed                                        
                                                  from sys.dba_sql_plan_baselines where SIGNATURE IN (SELECT exact_matching_signature FROM v$sql WHERE sql_id=c1plan.sql_id);
                                                dbms_output.put_line(i||')'||c1plan.sql_id || ':'||v_sql_handle ||':'|| v_plan_name);
                                                                exception
                                                                                when others then
                                                                                dbms_output.put_line(c1plan.sql_id|| SQLCODE || substr(SQLERRM, 1, 200));
                                                                                null;
                                end;
                end loop;
end;
/             
