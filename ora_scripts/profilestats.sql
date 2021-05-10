set long 999999999
SELECT chr(9)||chr(9)||''''||regexp_replace(extractvalue(value(d), '/hint'),'''','''''')||''','
        from
        xmltable('/outline_data/hint'
                passing (
                        select
                                xmltype(comp_data) as xmlval
                        from
                                DBMSHSXP_SQL_PROFILE_ATTR
                        where
                                profile_name='&profile_name'
                        )
                )
d;
undef profile_name
