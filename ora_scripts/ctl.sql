COLUMN name       FORMAT A45    HEADING "Controlfile Name"
COLUMN status                   HEADING "Status"

SELECT
    name
  , LPAD(status, 7) status
FROM v$controlfile
ORDER BY name
/

