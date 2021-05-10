$ olsnodes -c


set linesize 100
col FILES_OF_CLUSTER for a60

select concat('+'||gname, sys_connect_by_path(aname, '/')) FILES_OF_CLUSTER
     from ( select b.name gname, a.parent_index pindex, a.name aname,
              a.reference_index rindex , a.system_created, a.alias_directory,
              c.type file_type
       from v$asm_alias a, v$asm_diskgroup b, v$asm_file c
       where a.group_number = b.group_number
             and a.group_number = c.group_number(+)
             and a.file_number = c.file_number(+)
             and a.file_incarnation = c.incarnation(+)
     ) WHERE file_type in ( 'ASMPARAMETERFILE','OCRFILE')
start with (mod(pindex, power(2, 24))) = 0
            and rindex in
                ( select a.reference_index
                  from v$asm_alias a, v$asm_diskgroup b
                  where a.group_number = b.group_number
                        and (mod(a.parent_index, power(2, 24))) = 0
                        and a.name = LOWER('&CLUSTERNAME')
                )
connect by prior rindex = pindex;