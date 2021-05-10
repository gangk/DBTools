SELECT routines.specific_schema,routines.routine_name, parameters.data_type, parameters.ordinal_position
FROM information_schema.routines
    LEFT JOIN information_schema.parameters ON routines.specific_name=parameters.specific_name
WHERE routines.specific_schema in ('booker','admin') 
ORDER BY routines.routine_name, parameters.ordinal_position;
