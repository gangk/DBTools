accept sql_id Prompt'Enter Sql_id:- '
accept plan_hash Prompt'Enter plan_hash:- '

SELECT ''''||regexp_replace(extractvalue(value(d), '/hint'),'''','''''')||''',' plan_hint
        from
        xmltable('/*/outline_data/hint'
                passing (
                        select
                                xmltype(other_xml) as xmlval
                        from
                                dba_hist_sql_plan
                        where
                                other_xml is not null
                        and
                        	sql_id='&sql_id'
                        and 
                        	plan_hash_value=&plan_hash                               
                        )
                )
d;

undef sql_id
undef plan_hash
