SELECT  MAX(salary) "Maxim", MIN(salary) "Minim", SUM(salary) "Suma", AVG(salary) "Media" FROM employees; 
/* exercitiul 4
 S? se modifice cererea anterioar? pentru a se afi?a minimul, maximul, suma ?i 
 media salariilor pentru fiecare job. 
*/
SELECT  MAX(salary) "Maxim", MIN(salary) "Minim", SUM(salary) "Suma", AVG(salary) "Media" 
FROM employees group by job_id;

/* exercitiul 5
 Scrie?i o cerere pentru a se afi?a numele departamentului, loca?ia, num?rul de 
 angaja?i ?i salariul mediu pentru angaja?ii din acel departament. Coloanele vor 
 fi etichetate corespunz?tor.
*/
select d.department_name, l.city, count(employee_id), avg(salary) from employees e join departments d
on e.department_id = d.department_id join locations l on d.location_id = l.location_id
group by e.department_id, d.department_name, l.city;

/* exercitiul 6
 Pentru fiecare ?ef, s? se afi?eze codul s?u ?i salariul celui mai prost platit 
 subordonat. Se vor exclude cei pentru care codul managerului nu este cunoscut. 
 De asemenea, se vor exclude grupurile în care salariul minim este mai mic de 1000$. 
 Sorta?i rezultatul în ordine descresc?toare a salariilor.
 COMM : the value is set to 3000, because there's nobody with salary under 1000$.
*/
select manager_id, min(salary) from employees group by manager_id
having manager_id is not null and min(salary) > 3000;

/* exercitiul 7
 Care este salariul mediu minim al job-urilor existente? Salariul mediu al unui 
 job va fi considerat drept media aritmetic? a salariilor celor care îl practic?. 
*/
select min(avg(salary)) from employees group by job_id;

/* exercitiul 8
 Managerul companiei are nevoie de urmatoarele informatii: numele, prenumele, 
 num?rul de telefon ?i emailul celor care lucreaza in acelasi oras cu el. Pentru 
 fiecare angajat din lista doreste sa ?tie ?i num?rul de angajati din subordine. 
 Nu este interesat sa afle propriul email si nu este interesat de cei care conduc 
 direct mai putin de 5 salariati
*/
select et.employee_id, et.first_name, et.last_name, et.phone_number, et.email,
(select count(employee_id) from employees_tib where manager_id = et.employee_id) "Nr. subordonati"
from employees_tib et join departments d on
et.department_id = d.department_id join locations l on d.location_id = l.location_id 
where l.city = (select l.city from locations l join departments d on l.location_id = d.location_id 
                where d.manager_id = 
                    (select employee_id from employees_tib where manager_id is null and department_id is not null)) 
and et.employee_id != (select employee_id from employees_tib where manager_id is null and department_id is not null);

/* exercitiul 9
 S? se ob?ina codul, titlul ?i salariul mediu al job-ului pentru care salariul 
 mediu este minim.
*/
select e.job_id, j.job_title, avg(salary) from employees e join jobs j on 
e.job_id = j.job_id group by e.job_id, j.job_title having 
avg(salary) = (select min(avg(salary)) from employees group by job_id);

/* exercitiul 10
 S? se ob?in? numele angaja?ilor care lucreaza în departamentul cu cea mai mare 
 medie a salariilor. 
*/
select first_name, last_name from employees where department_id in
(select e.department_id from employees e join departments d on e.department_id = d.department_id
group by e.department_id, d.department_name
having round(avg(e.salary),2) = (select round(max(avg(salary)),2) medie from employees group by department_id)
);

/* exercitiul 11
 S? se afi?eze codul si numele angajatului, numele departamentului ?i suma salariilor pe departamente. 
*/
select e.employee_id, e.first_name, e.last_name, d.department_name,
(select sum(e2.salary) from employees e2 where e2.department_id = e.department_id) "suma" 
from employees e join departments d on e.department_id = d.department_id;

/* exercitiul 12
S? se afi?eze pentru fiecare angajat numele, salariul ?i salariul mediu al celor care au acela?i ?ef direct cu el.
*/
select e.first_name, e.last_name, e.salary, (select avg(salary) from employees e2 group by e2.manager_id 
having e2.manager_id = e.manager_id) "Salariu mediu" from employees e;                           

/* exercitiul 13
Afisati pentru fiecare salariat urmatoarele informatii: 
– durata primului job (daca nu a avut anterior alt job se va considera jobul actual) 
exprimat? în numarul de luni lucrate; 
– numarul joburilor avute anterior.
*/
select e.employee_id, count(start_date),  
  case when count(start_date) = 0 then months_between(sysdate,e.hire_date) 
                                                         else primelej.durata end durata
from employees e, job_history jh,    
                        (select   employee_id,months_between(end_date,start_date) durata
                         from job_history jh
                          where start_date = (select min(start_date) 
                                   from job_history 
                                  where employee_id = jh.employee_id)   ) primelej
where e.employee_id = jh.employee_id(+) and e.employee_id = primelej.employee_id(+)
group by e.employee_id, primelej.durata, e.hire_date;

/* exercitiul 14
S? se determine num?rul angaja?ilor care nu câ?tig? comision. 
*/
select count(employee_id) from employees where commission_pct is null;

/* exercitiul 15
S? se determine num?rul de manageri din fiecare departament. Eticheta?i coloana “Nr. Manageri”. 
*/
select department_id, count(employee_id)"Nr. Manageri" from employees e where employee_id in 
(select manager_id from employees where manager_id = e.employee_id) group by department_id;

/* exercitiul 16
Scrie?i o cerere pentru a afi?a job-ul, salariul total pentru job-ul respectiv pe 
departamentele 10, 20 ?i 30, respectiv salariul total pentru job-ul respectiv pe 
toate departamentele. Se vor eticheta coloanele corespunz?tor.
*/


/* exercitiul 17
S? se creeze o cerere prin care s? se afi?eze num?rul total de angaja?i ?i, din 
acest total, num?rul celor care au fost angaja?i în 1997, 1998, 1999 si 2000. 
Denumiti capetele de tabel in mod corespunzator. 
*/


/* exercitiul 18
Obtineti pentru fiecare angajat  urmatoarele informatii: 
– numele sau; 
– numarul de departamente pe care le conduce si in care lucreaza mai putin de 10 angajati 
– numarul de departamente pe care le conduce si in care lucreaza mai mult de 10 angajati. 
*/


/* exercitiul 19
 Afisati un tabel cu numele angajatilor stabilindu-se pentru fiecare angajat daca a fost    
 promovat/penalizat/a pastrat nivelul. Se considera ca un angajat a fost promovat daca 
 media dintre min_salary si max_salary  pentru ultimul job detinut anterior este mai mica 
 decat media dintre min_salary si  max_salary pentru jobul detinut in prezent. 
 Se vor afisa si angajatii care nu au schimbat jobul.
*/


/* exercitiul 21
S? se determine departamentele în care nu exist? nici un angajat. 
Utiliza?i NOT EXISTS. Propune-?i alte variante de rezolvare. 
*/
select d.department_name from departments d where not exists
(select department_id from employees where department_id = d.department_id);

/* exercitiul 22
S? se afi?eze numele departamentelor în care lucreaz? cel pu?in un angajat 
care are salariul > 5000. 
*/
select d.department_name from departments d where exists 
(select employee_id from employees where salary > 5000 and d.department_id = department_id);

/* exercitiul 23
 S? se afi?eze numele angaja?ilor care au lucrat cel pu?in în toate departamentele 
 în care a lucrat angajatul cu codul 206.
*/


/* exercitiul 24
a. S? se afi?eze numele angaja?ilor care au lucrat cel pu?in la acelea?i proiecte 
    la care a lucrat angajatul cu codul 202. 
b. S? se afi?eze numele angaja?ilor care au lucrat cel mult la acelea?i proiecte 
    la care a lucrat angajatul cu codul 202. 
c. S? se afi?eze numele angaja?ilor care au lucrat cel exact la acelea?i proiecte 
    la care a lucrat angajatul cu codul 202.
*/