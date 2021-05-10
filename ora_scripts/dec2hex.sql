declare
  N  number :=&1;
  H  VARCHAR2(64) :='';
  N2 INTEGER      := N;
BEGIN
  LOOP
     SELECT RAWTOHEX(CHR(N2))||H
     INTO   H
     FROM   dual;
 
     N2 := TRUNC(N2 / 256);
     EXIT WHEN N2=0;
  END LOOP;
H:='0x'||lower(H);
dbms_output.put_line(H);
end;
/
