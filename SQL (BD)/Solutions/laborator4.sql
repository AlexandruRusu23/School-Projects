/* some usefull requests */
select * from countries;
select * from locations;

select l.city, l.country_id, c.country_name from countries c, locations l
where l.country_id = c.country_id;

SELECT last_name, job_id, job_title FROM employees NATURAL JOIN jobs;

select last_name, d.department_id
from employees e
RIGHT OUTER JOIN departments d
ON (e.department_id = d.department_id);

select last_name, d.department_id from employees e
join departments d on (e.department_id = d.department_id);

select last_name, d.department_id
from employees e
LEFT OUTER JOIN Departments d
ON e.department_id = d.department_id;

/* exercitiul 5
 S? se afi?eze numele ?i titlul job-ul tuturor angaja?ilor din departamentul 'Sales'. 
 (varianta join-ului conform standardului SQL99) 
*/
select e.first_name, e.last_name, j.job_title from employees e 
 join jobs j on (e.job_id = j.job_id) 
 join departments d on (e.department_id = d.department_id)
where d.department_name = 'Sales';

/* exercitiul 6
 S? se afi?eze codul departamentului, numele departamentului, numele ?i job-ul 
 tuturor angaja?ilor din departamentele din 'Seattle'. De asemenea, se va lista 
 salariul angaja?ilor, în formatul '$99,999.00'. 
*/
select d.department_id, d.department_name, e.first_name, e.last_name, to_char(e.salary, '$99,999.00' ) "Salariu", j.job_title
from employees e join departments d on e.department_id = d.department_id
join jobs j on j.job_id = e.job_id join locations l on d.location_id = l.location_id
where l.city = 'Seattle';

/* exercitiul 7
 Scrieti o cerere pentru a se afi?a numele, luna (în litere) ?i anul angaj?rii pentru 
 to?i salaria?ii din acela?i departament cu Gates, al c?ror nume con?ine litera 'a'. 
 Se va exclude Gates. Se vor da 2 solu?ii pentru determinarea apari?iei literei 'A' 
 în nume. De asemenea, pentru una din metode se va da ?i varianta join-ului conform 
 standardului SQL99. 
*/
select e.first_name, e.last_name, to_char(e.hire_date, 'mm-yyyy') "Hire date"
from employees e join departments d on e.department_id = d.department_id
where e.department_id = (select department_id from employees where last_name = 'Gates')
and lower(e.first_name) like '%a%';

select e.first_name, e.last_name, to_char(e.hire_date, 'mm-yyyy') "Hire date"
from employees e, departments d where e.department_id = d.department_id
and e.department_id = (select department_id from employees where last_name = 'Gates')
and instr(e.first_name, 'a') != 0;

/* exercitiul 8
 S? se afi?eze codul ?i numele angaja?ilor care au început s? lucreze într-un 
 departament în care cel pu?in un alt angajat avea deja o vechime de 2 luni.  
 Se vor afi?a, de asemenea, codul ?i numele departamentului respectiv. 
*/
select e.employee_id, e.first_name, e.last_name, e.hire_date, d.department_id, d.department_name
from employees e join departments d on e.department_id = d.department_id
where abs(months_between((select min(hire_date) from employees where department_id = e.department_id), e.hire_date)) >= 2;

/* exercitiul 9
Sa se afiseze numele, salariul, titlul job-ului, ora?ul ?i ?ara în care lucreaz? 
angajatii condusi direct de King. 
COMM : There are two Kings :)) Steven and Janette
*/
select e.first_name, e.last_name, e.salary, j.job_title, l.city, c.country_name
from employees e join jobs j on e.job_id = j.job_id
join departments d on e.department_id = d.department_id
join locations l on l.location_id = d.location_id
join countries c on c.country_id = l.country_id
join employees e2 on e2.employee_id = e.manager_id
where e.manager_id = e2.employee_id and e2.last_name = 'King' or e2.first_name = 'King';

/* exercitiul 10
 S? se afi?eze numele departamentelor ?i numele managerilor acestora. Se vor afi?a
 ?i departamentele care nu au manageri. Pentru acestea coloana Manager va con?ine 
 textul "necunoscut" (left outer join, 2 variante) 
*/
select d.department_name, case when e.last_name is null then 'necunoscut'
else e.first_name || ' ' || e.last_name end "Nume manager" from departments d left outer join
employees e on d.manager_id = e.employee_id;

select d.department_name,case when e.last_name is null then 'necunoscut'
else e.first_name || ' ' || e.last_name end "Nume manager" from departments d,
employees e where d.manager_id = e.employee_id (+);

/* exercitiul 11
 S? se afi?eze numele salaria?ilor ?i ora?ele în care lucreaz?. Se vor afi?a ?i 
 salaria?ii pentru care nu este cunoscut departamentul.
*/
select e.first_name, e.last_name, e.department_id, l.city from employees e left join 
departments d on e.department_id = d.department_id left join locations l on
d.location_id = l.location_id;

/* exercitiul 12
 S? se afi?eze numele salaria?ilor ?i informa?ii despre joburile avute anterior 
 de ace?tia (titlu, salariu minim posibil). Dac? salariatul este la primul job 
 se va afi?a jobul actual.
*/
select e.last_name, decode(j.job_id, null, jact.job_title, j.job_title) "titlu job",
 decode(j.job_id, null, jact.min_salary, j.min_salary) "salariu minim"
from employees e left join job_history jh on e.employee_id = jh.employee_id
left join jobs j on jh.job_id = j.job_id 
join jobs jact on e.job_id = jact.job_id;

/* usefull example */
SELECT employee_id, last_name, department_id, TO_CHAR(NULL) nume 
FROM employees UNION SELECT TO_NUMBER(NULL), null, department_id, department_name 
FROM departments ORDER BY 3, nume;

/* exercitiul 17
 S? se afiseze media venitului tuturor angaja?ilor si media venitului salaria?ilor 
 angaja?i în anul 2000. S? se rotunjeasc? mediile la dou? zecimale. Cele dou? 
 linii rezultat vor include textele ‘medie’ respectiv ‘medie 2000’. Observa?i modul 
 în care este ordonat rezultatul. S? se atribuie unicei coloane rezultat un titlu potrivit.
*/
select round(avg(salary + salary * commission_pct),2) || ' medie' "Salarii medii" from employees
union
select round(avg(salary + salary * commission_pct),2) || ' medie 2000' from employees where to_char(hire_date,'yyyy') = '2000';

/* exercitiul 18
 S? se afiseze numele departamentelor ?i numele angaja?ilor. Se vor afisa ?i 
 departamenntele în care nu lucreaz? nimeni si angaja?ii care nu lucreaz? în nici 
 un departament (full outer join). Se va utiliza UNION. 
*/
select d.department_name, e.first_name, e.last_name from employees e full join departments d
on e.department_id = d.department_id;

select department_name, to_char(null) "Nume angajat" from departments
union 
select null, first_name from employees;

/* exercitiul 19
 Folosind INTERSECT s? se afiseze codul departamentului si numele departamentului 
 pentru departamentele din orasul Seattle, coduse de un angajat al c?rui salariu 
 este mai mare decât 7000. 
*/
select department_id, department_name from departments d join locations l on d.location_id = l.location_id where l.city = 'Seattle'
intersect
select d.department_id, d.department_name from employees e join departments d on e.department_id = d.department_id where e.salary > 7000;

/* exercitiul 20
 S? se af??eze denumirile joburilor pe care nu le-a avut ?eful departamentului „Administration”. 
*/
select j.job_title from jobs j
minus
select j.job_title from jobs j join job_history jh on j.job_id = jh.job_id 
join departments d on jh.employee_id = d.manager_id
where d.department_name = 'Administration';

/* exercitiul 21
 S? se afi?eze codurile ?i numele ?efilor de departament care au mai avut cel 
 pu?in un job anterior. 
*/
select unique e.employee_id, e.first_name from employees e join departments d on e.employee_id = d.manager_id
join job_history jh on jh.employee_id = d.manager_id;

/* exercitiul 22
 S? se ob?ina o list? cu istoricul func?iilor avute de angaja?i (se va utiliza 
 tabelul job_history). Tabelul va con?ine urm?toarele coloane: codul angajatului, 
 numele angajatului, titlul jobului avut, numele departamentului în care a lucrat 
 în timpul cât a de?inut func?ia respectiv?, perioada în care a ocupat pozi?ia 
 respectiv? exprimat? în num?r întreg de luni. Coloana "perioada" va con?ine null, 
 în cazul func?iilor de?inute în prezent de angaja?i. Ordona?i rezultatul dupa 
 numele angajatului.  
*/
select e.employee_id, e.first_name, j.job_title, d.department_name, 
case when e2.job_id = jh.job_id then null else round(abs(months_between(jh.start_date, jh.end_date)),2) end "perioada" 
from employees e join jobs j on e.job_id = j.job_id join departments d on e.department_id = d.department_id
join job_history jh on j.job_id = jh.job_id join employees e2 on e2.employee_id = jh.employee_id
order by e.first_name;