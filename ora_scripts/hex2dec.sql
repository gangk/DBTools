declare
  i                 NUMBER;
  digits            NUMBER;
  result            NUMBER := 0;
  current_digit     CHAR(1);
  current_digit_dec NUMBER;
  hexnum varchar2(20):='&1';
  object varchar2(30);
  otype varchar2(30);
BEGIN
    hexnum := replace(upper(hexnum),'0X','');
    digits := LENGTH(hexnum);
    FOR i IN 1..digits LOOP
       current_digit := SUBSTR(hexnum, i, 1);
       IF current_digit IN ('A','B','C','D','E','F') THEN
          current_digit_dec := ASCII(current_digit) - ASCII('A') + 10;
       ELSE
          current_digit_dec := TO_NUMBER(current_digit);
       END IF;
       result := (result * 16) + current_digit_dec;
  END LOOP;
 
	dbms_output.put_line('Decimal is '||result);
	select object_name,object_type into object,otype from dba_objects where object_id=result;

	dbms_output.put_line('Possible object is '||object ||' and type is '||otype);

 end;
 /
