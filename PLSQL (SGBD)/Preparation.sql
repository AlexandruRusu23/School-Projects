CREATE OR REPLACE PACKAGE Examen_Package IS
  
  type student IS record(nume employees.first_name%TYPE);
  
  CURSOR cursorStudenti(numar number) RETURN student;
  
  PROCEDURE procedureA;
  
  PROCEDURE procedureC(numar number);
  
END Examen_Package;
/

CREATE OR REPLACE PACKAGE BODY Examen_Package IS

  CURSOR cursorStudenti(numar number) RETURN student IS
    SELECT employees.first_name FROM employees join departments using(department_id) where departments.manager_id > numar;

  PROCEDURE procedureA IS
    profesor LOCATIONS.CITY%TYPE;
    medie number;
    promovati number;
    picati number;
    BEGIN
      DBMS_OUTPUT.PUT_LINE('');
    END procedureA;
    
    
    PROCEDURE procedureA IS
      numeProf profesor.nume%TYPE;
      prenumeProf profesor.preume%TYPE;
      medie number;
      promovati number;
      picati number;
      BEGIN
        FOR i IN (SELECT * from curs) LOOP
          DBMS_OUTPUT.PUT_LINE('In cadrul materiei: ' || i.denumire || ':');
          SELECT nume, prenume into numeProf, prenumeProf from profesor where i.cod_profesor = cod_profesor;
          DBMS_OUTPUT.PUT_LINE('  Profesorul: ' || numeProf || ' ' || prenumeProf);
          SELECT AVG(note.nota) INTO medie from curs join note using(cod_curs) where curs.cod_curs = i.cod_curs;
          DBMS_OUTPUT.PUT_LINE('  Media studentilor: ' || medie);
          SELECT count(note.nota) INTO promovati from curs join note using(cod_curs) where curs.cod_curs = i.cod_curs AND note.nota >= 5;
          DBMS_OUTPUT.PUT_LINE('  Promovati : ' || promovati);
          SELECT count(note.nota) INTO picati from curs join note using(cod_curs) where curs.cod_curs = i.cod_curs AND note.nota < 5;
          DBMS_OUTPUT.PUT_LINE('  Picati : ' || picati);
        END LOOP;
    END procedureA;
    
  PROCEDURE procedureC(numar number) IS
    nrStudenti number(5);
    type student IS TABLE of employees.first_name%TYPE;
    studenti student;
    BEGIN
      select count(employees.employee_id) into nrStudenti from employees join departments using(department_id) where departments.manager_id > numar;
      DBMS_OUTPUT.PUT_LINE('Numarul de studenti care au peste ' || numar || ' credite: ' || nrStudenti);
    
      FOR i IN ( select employees.first_name, employees.last_name from employees join departments using(department_id) where departments.manager_id > numar ) LOOP
        DBMS_OUTPUT.PUT_LINE(i.first_name || ' ' || i.last_name);
      END LOOP;
      
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista astfel de studenti.');
      WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Prea multe linii.');
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Alta eroare!');
    END procedureC;

END Examen_Package;
/

BEGIN
  Examen_Package.procedureC(200);
END;
/

set serveroutput on;

select * from employees;
select * from jobs;
select * from job_history;
select * from departments;
select * from locations;

select count(employee_id) from employees join departments using(department_id) where departments.manager_id > 100;

select count(employees.employee_id) from employees join departments using(department_id) join locations using(location_id) where locations.location_id > 100;

select studenti.nume from studenti join nota using(cod_student) join curs using(cod_curs) where sum(curs.nr_credite) > n;

create table test_233 (id number primary key, nume varchar2(50), numar number);
create table note_233 (cod_student number primary key, cod_curs number, nota number, data_examinare date);

CREATE OR REPLACE TRIGGER trig1_ar BEFORE 
    INSERT on test_233 FOR EACH ROW
BEGIN
  IF (:NEW.numar < 1) OR (:NEW.numar > 10) THEN
    RAISE_APPLICATION_ERROR(-20001,'tabelul nu poate fi actualizat');
END IF;
END;
/

select * from test_233;
select * from note_233;

insert into test_233 values(5, 'Aledddx', 5);
insert into note_233 values(1, 2, 10, to_date('10-10-2016','dd-mm-yyyy'));
insert into note_233 values(1, 2, 7, to_date('10-9-2016','dd-mm-yyyy'));

select count(manager_id) from employees group by manager_id;

