SELECT
a.name,
a.checkpoint_change#,
b.checkpoint_change#,
CASE
WHEN ((a.checkpoint_change# - b.checkpoint_change#) = 0) THEN 'Startup Normal'
WHEN ((a.checkpoint_change# - b.checkpoint_change#) > 0) THEN 'Media Recovery'
WHEN ((a.checkpoint_change# - b.checkpoint_change#) < 0) THEN 'Old Control File'
ELSE 'what the ?'
END STATUS
FROM v$datafile a, -- control file SCN for datafile
v$datafile_header b -- datafile header SCN
WHERE a.file# = b.file#;