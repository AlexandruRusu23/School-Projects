select * from employees;

select first_name as "Nume", salary as "Salariu", employee_id as "ID" from employees;

/* exercitiul 4 
 S? se modifice exemplul 2 astfel încât denumirile coloanelor s? fie Nr. crt, Numele angajatului, Prenumele angajatului.
*/
SELECT rownum "Nr. crt",last_name "Numele angajatului", first_name "Prenumele Angajatului" FROM employees;

select sysdate from dual;

/* exercitiul 6 
 S? se afi?eze pentru fiecare job: codul, titlul si diferen?a dintre salariul maxim ?i salariul minim.
*/
select job_id, max(salary) - min(salary) "Diferenta" from employees group by job_id;

/* exercitiul 7
 S? se afi?eze pentru fiecare angajat codul, numele, codul departamentului în care lucreaza fiecare 
 angajat ?i num?rul de zile care au trecut de la data angaj?rii.
*/
select employee_id, first_name, last_name, department_id, sysdate-hire_date from employees;

/* exercitiul 8
 S? se afi?eze numele angaja?ilor, codul_angaja?ilor (employee_id) ?i salariul anual al acestora 
 (salary * 12).
*/
select last_name, employee_id, salary*12 "Salariul Anual" from employees;

/* exercitiul 9
 S? se afi?eze numele angaja?ilor ?i valoarea comisionului raportat? la salariu.
*/
select first_name, last_name, commission_pct * salary Comision from employees where commission_pct is not null;

/* exercitiul 11
 S? se listeze, ce joburi au salaria?ii ?i în ce departamente lucreaz? ace?tia.
 COMM: not sure if it's correct, but this is what i understand from this task
*/
select first_name, last_name, job_id, department_id from employees where salary is not null;

/* exercitiul 13
 S? se ob?in? codul angaja?ilor, concatenat cu numele ?i cu salariul.
*/
select * from employees;
select job_id || ' ' || first_name || ' ' || salary from employees;

/* exercitiul 15
 S? se ob?in? numele ?i venitul angajatului cu codul 170
*/
select first_name || ' ' || last_name "Nume angajat", salary "Salariu" from employees where employee_id = 170;

/* exercitiul 16
 S? se ob?in? infoma?ii despre angaja?ii care au o vechme, exprimata în numar de zile mai mare decât 1000.
*/
select * from employees where sysdate - hire_date > 1000;

/* exercitiul 18
 S? se afi?eze numele ?i codul departamentului pentru angaja?ii care au codul jobului IT_PROG sau HR_REP.
*/
select last_name, department_id from employees where job_id in ('IT_PROG', 'HR_REP');

/* exercitiul 19
 S? se listeze numele ?i salariile angajatilor care câstig? mai mult de 1500 $ ?i lucreaz? în departamentul 
 10 sau 30. Se vor eticheta coloanele Angajat respectiv Salariu lunar.
*/
select last_name "Angajat", salary "Salariu lunar" from employees where salary > 1500 and department_id in (10, 30);

/* exercitiul 21
 S? se afi?eze venitul (salariu + comision) angaja?ilor care câ?tig? comision?
*/
select salary + (salary * commission_pct) "Venit" from employees where commission_pct is not null;

/* exercitiul 22
 Care este codul jobului angajatului pentru care nu se cunoa?te departamentul în care lucreaz??
*/
select first_name, job_id from employees where department_id is null;

/* exercitiul 25
 S? se afi?eze numele, job-ul ?i salariul pentru to?i salaria?ii al c?ror job con?ine 
 ?irul CLERK sau REP ?i salariul nu este egal cu 1000, 2000 sau 3000 $.
*/
select first_name, job_id, salary from employees where ( job_id like '%CLERK%' or job_id like '%REP' ) and salary not in (1000, 2000, 3000);

/* exercitiul 26
 S? se listeze numele tuturor angajatilor care au 2 litere 'l' în nume ?i lucreaz? în 
 departamentul 30 sau managerul lor este 102.
*/
select last_name, first_name from employees where last_name like '%ll%' or first_name like '%ll%' or manager_id = 102;
