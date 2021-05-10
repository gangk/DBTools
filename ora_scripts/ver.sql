SET TIMING OFF

col PRODUCT for a35
col status for a20
col version for a12
col comp_name for a50

prompt FROM v$VERSION
select * from v$version;

prompt FROM dba_registry
select comp_name ,status, version from dba_registry;

prompt FROM product_component_version
select * from product_component_version;

SET TIMING ON
