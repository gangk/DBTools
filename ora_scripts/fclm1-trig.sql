CREATE OR REPLACE TRIGGER "BOOKER"."AUD_FC_EMPLOYEE_PERMS"
BEFORE INSERT OR UPDATE
ON BOOKER.FC_EMPLOYEE_PERMISSIONS
FOR EACH ROW
DECLARE
  osuser        VARCHAR2(8);
BEGIN
  --
  -- get who is making the DML change from the session
  --
  osuser := session_info.osuser;
  --
  IF (NOT (dbms_snapshot.i_am_a_refresh)
  AND dbms_reputil.REPLICATION_is_on) THEN
    IF NOT dbms_reputil.from_remote THEN
      IF INSERTING THEN
        :new.created_date_utc := sysdate - time_util.local_time_offset_from_utc();
      END IF;
      :new.last_updated_date_utc := sysdate - time_util.local_time_offset_from_utc();
    END IF;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    -- raise error if we cannot set auditing fields
    raise_application_error(-20505, 'BOOKER.AUD_FC_EMPLOYEE_PERMS Failed. Rolling Back.' || SQLERRM);
END
/
