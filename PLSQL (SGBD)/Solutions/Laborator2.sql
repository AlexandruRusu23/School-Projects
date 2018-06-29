DECLARE
  x NUMBER(1) := 5;
  y x%TYPE    := NULL;
BEGIN
  IF x <> y THEN
    DBMS_OUTPUT.PUT_LINE ('valoare <> null este = true');
  ELSE
    DBMS_OUTPUT.PUT_LINE ('valoare <> null este != true');
  END IF;
  x   := NULL;
  IF x = y THEN
    DBMS_OUTPUT.PUT_LINE ('null = null este = true');
  ELSE
    DBMS_OUTPUT.PUT_LINE ('null = null este != true');
  END IF;
END;
/

declare 
  type emp_ar is record
      (cod employees.employee_id%type,
      salariu employees.salary%type,
      job employees.job_id%type);
      
  v_ang emp_ar;
  
begin
  v_ang.cod := 101;
  
end;
/

declare 
  type tablou_indexat is table of number index by binary_integer;
  t tablou_indexat;
begin
  -- punctul a
  for i in 1..10 loop
    t(i) := i;
  end loop;
  dbms_output.put_line('Tabloul are ' || t.count || ' elemente');
  for i in 1..t.count loop
    dbms_output.put_line('Elementul ' || i || ' : ' || t(i));
  end loop;
  -- punctul b
  for i in 1..t.count loop
    if i mod 2 = 1
      then t(i) := null;
    end if;
  end loop;
  dbms_output.put_line('Tabloul are ' || t.count || ' elemente');  
  -- punctul c
  t.delete(t.first);
  t.delete(5,7);
  t.delete(t.last);
  DBMS_OUTPUT.PUT_LINE('Primul element are indicele ' || t.first || ' si valoarea ' || NVL(t(t.first),0));
  DBMS_OUTPUT.PUT_LINE('Ultimul element are indicele ' || t.last || ' si valoarea ' || NVL(t(t.last),0));
  DBMS_OUTPUT.PUT_LINE('Tabloul are ' || t.count ||' elemente: ');
  FOR i IN t.FIRST..t.LAST LOOP
    IF t.EXISTS(i) THEN
      DBMS_OUTPUT.PUT_LINE(NVL(t(i), 0)|| ' ');
    END IF;
  END LOOP;
  -- punctul d   
  t.delete;   
  DBMS_OUTPUT.PUT_LINE('Tabloul are ' || t.COUNT ||' elemente.');
end;
/


DECLARE
TYPE vector IS VARRAY(12) OF NUMBER;
t vector:= vector();
BEGIN
  -- punctul a
  FOR i IN 1..10
  LOOP
    t.extend;
    t(i):=i;
  END LOOP;
  DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
  FOR i IN t.FIRST..t.LAST
  LOOP
    DBMS_OUTPUT.PUT(t(i) || ' ');
  END LOOP;
  DBMS_OUTPUT.NEW_LINE;
end;
/

