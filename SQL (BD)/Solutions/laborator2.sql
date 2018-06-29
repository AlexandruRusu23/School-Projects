select * from employees;

/* exercitiul 2
 S? se afi?eze angaja?ii în ordinea descresc?toare a salariului. Angaja?ii
 care au acela?i salariu vor fi afi?a?i în ordinea descresc?toare a comisionului.
*/
select first_name, last_name, salary from employees order by salary, commission_pct desc;

/* exercitiul 3
 S? se stabileasc? daca valorile null ale unei expresii "exp" sunt plasate la începutul 
 sau la sfâr?itul unei liste ordonate dup? valoarea "exp". Pentru a modifica modul implicit 
 de ordonare a valorilor null se poate folosi clauza NULLS FIRST sau NULLS LAST.
 COMM: ambiguos task. i don't understand what does it expect to do
*/

/* exercitiul 4 
 S? se afi?eze numele, titlul jobului, salariul ?i comisionul pentru angaja?ii care câ?tig?
 un comision mai mare de 20% din salariu. S? se ordoneze rezultatul dup? valoarea venitului 
 (commission_pct * salary + salary).
*/
select first_name, job_id, salary, commission_pct, (commission_pct * salary + salary) "Indice ordine"
from employees where commission_pct * salary > ( salary / 5 ) order by (commission_pct * salary + salary);

/* exercitiul 5
 S? se afi?eze angaja?ii în ordinea cresc?toare a vechimii
 */
select * from employees order by (sysdate - hire_date);

/* exercitiul 7
 S? se afi?eze pentru fiecare angajat numele, codul ?i denumirea departamentului ?i titlul func?iei actuale. 
*/
select first_name, e.department_id, department_name, job_id from employees e, departments d where e.department_id = d.department_id;

/* ALL TABLES */
select * from departments;
select * from employees;
select * from jobs;
select * from job_history;
select * from locations;
/* */

/* exercitiul 8
 S? se listeze titlurile job-urilor atribuite angaja?ilor care lucreaz? în departamentul 30.
*/
select first_name, job_title, department_id from employees e, jobs j where e.job_id = j.job_id and department_id = 30;

/* exercitiul 9
 S? se afi?eze numele angajatului, numele departamentului ?i ora?ul pentru to?i angaja?ii care câ?tig? comision.
*/
select e.first_name || ' ' || e.last_name "Nume angajat", d.department_name, l.city from employees e, departments d, locations l where 
e.department_id = d.department_id and d.location_id = l.location_id;

/* exercitiul 10
 S? se afi?eze numele salariatului ?i numele departamentului pentru to?i salaria?ii care au litera A inclus? în nume.
 */
 select e.first_name || ' ' || e.last_name "Nume salariat", d.department_name from employees e, departments d 
 where e.department_id = d.department_id and e.last_name like '%A%';
 
 /* exercitiul 11
 S? se afi?eze numele ?i denumirea jobului actual pentru angaja?ii care au avut func?ia de 'Stock Clerk'. 
 */
select e.first_name || ' ' || e.last_name "Nume angajat", j.job_title 
from employees e, jobs j, job_history jh, jobs j2 
where e.job_id = j.job_id and e.employee_id = jh.employee_id 
and j2.job_id = jh.job_id and j2.job_title = 'Stock Clerk';

/* exercitiul 12
 S? se afi?eze pentru fiecare departament denumirea, numele ?efului ?i titlul jobului acestuia.
*/
select e.first_name, d.department_name, j.job_title 
from employees e, departments d, jobs j 
where e.employee_id = d.manager_id and e.job_id = j.job_id;

/* exercitiul 15
 S? se afi?eze denumirea ?i ora?ul  departamentelor în care lucreaz? salaria?i care au fost 
 angaja?i dup? 03-Jan-1990.
*/
select d.department_name, l.city from employees e, departments d, locations l 
where d.location_id = l.location_id and e.department_id = d.department_id 
and e.hire_date > to_date('03-Jan-1990', 'dd-mon-yyyy');

/* exercitiul 16
 S? se afi?eze data curent? în fomatul ”zi – lun? – an ora:minut”.
*/
select to_char(sysdate, 'dd-mon-yyyy HH24:MI') "Data curenta" from dual;

/* exercitiul 17
 S? se afi?eze numele , job-ul ?i data la care au început lucrul salaria?ii 
 angaja?i între 20 Februarie 1987 ?i 1 Mai 1989.
*/
select e.first_name || ' ' || e.last_name "Nume angajat", j.job_title, jh.start_date 
from employees e, jobs j, job_history jh
where e.job_id = j.job_id and j.job_id = jh.job_id and e.job_id = jh.job_id
and e.hire_date > to_date('20-feb-1987', 'dd-mon-yyyy') and 
e.hire_date < to_date('01-may-1989', 'dd-mon-yyyy');
