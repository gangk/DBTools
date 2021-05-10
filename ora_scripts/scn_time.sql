select scn_to_timestamp(scn) ts, min(scn), max(scn)
          from (
        select dbms_flashback.get_system_change_number()-level scn
          from dual
        connect by level <= 100
               )
         group by scn_to_timestamp(scn)
         order by scn_to_timestamp(scn)
    /