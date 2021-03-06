declare
    m_clob  clob;
begin
    select
        sql_fulltext
    into
        m_clob
    from
        v$sql
    where
        sql_id = '&m_sql_id_1'
    and child_number = &m_child_number_1
    ;

    dbms_output.put_line(m_clob);

    dbms_output.put_line(
        dbms_spm.load_plans_from_cursor_cache(
            sql_id          => '&m_sql_id_2',
            plan_hash_value     => &m_plan_hash_value_2,
            sql_text        => m_clob,
            fixed           => 'NO',
            enabled         => 'YES'
        )
    );

end;
/
