col datafile for a20
col tempfile for a20
col logfile for a20
col controlfile for a20

select distinct substr(file_name,2,instr(file_name,'/',2)-2)datafile from dba_data_files;

select distinct substr(file_name,2,instr(file_name,'/',2)-2)tempfile from dba_temp_files;

select distinct substr(member,2,instr(member,'/',2)-2)logfile from v$logfile;

select distinct substr(name,2,instr(name,'/',2)-2)controlfile from v$controlfile;



