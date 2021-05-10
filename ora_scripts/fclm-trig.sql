CREATE OR REPLACE TRIGGER BOOKER.AUD_TRAINING_SERVICE_AUDIT_LOG
BEFORE INSERT ON BOOKER.TRAINING_SERVICE_AUDIT_LOG
FOR EACH ROW
DECLARE
        osuser VARCHAR2(8);
BEGIN
        osuser := session_info.osuser;
IF (NOT (dbms_snapshot.i_am_a_refresh) AND dbms_reputil.replication_is_on) THEN
        IF NOT dbms_reputil.from_remote THEN
                :new.created_by := osuser;
                :new.created_date_utc := sysdate - time_util.local_time_offset_from_utc();
        END IF;
END IF;
EXCEPTION WHEN OTHERS THEN
        raise_application_error(-20505, 'BOOKER.AUD_TRAINING_SERVICE_AUDIT_LOG Failed. Rolling Back.'||SQLERRM);
END;
/


CREATE OR REPLACE TRIGGER BOOKER.AUD_TRAINING_SERVICE_AUDIT_LOG
BEFORE INSERT ON BOOKER.TRAINING_SERVICE_AUDIT_LOG
FOR EACH ROW
DECLARE
osuser	VARCHAR2(8);
BEGIN
osuser := session_info.osuser;
IF (NOT (dbms_snapshot.i_am_a_refresh) AND dbms_reputil.replication_is_on) THEN
    IF NOT dbms_reputil.from_remote THEN
	:new.created_by := osuser;
	:new.created_date_utc := sysdate - time_util.local_time_offset_from_utc();
    END IF;
  END IF;
EXCEPTION WHEN OTHERS THEN
    raise_application_error(-20505, 'BOOKER.AUD_TRAINING_SERVICE_AUDIT_LOG Failed. Rolling Back.'||SQLERRM);
END;
/



CREATE OR REPLACE TRIGGER "BOOKER"."AUD_FC_EMPLOYEE_PERMS"
BEFORE INSERT OR UPDATE
ON BOOKER.FC_EMPLOYEE_PERMISSIONS
FOR EACH ROW
DECLARE
  osuser        VARCHAR2(8);
BEGIN
  osuser := session_info.osuser;
  IF (NOT (dbms_snapshot.i_am_a_refresh)
  AND dbms_reputil.REPLICATION_is_on) THEN
    IF NOT dbms_reputil.from_remote THEN
      IF INSERTING THEN
        :new.created_date_utc := sysdate - time_util.local_time_offset_from_utc();
      END IF;
      :new.last_updated_date_utc := sysdate - time_util.local_time_offset_from_utc();
    END IF;
  END IF;
EXCEPTION WHEN OTHERS THEN
    raise_application_error(-20505, 'BOOKER.AUD_FC_EMPLOYEE_PERMS Failed. Rolling Back.'||SQLERRM);
END;
/


CREATE OR REPLACE TRIGGER "BOOKER"."AUDIT_TRAINING_EMPLOYEE_DATA"
BEFORE INSERT OR UPDATE
on BOOKER.TRAINING_EMPLOYEE_DATA
FOR EACH ROW
DECLARE
  osuser	VARCHAR2(8);
BEGIN
  osuser := session_info.osuser;
  IF (NOT (dbms_snapshot.i_am_a_refresh) AND dbms_reputil.replication_is_on) THEN
    IF NOT dbms_reputil.from_remote THEN
      IF INSERTING THEN
	:new.CREATED_BY := osuser;
	:new.CREATED_DATE_UTC := sysdate + time_util.local_time_offset_from_utc();
	:new.LAST_UPDATED_BY := osuser;
	:new.LAST_UPDATED_DATE_UTC := sysdate + time_util.local_time_offset_from_utc();
      END IF;
      --
      IF UPDATING THEN
	:new.LAST_UPDATED_BY := osuser;
	:new.LAST_UPDATED_DATE_UTC := sysdate + time_util.local_time_offset_from_utc();
      END IF;
    END IF;
  END IF;
EXCEPTION WHEN OTHERS THEN
    raise_application_error(-20505, 'audit_TRAINING_EMPLOYEE_DATA Failed. Rolling Back.' || SQLERRM);
END;
/
