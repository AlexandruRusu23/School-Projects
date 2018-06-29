/* exercitiul 1
 S? se afi?eze pentru angaja?ii cu prenumele Steven, codul, numele ?i denumirea 
 departamentului în care lucreaz?. C?utarea trebuie s? nu fie case-sensitive, 
 iar eventualele blank-uri care preced sau urmeaz? numelui trebuie ignorate.
*/
select e.first_name || ' ' || e.last_name, d.department_id, d.department_name
from employees e, departments d where e.department_id = d.department_id
and upper(e.first_name) like '%STEVEN%';

/* exercitiul 2
 Scrie?i o cerere care are urm?torul rezultat pentru fiecare angajat: <titlu job> 
 <prenume angajat> <nume angajat> castiga <salariu> lunar dar doreste <salariu 
 de 3 ori mai mare>. Eticheta?i coloana 'Salariu ideal'. Pentru concatenare, 
 utiliza?i atât func?ia CONCAT cât ?i operatorul ||. 
*/
select j.job_title || ' ' || e.first_name || ' ' || e.last_name || ' castiga ' || 
e.salary || ' lunar, dar doreste ' || 3*e.salary "Salariu Ideal"
from employees e, jobs j where e.job_id = j.job_id;

select concat(j.job_title,concat(' ',concat(e.first_name, concat(' ', 
concat(e.last_name, concat(' castiga ',concat(e.salary,
concat(' lunar, dar doreste ',3*e.salary)))))))) "Salariu Ideal"
from employees e, jobs j where e.job_id = j.job_id;

/* exercitiul 3
 Scrie?i o cerere prin care s? se afi?eze prenumele salariatului cu prima litera 
 majuscul? ?i toate celelalte litere minuscule, numele acestuia cu majuscule ?i 
 lungimea numelui, pentru angaja?ii al c?ror nume începe cu J sau M sau care au
 a treia liter? din nume A. Rezultatul va fi ordonat descresc?tor dup? lungimea 
 numelui. Se vor eticheta coloanele corespunz?tor. Se cer 2 solu?ii (cu operatorul 
 LIKE ?i func?ia SUBSTR). 
*/
select initcap(e.first_name) "Prenume", upper(e.last_name) "Nume", length(e.last_name) "Lungime nume" 
from employees e
where upper(e.last_name) like 'J%' or upper(e.last_name) like 'M%' 
or upper(e.last_name) like '__A%' order by length(e.last_name) desc;

select initcap(e.first_name) "Prenume", upper(e.last_name) "Nume", length(e.last_name) "Lungime nume" 
from employees e
where substr(e.last_name, 1, 1) = 'J' or substr(e.last_name, 1, 1) = 'M' 
or upper(substr(e.last_name, 3, 1)) = 'A';

/* exercitiul 4
 S? se afi?eze pentru to?i angaja?ii al c?ror nume se termin? cu litera 'e', 
 codul, numele, lungimea numelui ?i pozi?ia din nume în care apare prima dat? 
 litera 'a'. Utiliza?i alias-uri corespunz?toare pentru coloane.
*/
select e.employee_id "Nr. crt.", e.last_name "Nume angajat", length(e.last_name) "Lungime nume", 
instr(e.last_name,'a') "Prima aparitie a lui 'a'" from employees e where substr(e.last_name, -1) = 'e';

/* exercitiul 5
 S? se afi?eze numele ?i data angaj?rii salaria?ilor precum ?i o coloan? care 
 va con?ine c?te un caracter '*' pentru fiecare 1000 zile lucrate.
*/
select e.first_name, e.last_name, e.hire_date, RPAD(' ',( floor((sysdate - e.hire_date) / 1000) ),'*') "Zile lucrate" 
from employees e 
where floor((sysdate - e.hire_date) / 1000) > 0;

/* exercitiul 6
 S? se afi?eze codul salariatului, numele, salariul, salariul m?rit cu 15%, 
 exprimat cu dou? zecimale ?i num?rul de sute al salariului nou rotunjit la 2 
 zecimale. Eticheta?i ultimele dou? coloane 'Salariu nou', respectiv 'Numar sute'. 
 Se vor lua în considerare salaria?ii al c?ror salariu nu este divizibil cu 1000. 
*/
select e.employee_id, e.first_name, e.last_name, e.salary, round(e.salary*3/20, 2) "Salariu nou",
round(mod(e.salary*3/20, 100) / 10, 2) "Numar sute"
from employees e where mod(e.salary, 1000) not in (0);

/* exercitiul 7
 S? se afi?eze numele ?i prenumele angajatului (într-o singur? coloan?), data 
 angaj?rii ?i data negocierii salariului, care este prima zi de Luni dup? 6 luni 
 de serviciu. Eticheta?i aceast? coloan? 'Negociere'. 
*/
select e.last_name || ' ' || e.first_name "Nume angajat", e.hire_date, 
next_day(e.hire_date + 180,'monday') "Negociere" from employees e; 

/* exercitiul 8
 S? se afi?eze data urm?toarei zile de Vineri de peste 3 luni în formatul zi_lun?,
 denumire_lun?, zi_saptaman?, minut, ora.
*/
select to_char(next_day(sysdate + 90, 'friday'), 'dd-mon-day MI:HH24') from dual;

/* exercitiul 9
 Pentru fiecare angajat s? se afi?eze numele ?i num?rul de luni de la data angaj?rii. 
 Eticheta?i coloana 'Luni lucrate'. S? se ordoneze rezultatul dup? num?rul de luni
 lucrate. Se va rotunji num?rul de luni la cel mai apropiat num?r întreg. 
*/
select e.last_name, e.first_name, floor(months_between(sysdate, e.hire_date)) "Luni lucrate"
from employees e order by "Luni lucrate";

/* exercitiul 11
 S? se afi?eze data (numele lunii, ziua, anul, ora, minutul ?i secunda) de peste 30 zile. 
*/
select to_char(sysdate + 30, 'mon-dd-yyyy HH24:MI:SS') from dual;

/* exercitiul 12
 S? se afi?eze num?rul de zile r?mase pân? la sfâr?itul anului. 
*/
select round(abs(to_date('01-jan-2017', 'dd-mon-yyyy')-sysdate),2) "Zile pana la sf. anului" from dual;

/* exercitiul 13
 S? se afi?eze data 
a) de peste 12 ore (12/24) 
b) data de peste 5 minute. (1/288).
*/
select to_char(sysdate + 1/2, 'dd-mon-yyyy HH24:MI:SS') from dual;
select to_char(sysdate + 1/288, 'dd-mon-yyyy HH24:MI:SS') from dual;

/* exercitiul 14
 S? se listeze numele, salariul ?i comisionul tuturor angaja?ilor al c?ror venit lunar dep??e?te 10000$. 
*/
select e.first_name, e.last_name, e.salary, e.commission_pct*e.salary + e.salary "Comision"
from employees e
where e.salary > 10000;

/* exercitiul 15
 S? se afi?eze numele angaja?ilor ?i comisionul. Dac? un angajat nu câ?tig? comision, 
 s? se scrie 'Fara comision'. Eticheta?i coloana 'Comision'.
*/
select e.first_name, e.last_name,
nvl( to_char(e.commission_pct*e.salary + e.salary ),'Fara comision') "comision"
from employees e;

/* exercitiul 17
 S? se afi?eze codul, numele ?i ora?ul pentru toate departamentele. Primele departamente 
 afi?ate vor fi cele din Seattle, care vor aparea in lista ordonate alfabetic dupa nume. 
 Restul departamentelor vor fi ordonate dupa numele ora?ului, ordinea departamentelor din
 acela?i ora? fiind cea alfabetica. 
 
 Modifica?i cererea de mai sus astfel încât s? se afi?eze ?i colona manager. 
 Dac? pentru un departament nu este cunoscut managerul coloana 
 manger va con?ine textul “manager necunoscut”. 
*/
select d.department_id, d.department_name, l.city from departments d, locations l
where d.location_id = l.location_id order by case when l.city = 'Seattle' then 1 else 2 end, l.city, d.department_name;

select d.department_id, d.department_name, l.city, e.last_name, e.first_name, d.manager_id
from departments d, locations l, employees e
where d.location_id = l.location_id and d.manager_id = e.employee_id 
order by case when l.city = 'Seattle' then 1 else 2 end, l.city, d.department_name;

/* exercitiul 18
 S? se afi?eze numele angajatilor, titlul jobului (job_title), numele departamentului 
 în care lucreaza si coloana "spor de vechime" calculat? astfel: 
 daca x >0 si x< 100: x*10 daca x>100: x*5 x este un numar intreg care reprezinta 
 numarul de luni lucrate pana la data de '01-01-2000'. Dac? salariatul a fost 
 angajat dup? aceast? dat?, sporul este 0. 
*/
select e.first_name, e.last_name, j.job_title, d.department_name, 
case
  when abs(months_between(e.hire_date, to_date('01-01-2000', 'dd-mm-yyyy'))) < 100 
  then round(abs(months_between(e.hire_date, to_date('01-01-2000', 'dd-mm-yyyy'))) * 10, 2)
  else round(abs(months_between(e.hire_date, to_date('01-01-2000', 'dd-mm-yyyy'))) * 5, 2)
  end "Spor de vechime"
from employees e, jobs j, departments d where
e.job_id = j.job_id and d.department_id = e.department_id;

/* exercitiul 19
 S? se afi?eze numele angaja?ilor ?i coloana id are se con?in? codul angajatului 
 concatenat cu codul departamentului dac? este cunoscut codul departamentului, 
 sau codul angajatului daca nu este ?tiut departamentul. 
*/
select e.first_name, e.last_name,
case
  when e.department_id is not null
  then to_char ( e.employee_id || e.department_id )
  else to_char ( e.employee_id )
  end "ID"
from employees e;

/* exercitiul 21
 S? se ob?in? media salariilor angaja?ilor rotunjit? la 2 zecimale pentru 
 angaja?ii care ca?tig? comision.
*/
select round(avg(e.salary),2) from employees e where e.commission_pct is not null;
