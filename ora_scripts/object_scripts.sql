
select distinct  ' select DBMS_METADATA.GET_DDL('||''''||object_type||''''||',object_name) from user_objects where object_type ='||''''||object_type||''''||' ;' from user_objects;