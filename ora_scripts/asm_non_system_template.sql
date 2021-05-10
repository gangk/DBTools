-- Show all non-system ASM file templates
TTITLE 'Non-System ASM Templates (From V$ASM_TEMPLATE)'
COL group_number        FORMAT 99999    HEADING 'ASM|Disk|Grp #' 
COL entry_number        FORMAT 99999    HEADING 'ASM|Entry|#'
COL redundancy          FORMAT A06      HEADING 'Redun-|dancy'
COL stripe              FORMAT A06      HEADING 'Stripe'
COL system              FORMAT A03      HEADING 'Sys|?'
COL name                FORMAT A30      HEADING 'ASM Template Name' WRAP
SELECT
     group_number
    ,entry_number
    ,redundancy
    ,stripe
    ,system
    ,name
  FROM v$asm_template
 WHERE system <> 'Y'
;
