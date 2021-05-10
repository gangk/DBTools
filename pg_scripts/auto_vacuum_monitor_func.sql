CREATE OR REPLACE FUNCTION public.pg_autovacuum_count() RETURNS bigint
AS 'select count(*) from pg_stat_activity where query like ''autovacuum:%'';'
LANGUAGE SQL
STABLE
SECURITY DEFINER;
