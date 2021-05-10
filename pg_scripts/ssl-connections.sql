SELECT datname, usename, client_addr, ssl, cipher FROM pg_stat_activity INNER JOIN pg_stat_ssl ON pg_stat_activity.pid=pg_stat_ssl.pid;
