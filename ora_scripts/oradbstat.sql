set longchunksize 80
set echo off
set escape on
set feedback off
set serveroutput on
set verify off
DECLARE
        hv_seq_read_waits_begin number := 0;
        hv_seq_read_time_begin number := 0;
        hv_seq_read_waits_end number := 0;
        hv_seq_read_time_end number := 0;
        hv_seq_read_waits_delta number := 0;
        hv_seq_read_time_delta number := 0;
        hv_seq_read_avg_ms number(5,1);

        hv_sca_read_waits_begin number := 0;
        hv_sca_read_time_begin number := 0;
        hv_sca_read_waits_end number := 0;
        hv_sca_read_time_end number := 0;
        hv_sca_read_waits_delta number := 0;
        hv_sca_read_time_delta number := 0;
        hv_sca_read_avg_ms number(5,1) := 0;

        hv_db_block_gets_begin number := 0;
        hv_db_block_gets_end number := 0;
        hv_con_gets_begin number := 0;
        hv_con_gets_end number := 0;
        hv_p_reads_begin number := 0;
        hv_p_reads_end number := 0;
        hv_p_reads_dir_begin number := 0;
        hv_p_reads_dir_end number := 0;
        hv_p_reads_lob_begin number := 0;
        hv_p_reads_lob_end number := 0;
        hv_l_reads_delta number := 0;
        hv_p_reads_delta number := 0;
        hv_p_reads_dir_delta number := 0;
        hv_p_reads_lob_delta number := 0;
        hv_cache_hit_ratio number(4,1) := 0;

        hv_par_write_waits_begin number := 0;
        hv_par_write_waits_end number := 0;
        hv_par_write_waits_delta number := 0;
        hv_par_write_time_begin number := 0;
        hv_par_write_time_end number := 0;
        hv_par_write_time_delta number := 0;
        hv_par_write_avg_ms number(5,1) := 0;

        hv_sin_write_waits_begin number := 0;
        hv_sin_write_waits_end number := 0;
        hv_sin_write_waits_delta number := 0;
        hv_sin_write_time_begin number := 0;
        hv_sin_write_time_end number := 0;
        hv_sin_write_time_delta number := 0;
        hv_sin_write_avg_ms number(5,1) := 0;

        hv_user_calls_begin number := 0;
        hv_user_calls_end number := 0;
        hv_user_calls_delta number := 0;

        cursor dbfsr_cur is
                select
                        total_waits,
                        time_waited_micro
                from
                        v\$system_event se,
                        v\$event_name en
                where
                        se.event_id = en.event_id
                        and en.name = 'db file sequential read';

        cursor dbfscr_cur is
                select
                        total_waits,
                        time_waited_micro
                from
                        v\$system_event se,
                        v\$event_name en
                where
                        se.event_id = en.event_id
                        and en.name = 'db file scattered read';

        cursor dbfpw_cur is
                select
                        total_waits,
                        time_waited_micro
                from
                        v\$system_event se,
                        v\$event_name en
                where
                        se.event_id = en.event_id
                        and en.name = 'db file parallel write';

        cursor dbfsw_cur is
                select
                        total_waits,
                        time_waited_micro
                from
                        v\$system_event se,
                        v\$event_name en
                where
                        se.event_id = en.event_id
                        and en.name = 'db file single write';

        cursor uc_cur is
                select
                        stat.value
                from
                        v\$sysstat stat
                where
                        stat.name = 'user calls';


BEGIN

        for aa in dbfsr_cur
        loop
                hv_seq_read_waits_begin := aa.total_waits;
                hv_seq_read_time_begin := aa.time_waited_micro;
        end loop;

        for bb in dbfscr_cur
        loop
                hv_sca_read_waits_begin := bb.total_waits;
                hv_sca_read_time_begin := bb.time_waited_micro;
        end loop;

        select a.value, b.value, c.value, d.value, e.value into hv_db_block_gets_begin, hv_con_gets_begin, hv_p_reads_begin, hv_p_reads_dir_begin, hv_p_reads_lob_begin from v\$sysstat a, v\$sysstat b, v\$sysstat c, v\$sysstat d, v\$sysstat e where a.name = 'db block gets' and b.name = 'consistent gets' and c.name = 'physical reads' and d.name = 'physical reads direct' and e.name = 'physical reads direct (lob)';

        for x in dbfpw_cur
        loop
                hv_par_write_waits_begin := x.total_waits;
                hv_par_write_time_begin := x.time_waited_micro;
        end loop;

        for a in dbfsw_cur
        loop
                hv_sin_write_waits_begin := a.total_waits;
                hv_sin_write_time_begin := a.time_waited_micro;
        end loop;

        for uc in uc_cur
        loop
                hv_user_calls_begin := uc.value;
        end loop;

        dbms_lock.sleep(&&1);

        select a.value, b.value, c.value, d.value, e.value into hv_db_block_gets_end, hv_con_gets_end, hv_p_reads_end, hv_p_reads_dir_end, hv_p_reads_lob_end from v\$sysstat a, v\$sysstat b, v\$sysstat c, v\$sysstat d, v\$sysstat e  where a.name = 'db block gets' and b.name = 'consistent gets' and c.name = 'physical reads' and d.name = 'physical reads direct' and e.name = 'physical reads direct (lob)';

        for bb in dbfsr_cur
        loop
                hv_seq_read_waits_end := bb.total_waits;
                hv_seq_read_time_end := bb.time_waited_micro;
        end loop;

        for cc in dbfscr_cur
        loop
                hv_sca_read_waits_end := cc.total_waits;
                hv_sca_read_time_end := cc.time_waited_micro;
        end loop;

        for y in dbfpw_cur
        loop
                hv_par_write_waits_end := y.total_waits;
                hv_par_write_time_end := y.time_waited_micro;
        end loop;

        for b in dbfsw_cur
        loop
                hv_sin_write_waits_end := b.total_waits;
                hv_sin_write_time_end := b.time_waited_micro;
        end loop;

        for uc_e in uc_cur
        loop
                hv_user_calls_end := uc_e.value;
        end loop;
        hv_user_calls_delta := hv_user_calls_end - hv_user_calls_begin;

        hv_seq_read_waits_delta := hv_seq_read_waits_end - hv_seq_read_waits_begin;
        hv_seq_read_time_delta := hv_seq_read_time_end - hv_seq_read_time_begin;
        if (hv_seq_read_waits_delta = 0) then
                hv_seq_read_avg_ms := 0;
        else
                hv_seq_read_avg_ms := (hv_seq_read_time_delta / 1000 / hv_seq_read_waits_delta);
        end if;

        hv_sca_read_waits_delta := hv_sca_read_waits_end - hv_sca_read_waits_begin;
        hv_sca_read_time_delta := hv_sca_read_time_end - hv_sca_read_time_begin;
        if (hv_sca_read_waits_delta = 0) then
                hv_sca_read_avg_ms := 0;
        else
                hv_sca_read_avg_ms := (hv_sca_read_time_delta / 1000 / hv_sca_read_waits_delta);
        end if;

        hv_l_reads_delta := (hv_con_gets_end + hv_db_block_gets_end) - (hv_con_gets_begin + hv_db_block_gets_begin);
        hv_p_reads_delta := hv_p_reads_end - hv_p_reads_begin;
        hv_p_reads_dir_delta := hv_p_reads_dir_end - hv_p_reads_dir_begin;
        hv_p_reads_lob_delta := hv_p_reads_lob_end - hv_p_reads_lob_begin;

        if (hv_l_reads_delta -  (hv_p_reads_dir_delta + hv_p_reads_lob_delta ) = 0) then
                 hv_cache_hit_ratio := 100;
        else
                hv_cache_hit_ratio := (1 - ( hv_p_reads_delta - ( hv_p_reads_dir_delta + hv_p_reads_lob_delta ) ) / ( hv_l_reads_delta -  (hv_p_reads_dir_delta + hv_p_reads_lob_delta ))) * 100;
        end if;

        hv_par_write_waits_delta := hv_par_write_waits_end - hv_par_write_waits_begin;
        hv_par_write_time_delta := hv_par_write_time_end - hv_par_write_time_begin;
        if (hv_par_write_waits_delta = 0) then
                hv_par_write_avg_ms := 0;
        else
                hv_par_write_avg_ms := (hv_par_write_time_delta / 1000 / hv_par_write_waits_delta);
        end if;

        hv_sin_write_waits_delta := hv_sin_write_waits_end - hv_sin_write_waits_begin;
        hv_sin_write_time_delta := hv_sin_write_time_end - hv_sin_write_time_begin;
        if (hv_sin_write_waits_delta = 0) then
                hv_sin_write_avg_ms := 0;
        else
                hv_sin_write_avg_ms := (hv_sin_write_time_delta / 1000 / hv_sin_write_waits_delta);
        end if;

        dbms_output.put_line('+'||to_char(hv_seq_read_waits_delta,'999,999')||'  '||to_char(hv_seq_read_avg_ms,'9990.9')||'  '||to_char(hv_sca_read_waits_delta,'999,999')||'  '||to_char(hv_sca_read_avg_ms,'9990.9')||'  '||to_char(hv_l_reads_delta,'99,999,999')||'  '||to_char(hv_p_reads_delta,'99,999,999')||' '||to_char(hv_cache_hit_ratio,'990.9')||'  '||to_char(hv_par_write_waits_delta,'99,999')||'  '||to_char(hv_par_write_avg_ms,'9990.9')||'  '||to_char(hv_sin_write_waits_delta,'99,999')||'  '||to_char(hv_sin_write_avg_ms,'9990.9')||'  '||to_char(hv_user_calls_delta,'9,999,999'));
END;
/

