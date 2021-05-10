-----
-- Show all ASM file aliases
-----
TTITLE 'ASM Disk Group Aliases (From V$ASM_ALIAS)'
COL name                FORMAT A32              HEADING 'Disk Group Alias' WRAP
COL group_number        FORMAT 9999999999       HEADING 'ASM|File #' 
COL file_number         FORMAT 9999999999       HEADING 'File #'
COL file_incarnation    FORMAT 9999999999       HEADING 'ASM|File|Inc#'
COL alias_index         FORMAT 9999999999       HEADING 'Alias|Index'
COL alias_incarnation   FORMAT 999999           HEADING 'Alias|Incn#'
COL alias_directory     FORMAT A4               HEADING 'Ali|Dir?'
COL system_created      FORMAT A4               HEADING 'Sys|Crt?'
SELECT
     name
    ,group_number
    ,file_number
    ,file_incarnation
    ,alias_index
    ,alias_incarnation
    ,alias_directory
    ,system_created
  FROM v$asm_alias
;