/* exercitiul 1
 S? se determine codul angaja?ilor, codul job-urilor si numele 
 celor al c?ror salariu este mai mare decât 3000 sau este egal cu media dintre 
 salariul minim si cel maxim pentru job-ul respectiv.
*/
select employee_id, job_id, first_name, salary from employees extern where salary > 3000 or
salary = (select (min(salary)+max(salary))/2 from employees where job_id = extern.job_id); 

/* exercitiul 2
S? se afiseze numele, numele departamentul, salariul si job-ul tuturor angaja?ilor 
al c?ror salariu si comision coincid cu salariul si comisionul unui angajat din Oxford. 
*/
select e.first_name, d.department_name, e.salary, j.job_title from employees e 
join departments d on e.department_id = d.department_id
join jobs j on e.job_id = j.job_id where (salary,commission_pct) in 
    (select e2.salary, e2.commission_pct from employees e2 join departments d on e2.department_id = d.department_id join locations l on
     d.location_id = l.location_id where l.city = 'Oxford' and e2.salary = e.salary and e2.commission_pct=e.commission_pct);

/* exercitiul 3
Scrie?i o cerere pentru a afisa numele, codul departamentului ?i salariul angaja?ilor 
al c?ror num?r de departament si salariu coincid cu num?rul departamentului ?i 
salariul unui angajat care câstig? comision. 
*/
select e.first_name, e.last_name, e.department_id, e.salary from employees e
where (e.department_id, e.salary) in 
  (select department_id, salary from employees where commission_pct is not null);
  
/* exercitiul 4
 Folosind subcereri, s? se afiseze numele si salariul angaja?ilor condusi direct 
 de presedintele companiei (acesta este considerat angajatul care nu are manager).
*/
select first_name, last_name, salary from employees where manager_id in 
(select employee_id from employees where manager_id is null);

/* exercitiul 5
 Scrie?i o cerere pentru a afisa numele, numele departamentului si salariul 
 angaja?ilor care nu câstig? comision, dar al c?ror sef direct coincide cu seful 
 unui angajat care câstig? comision. 
*/
select e.first_name, e.last_name, d.department_name, e.salary from employees e join
departments d on e.department_id = d.department_id where e.commission_pct is null 
and e.manager_id in (select e2.employee_id from employees e join employees e2 on e.manager_id = e2.employee_id
where e.commission_pct is not null);

/* exercitiul 6
S? se afiseze numele si salariul angaja?ilor al c?ror salariu este maxim. Folosi?i >=ALL 
*/
select e.first_name, e.last_name, e.salary from employees e where e.salary >= 
  all (select e.salary from employees e where salary is not null);

/* exercitiul 7
S? se afle dac? exist? angaja?i care nu lucreaz? în departamentul ‘Sales’ ?i al 
c?ror salariu ?i comision coincid cu salariul ?i comisionul unui angajat din departamentul ‘Sales’. 
*/
select e.first_name, e.last_name from employees e join departments d on e.department_id 
= d.department_id where d.department_name != 'Sales' and e.salary is not null and e.commission_pct is not null 
  and (e.salary, e.commission_pct) in
 (select e.salary, e.commission_pct from employees e join departments d on e.department_id = 
  d.department_id where d.department_name = 'Sales' and e.commission_pct is not null and e.salary is not null);

/* exercitiul 8
 S? se afiseze salaria?ii care au acelasi manager ca si angajatul având codul 140. 
*/
select e.last_name, e.first_name from employees e where manager_id = 
   (select manager_id from employees where employee_id = 140);
  
select e.last_name, e.first_name from employees e join employees e2 
on e.manager_id = e2.manager_id where e.manager_id = e2.manager_id and e2.employee_id = 140; 

/* exercitiul 9
S? se afiseze numele departamentelor din America. 
*/
select d.department_name from departments d where 
     d.location_id in (select l.location_id from locations l where 
          l.country_id in (select country_id from countries where country_name = 'United States of America'));
          
/* exercitiul 10
S? se ob?in? numele salaria?ilor având cea mai mare vechime din departamentul în care lucreaz?
*/
select e.first_name, e.last_name, e.department_id, e.hire_date from employees e where 
e.hire_date <= ALL (select e2.hire_date from employees e2 where e.department_id = e2.department_id) 
and e.department_id is not null; 

/* exercitiul 11
S? se afiseze numele, job-ul si salariul celor mai prost pl?ti?i angaja?i din fiecare departament. 
*/
select e.first_name, j.job_title, e.salary from employees e join jobs j on e.job_id = j.job_id 
where salary <= all ( select e2.salary from employees e2 where e2.department_id = e.department_id)
and salary is not null;

/* exercitiul 12
S? se afiseze numele, prenumele si salariul angaja?ilor care lucreaz? în acelasi departament 
în care lucreaz? seful lor direct. 
*/
select e.first_name, e.last_name, e.salary from employees e
where e.department_id = ( select e2.department_id from employees e2 where e2.employee_id = e.manager_id);

/* exercitiul 13
S? se ob?in? codurile si numele departamentelor în care nu lucreaz? nimeni.
*/
select d.department_id, d.department_name from departments d where d.department_id not in
(select department_id from employees where department_id = d.department_id);

/* exercitiul 14
S? se ob?in? salaria?ii care nu au subordona?i (care nu sunt manageri). (Utiliza?i NOT IN)
*/
select e.first_name, e.last_name from employees e where 
e.employee_id not in (select manager_id from employees where e.employee_id = manager_id);

/* exercitiul 15
S? se afiseze codul, numele, prenumele angajatilor care îndeplinesc una dintre condi?iile urm?toare 
-în departamentul în care lucreaz? în prezent a ocupat o func?ie diferit? de cea actual? 
-func?ia pe care o ocup? în prezent a ocupat-o si în alt departament, diferit de cel actual.
*/
select e.employee_id, e.last_name, e.first_name, e.job_id from employees e where e.job_id in
    (select job_id from job_history where department_id != e.department_id and employee_id = e.employee_id)
    or e.department_id in
    (select jh.department_id from job_history jh where e.job_id != jh.job_id and e.department_id = jh.department_id);
    
/* exercitiul 16
S? se afi?eze numele ?i jobul primilor angaja?i din companie, în ordinea descresc?toare a salariului 
*/
select first_name, job_id, salary, hire_date from (select first_name, job_id, hire_date, salary 
from employees where salary is not null) order by hire_date, salary desc;

/* exercitiul 17
 S? se ob?ina media salariului noilor veniti (ultimii 10 angajati). 
*/
select avg(salary) from (select salary from employees where rownum <=10 order by hire_date desc );

/* exercitiul 18
S? se ob?ina diferen?a de vechime (numar de luni) dintre al 10 ultim angajat si primul angajat din companie.
*/
select unique 
    round(abs(months_between((select hire_date from (select hire_date from employees order by hire_date ) 
                              where rownum <= 1),
    (select hire_date from (select hire_date from (select hire_date from employees order by hire_date desc) 
                            where rownum <= 10 order by hire_date) where rownum <= 1))),2) 
"Luni diferenta" from employees;

/* exercitiul 19
S? se ob?in? ierarhia bazat? pe rela?ia angajat – manager considerând angajatul 
cu codul 100 ca r?d?cin? (clauza START WITH). S? se ordoneze dup? lungimea drumului 
de la r?d?cin? la fiecare nod (pseudocoloana LEVEL).
*/
select employee_id, first_name, last_name, manager_id, level from employees start with 
employee_id = 100 connect by prior employee_id = manager_id order by level desc;

/* exercitiul 20
Scrie?i o cerere ierarhic? pentru a afi?a codul salariatului, codul managerului ?i 
numele salariatului, pentru angaja?ii care sunt cu 2 niveluri sub De Haan. Afi?a?i, 
de asemenea, nivelul angajatului în ierarhie. 
*/
select employee_id, manager_id, first_name from employees;

/* exercitiul 21
S? se afi?eze codul, numele ?i salariul angajatului înso?it de codul managerului s?u, 
pentru angaja?ii al c?ror salariu este mai mic decât 15000. Se va considera ca 
r?d?cin? salariatul având codul 206. S? se indenteze rezultatul pentru a se sugera 
nivelul pe care se afl? în arbore fiecare linie. 
*/


/* exercitiul 22
S? se afi?eze pentru fiecare angajat to?i superiorii s?i pornind de la managerul 
general. Angaja?ii subordona?i aceluia?i manager vor fi  ordona?i dup? salariu.
*/


/* exercitiul 23
S? se afi?eze codul, numele ?i salariul angajatului înso?it de codul managerului 
s?u, începând cu angajatul al c?rui cod este maxim. 
*/


/* exercitiul 24
S? se ob?in? ierarhia bazat? pe rela?ia angajat – manager considerând ca r?d?cin?, 
angajatul care are cel mai mare salariu.
*/ 

