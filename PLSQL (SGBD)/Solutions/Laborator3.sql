declare
  v_nr number(4);
  v_nume departments.department_name%type;
  cursor c is
    select department_name nume, count(employee_id) nr from departments d,
    employees e where d.department_id = e.department_id(+)
    group by department_name;
begin
  open c;
  loop
    fetch c into v_nume, v_nr;
    exit when c%notfound;
    if v_nr=0 then
      dbms_output.put_line('In departamentul ' || v_nume || 'nu lucreaza niciun angajat.');
    elsif v_nr = 1 then
      dbms_output.put_line('In departamentul ' || v_nume || 'lucreaza un angajat.');
    else
      dbms_output.put_line('In departamentul ' || v_nume || 'lucreaza ' || v_nr || ' angajati.');
    end if;
  end loop;
  close c;
end;
/

set serveroutput on;

declare
  type tab_nume is table of departments.department_name%type;
  type tab_nr is table of number(4);
  t_nr tab_nr;
  t_nume tab_nume;
  cursor c is
    select department_name nume, count(employee_id) nr from departments d,
    employees e where d.department_id = e.department_id(+)
    group by department_name;
begin
  open c;
  fetch c bulk collect into t_nume, t_nr;
  close c;
  for i in t_nume.first..t_nume.last loop
    if t_nr(i)=0 then
      dbms_output.put_line('In departamentul ' || t_nume(i) || ' nu lucreaza niciun angajat.');
    elsif t_nr(i) = 1 then
      dbms_output.put_line('In departamentul ' || t_nume(i) || ' lucreaza un angajat.');
    else
      dbms_output.put_line('In departamentul ' || t_nume(i) || ' lucreaza ' || t_nr(i) || ' angajati.');
    end if;
  end loop;
end;
/


declare
  cursor c is
    select department_name nume, count(employee_id) nr from departments d,
    employees e where d.department_id = e.department_id(+)
    group by department_name;
begin
  for i in c loop
    if i.nr=0 then
      dbms_output.put_line('In departamentul ' || i.nume || ' nu lucreaza niciun angajat.');
    elsif i.nr = 1 then
      dbms_output.put_line('In departamentul ' || i.nume || ' lucreaza un angajat.');
    else
      dbms_output.put_line('In departamentul ' || i.nume || ' lucreaza ' || i.nr || ' angajati.');
    end if;
  end loop;
end;
/

set serveroutput on;

/*
exercitiul 1 & 2
*/
select * from employees;
select * from jobs;
select j.job_title titlu, e.first_name nume, e.last_name prenume, e.salary salariu from employees e join jobs j on e.job_id = j.job_id;
select e.first_name nume, e.last_name prenume, e.salary salariu from employees e join jobs j on e.job_id = j.job_id where j.job_title = 'Stock Manager';
select job_title from jobs order by job_title;

declare
  cursor angajati(titlu_job jobs.job_title%TYPE) is
    select e.first_name nume, e.last_name prenume, e.salary salariu from employees e join jobs j on e.job_id = j.job_id where j.job_title = titlu_job;
  cursor titluri is
    select job_title titlu from jobs order by job_title;
  
  nr_angajati number;
  venit_mediu employees.salary%TYPE;
  venit_lunar employees.salary%TYPE;
  
  nr_randuri number;
  val_lunara employees.salary%TYPE;
  val_medie employees.salary%TYPE;
begin
  nr_angajati := 0;
  venit_mediu := 0;
  venit_lunar := 0;
  for i in titluri loop
    nr_randuri := 0;
    for z in angajati(i.titlu) loop
      nr_randuri := nr_randuri + 1;
    end loop;
    if(nr_randuri > 0) then
      nr_randuri := 1;
      val_medie := 0;
      val_lunara := 0;
      dbms_output.put_line('Nume job: ' || i.titlu);
      for j in angajati(i.titlu) loop
        dbms_output.put_line('    ' || nr_randuri || ' : ' || j.nume || ' ' || j.prenume);
        dbms_output.put_line('        Salariu: ' || j.salariu);
        nr_randuri := nr_randuri + 1;
        val_medie := val_medie + j.salariu;
        val_lunara := val_medie + j.salariu;
        venit_mediu := venit_mediu + j.salariu;
        venit_lunar := venit_lunar + j.salariu;
      end loop;
      nr_randuri := nr_randuri - 1;
      dbms_output.put_line('  Venit mediu: ' || round(val_medie/nr_randuri, 2));
      dbms_output.put_line('  Venit lunar: ' || val_lunara);
      nr_angajati := nr_angajati + nr_randuri;
    end if;
    if(angajati%ISOPEN) then
      close angajati;
    end if;
  end loop;
  dbms_output.put_line('******************************************************');
  dbms_output.put_line('Raport final: ');
  dbms_output.put_line('    Venit mediu: ' || round(venit_mediu/nr_angajati, 2));
  dbms_output.put_line('    Venit lunar: ' || venit_lunar);
end;
/
