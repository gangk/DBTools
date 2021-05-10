prompt Tablespace
accept tblspace
rem define tblspace = users

drop table t1 purge;

drop sequence seq_t1_run_id;

drop sequence seq_t1_seq_id;

create table t1 (
run_id integer not null, /* identify the process inserting the data */
batch_id integer not null, /* represents clustered data, could also be a (arriving) date */
a_value number null, /* represents sequence based data */
a_random number null, /* represents randomly scattered data */
a_date timestamp default systimestamp not null, /* represents the insert timestamp */
filler char(1) default 'x' not null /* can be used to size the row as required */
)
tablespace &tblspace;

/* a sample index */
create index t1_idx1 on
t1 (
batch_id,
a_value
)
tablespace &tblspace;

create sequence seq_t1_run_id;

create sequence seq_t1_seq_id;

create or replace procedure populate_t1(i_run_id in integer, i_iter in integer) as
begin
dbms_output.put_line(
dbms_lock.request(
1
, dbms_lock.s_mode
, release_on_commit => true
)
);
commit;
for i in 1..i_iter loop
for j in 1..100 loop
insert into t1 (
run_id
, batch_id
, a_value
, a_random
)
values (
i_run_id
, i
, seq_t1_seq_id.nextval
, trunc(dbms_random.value(1, 1000))
);
commit;
dbms_lock.sleep(0.01);
end loop;
end loop;
end;
/