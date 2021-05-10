col plan for a15
col sql_profile for a30
col plan_hash_2 for a15
select sq.sql_id,hp.child_number,extractvalue(xmltype(hp.other_xml),'other_xml/info[@type="plan_hash"]') plan,extractvalue(xmltype(hp.other_xml),'other_xml/info[@type="plan_hash_2"]') plan_hash_2,sq.SQL_PLAN_BASELINE,sq.SQL_PROFILE,sq.SQL_PATCH,obj.PLAN_ID,obj.obj_type
        from   v$sql_plan hp,v$sql sq,SYS.SQLOBJ$DATA obj
        where  hp.sql_id='&sql_id'
	and    hp.child_number=&child_number
	and    hp.sql_id=sq.sql_id
        and    hp.other_xml is not null
	and    sq.exact_matching_signature=obj.signature(+);

