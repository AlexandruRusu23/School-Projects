VARIABLE g_mesaj VARCHAR2(50);

BEGIN
  :g_mesaj := 'Invat PL/SQL';
END;
/

select * from departments;

PRINT g_mesaj;

BEGIN
  DBMS_OUTPUT.PUT_LINE('Invat PL/SQL');
END;
/

set serveroutput on;

/*
 Defini?i un bloc anonim în care s? se afle numele departamentului cu cei mai mul?i angaja?i. Comenta?i cazul în care exist? cel pu?in dou? departamente cu num?r maxim de angaja?i.
*/
DECLARE
  v_dep departments.department_name%TYPE;
BEGIN
  SELECT department_name
  INTO v_dep
  FROM employees e, departments d
  WHERE e.department_id = d.department_id
  GROUP BY department_name
  HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                     FROM employees
                     GROUP BY department_id);
  DBMS_OUTPUT.PUT_LINE('Departmentul ' || v_dep);
END;
/

/*
 Rezolva?i problema anterioar? utilizând variabile de leg?tur?. Afi?a?i rezultatul atât din bloc, cât ?i din exteriorul acestuia.
*/
VARIABLE rezultat VARCHAR2(35)
VARIABLE numarRezultat NUMBER(3)

BEGIN
  SELECT department_name, count(employee_id)
  INTO :rezultat, :numarRezultat
  FROM employees e, departments d
  WHERE e.department_id = d.department_id
  GROUP BY department_name
  HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                     FROM employees
                     GROUP BY department_id);
  DBMS_OUTPUT.PUT_LINE('Departmentul ' || :rezultat);
  DBMS_OUTPUT.PUT_LINE('Numarul de angajati ' || :numarRezultat);
END;
/

PRINT rezultat
PRINT numarRezultat

/*
 Determina?i salariul anual ?i bonusul pe care îl prime?te un salariat al c?rui 
 cod este dat de la tastatur?. Bonusul este determinat astfel: dac? salariul 
 anual este cel pu?in 20001, atunci bonusul este 2000; dac? salariul anual este 
 cel pu?in 10001 ?i cel mult 20000, atunci bonusul este 1000, iar dac? salariul 
 anual este cel mult 10000, atunci bonusul este 500. Afi?a?i bonusul ob?inut. 
 Comenta?i cazul în care nu exist? niciun angajat cu codul introdus. 
*/

SET VERIFY OFF
DECLARE
  v_cod employees.employee_id%TYPE:=&p_cod;
  v_bonus         NUMBER(8);
  v_salariu_anual NUMBER(8);
BEGIN
  SELECT salary*12
  INTO v_salariu_anual
  FROM employees
  WHERE employee_id  = v_cod;
  IF v_salariu_anual>=20001 THEN
    v_bonus         :=2000;
  ELSIF v_salariu_anual BETWEEN 10001 AND 20000 THEN
    v_bonus:=1000;
  ELSE
    v_bonus:=500;
  END IF;
  DBMS_OUTPUT.PUT_LINE('Bonusul este ' || v_bonus);
END;
/ 
SET VERIFY ON

/*
 Rezolva?i problema anterioar? folosind instruc?iunea CASE. 
*/

DECLARE
  v_cod employees.employee_id%TYPE:=&p_cod;
  v_bonus         NUMBER(8);
  v_salariu_anual NUMBER(8);
BEGIN
  SELECT salary*12
  INTO v_salariu_anual
  FROM employees
  WHERE employee_id  = v_cod;
  CASE
    WHEN v_salariu_anual >= 20001 THEN v_bonus := 2000;
    WHEN v_salariu_anual <= 10000 THEN v_bonus := 500;
    ELSE v_bonus := 1000;
  END CASE;
  DBMS_OUTPUT.PUT_LINE('Bonusul este ' || v_bonus);
END;
/

/*
 Scrie?i un bloc PL/SQL în care stoca?i prin variabile de substitu?ie un cod de 
 angajat, un cod de departament ?i procentul cu care se m?re?te salariul acestuia. 
 S? se mute salariatul în noul departament ?i s? i se creasc? salariul în mod 
 corespunz?tor. Dac? modificarea s-a putut realiza (exist? în tabelul emp_*** 
 un salariat având codul respectiv) s? se afi?eze mesajul “Actualizare realizata”, 
 iar în caz contrar mesajul “Nu exista un angajat cu acest cod”. 
 Anula?i modific?rile realizate.
*/

DEFINE p_cod_sal = 200
DEFINE p_cod_dep = 100
DEFINE p_procent = 15
DECLARE
  v_cod_sal emp_ar.employee_id%TYPE := &p_cod_sal;
  v_cod_dep emp_ar.department_id%TYPE := &p_cod_dep;
  v_procent NUMBER(8) := &p_procent;
BEGIN
  UPDATE emp_ar
  SET department_id = v_cod_dep,
      salary = salary + (salary * v_procent/100)
  WHERE employee_id = v_cod_sal;
  IF SQL%ROWCOUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Nu exista niciun angajat');
  ELSE
      DBMS_OUTPUT.PUT_LINE('Actualizare realizata.');
  END IF;
END;
/
ROLLBACK;

/*
exercitiul 1
*/

DECLARE
  numar  NUMBER(3)    :=100;
  mesaj1 VARCHAR2(255):='text 1';
  mesaj2 VARCHAR2(255):='text 2';
BEGIN
  DECLARE
    numar  NUMBER(3)    :=1;
    mesaj1 VARCHAR2(255):='text 2';
    mesaj2 VARCHAR2(255):='text 3';
  BEGIN
    numar :=numar+1;
    DBMS_OUTPUT.PUT_LINE('In sub-bloc: ' || numar || ' ' || mesaj1 || ' ' || mesaj2);
    mesaj2:=mesaj2||' adaugat in sub-bloc';
  END;
numar :=numar+1;
DBMS_OUTPUT.PUT_LINE('In bloc: ' || numar || ' ' || mesaj1 || ' ' || mesaj2);
mesaj1:=mesaj1||' adaugat in blocul principal';
mesaj2:=mesaj2||' adaugat in blocul principal';
END; 
/

/*
exercitiul 2
*/

declare
  start_date number;
  end_date number;
  business_date varchar2(10);
begin
  start_date := to_number(to_char(to_date('2016-10-1', 'yyyy-MM-dd'), 'j'));
  end_date := to_number(to_char(to_date('2016-10-31', 'yyyy-MM-dd'), 'j'));
  for cur_r in start_date..end_date loop
    business_date := to_char(to_date(cur_r, 'j'), 'yyyy-MM-dd');
    dbms_output.put_line(business_date);
  end loop;
end;
/

/*
exercitiul 3
*/
select * from member;

declare
  nume varchar2(50);
begin
  nume := '&x';
  dbms_output.put_line(nume);
end;
/

