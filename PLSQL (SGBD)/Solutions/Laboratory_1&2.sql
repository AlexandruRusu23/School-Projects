-- vreau sa afisez in script output:
set serveroutput on;

--% PL/SQL 2

-- afisam nume & prenume pentru fiecare member
declare
    type tip is record( 
                      fn member.first_name%type,  
                      ln member.last_name%type
                      );
    type tip1 is table of tip index by binary_integer;
--    
    colectie_de_nume tip1;
    firstname member.first_name%type;
    cate_impr number(3);
    de_cate_ori_apare number(2);
begin
      select first_name, last_name 
      bulk collect into colectie_de_nume 
      from member;
  for i in colectie_de_nume.first..colectie_de_nume.last
  loop
      dbms_output.put_line(colectie_de_nume(i).fn ||'  '||colectie_de_nume(i).ln);
  end loop;
end;
/

-- afisare departamente & nr angajati
DECLARE
type tip IS  record  (
    dept departments.department_name%type,
    nr_ang NUMBER(3)
    );
type tablou IS  TABLE OF tip INDEX BY binary_integer;
  variabila tablou;
BEGIN
      SELECT department_name,  COUNT(*) 
      bulk collect INTO variabila
      FROM departments d
      FULL JOIN employees e
      ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
      GROUP BY department_name;
  FOR i IN variabila.first..variabila.last
  LOOP
    dbms_output.put_line(variabila(i).dept || '  ' ||variabila(i).nr_ang);
  END LOOP;
END;
/

-- afisare doar nr angajati
DECLARE
type tablou IS  TABLE OF number(4) INDEX BY binary_integer;
  variabila tablou;
BEGIN
      SELECT COUNT(*) 
      bulk collect INTO variabila
      FROM departments d
      FULL JOIN employees e
      ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
      GROUP BY department_name;
  FOR i IN variabila.first..variabila.last
  LOOP
    dbms_output.put_line(variabila(i));
  END LOOP;
END;
/

-- stergem angajatul cu employee_id=100 si mentinem informatii despre el in variabila v_ang (de tip record)
create table emp_ceva as select * from employees;
DECLARE
TYPE emp_record IS RECORD(
    cod employees.employee_id%TYPE,
    salariu employees.salary%TYPE,
    job employees.job_id%TYPE
    );
  v_ang emp_record;
BEGIN
  DELETE FROM emp_ceva
  WHERE employee_id=100 
  RETURNING employee_id, salary, job_id
  INTO v_ang;
  
  DBMS_OUTPUT.PUT_LINE ('Angajatul cu codul '|| v_ang.cod || ' si jobul ' ||
  v_ang.job || ' are salariul ' || v_ang.salariu);
END;
/
ROLLBACK;


-- modificam ex5 din PL/SQL 1 a.i. sa faca update pe coloana discount pt toti membrii
-- ex 5
create table member_ceva as select * from member;
alter table member_ceva add (categorie varchar2(50));
--select * from member_ceva;

declare
    type tip1 is table of member.first_name%type index by binary_integer;
    var tip1;
    cate_impr number(3);
    cate_titluri number(3);
    procent number(3);
begin
  select first_name bulk collect into var from member;

 for i in var.first..var.last 
 loop
    select count(*) into cate_titluri from title;

    select count(*) into cate_impr from member m, rental r
    where m.member_id = r.member_id
    and upper(m.first_name) = upper(var(i));
    
    dbms_output.put_line(var(i) ||' a imprumutat '||cate_impr||' filme');
    
    procent := cate_impr/cate_titluri;
    
    case when procent >= 0.75 then 
              dbms_output.put_line('Categ1');
              
              UPDATE member_ceva
              SET categorie='Categ1'
              where upper(first_name) = upper(var(i));
              
         when procent >= 0.5 then  
              dbms_output.put_line('Categ2');
              UPDATE member_ceva
              SET categorie='Categ2'
              where upper(first_name) = upper(var(i));
         when procent >= 0.25 then  
              dbms_output.put_line('Categ3');
              UPDATE member_ceva
              SET categorie='Categ3'
              where upper(first_name) = upper(var(i));
         else  
              dbms_output.put_line('Categ4');
              UPDATE member_ceva
              SET categorie='Categ4'
              where upper(first_name) = upper(var(i));
    end case;
end loop;
end;
/
select * from member_ceva;




--% PL/SQL 1
--% exercitiul 2,b
CREATE TABLE octombrie
  (
    id   NUMBER(3),
    data DATE,
    cate NUMBER(3)
  );
--SELECT to_date('01-'  ||TO_CHAR(sysdate,'mm')  ||'-'  ||TO_CHAR(sysdate,'yyyy'),'dd/mm/yyyy') FROM dual;
DECLARE
  v_data DATE;
  vstart DATE;
  maxim  NUMBER(2);
  cate   NUMBER(3);
BEGIN
  SELECT to_date('01-'||TO_CHAR(sysdate,'mm')||'-'||TO_CHAR(sysdate,'yyyy'),'dd/mm/yyyy')
  INTO vstart
  FROM dual;
  maxim := last_day(sysdate)-vstart+1;
  --  dbms_output.put_line(maxim);
  FOR contor IN 1..maxim
  LOOP
    v_data := vstart+contor-1;
    SELECT COUNT(*)
    INTO cate
    FROM rental
    WHERE TO_CHAR(BOOK_DATE, 'dd/mm/yyyy') = TO_CHAR(v_data, 'dd/mm/yyyy');
    INSERT INTO octombrie VALUES(contor,v_data,cate);
  END LOOP;
END;
/
SELECT * FROM rental;
SELECT * FROM octombrie;
ROLLBACK;


-- ex3
declare
    firstname member.first_name%type := '&tastatura';
    cate_impr number(3);
    
    de_cate_ori_apare number(2);
begin
-- vad de cate ori apare first name in baza
select count(*) into de_cate_ori_apare from member
where upper(first_name) = upper(firstname);

-- verific cu if...
if de_cate_ori_apare = 0 then
     dbms_output.put_line('Nu exista');
elsif de_cate_ori_apare>1 then 
    dbms_output.put_line('Mai multi');
else 
-- inseamna ca totul este in regula 
    select count(*) into cate_impr from member m, rental r
    where m.member_id = r.member_id
    and upper(m.first_name) = upper(firstname);
    
    dbms_output.put_line(firstname ||' a imprumutat '||cate_impr||' filme');    
 end if;
end;
/

select * from member;


-- ex4
declare
    firstname member.first_name%type := '&tastatura';
    cate_impr number(3);
    de_cate_ori_apare number(2);
    cate_titluri number(3);
    procent number(3);
begin
-- vad de cate ori apare first name in baza
select count(*) into de_cate_ori_apare from member
where upper(first_name) = upper(firstname);

-- verific cu if
if de_cate_ori_apare = 0 then
     dbms_output.put_line('Nu exista');
elsif de_cate_ori_apare>1 then 
    dbms_output.put_line('Mai multi');
else 
-- inseamna ca totul este in regula
    select count(*) into cate_titluri from title;

    select count(*) into cate_impr from member m, rental r
    where m.member_id = r.member_id
    and upper(m.first_name) = upper(firstname);
    
    dbms_output.put_line(firstname ||' a imprumutat '||cate_impr||' filme');
    
    procent := cate_impr/cate_titluri;
    
    case when procent >= 0.75 then  dbms_output.put_line('Categ1');
            when procent >= 0.5 then  dbms_output.put_line('Categ2');
            when procent >= 0.25 then  dbms_output.put_line('Categ3');
            else  dbms_output.put_line('Categ4');
    end case;
 end if;
end;
/



-- ex 5
create table member_ceva as select * from member;
alter table member_ceva add (categorie varchar2(50));
select * from member_ceva;

declare
    firstname member.first_name%type := '&tastatura';
    cate_impr number(3);
    de_cate_ori_apare number(2);
    cate_titluri number(3);
    procent number(3);
begin
-- vad de cate ori apare first name in baza
select count(*) into de_cate_ori_apare from member
where upper(first_name) = upper(firstname);

-- verific cu if
if de_cate_ori_apare = 0 then
     dbms_output.put_line('Nu exista');
elsif de_cate_ori_apare>1 then 
    dbms_output.put_line('Mai multi');
else 
-- inseamna ca totul este in regula
    select count(*) into cate_titluri from title;

    select count(*) into cate_impr from member m, rental r
    where m.member_id = r.member_id
    and upper(m.first_name) = upper(firstname);
    
    dbms_output.put_line(firstname ||' a imprumutat '||cate_impr||' filme');
    
    procent := cate_impr/cate_titluri;
    
    case when procent >= 0.75 then 
              dbms_output.put_line('Categ1');
              
              UPDATE member_ceva
              SET categorie='Categ1'
              where upper(first_name) = upper(firstname);
              
         when procent >= 0.5 then  
              dbms_output.put_line('Categ2');
              UPDATE member_ceva
              SET categorie='Categ2'
              where upper(first_name) = upper(firstname);
         when procent >= 0.25 then  
              dbms_output.put_line('Categ3');
              UPDATE member_ceva
              SET categorie='Categ3'
              where upper(first_name) = upper(firstname);
         else  
              dbms_output.put_line('Categ4');
              UPDATE member_ceva
              SET categorie='Categ4'
              where upper(first_name) = upper(firstname);
    end case;
 end if;
end;
/
select * from member_ceva;


