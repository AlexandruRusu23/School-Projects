declare
  type ntip0 is record(id emp_ar.employee_id%type, sal emp_ar.salary%type);
  type ntip is table of ntip0 index by binary_integer;
  salariu ntip;
  sal_nou ntip;
begin
  select * bulk collect into salariu
  from (select distinct employee_id, salary from emp_ar where commission_pct is null order by salary) where rownum <= 5;
  for i in salariu.first..salariu.last 
  loop
    dbms_output.put_line('Salariu vechi' || salariu(i).sal || ' cu id:' || salariu(i).id);
    update emp_ar set salary = salary + salary * 0.05 where salary = salariu(i).sal
    returning employee_id, salary
    bulk collect into sal_nou;
    for j in sal_nou.first..sal_nou.last
    loop
      dbms_output.put_line('Salariu nou:' || sal_nou(j).sal || ' cu id:' || sal_nou(j).id);
    end loop;
  end loop;
end;
/

create table emp_ar as select * from employees;

set serveroutput on;

create or replace
  type ntip_ar is table of varchar2(50);
/

create table excursie_ar
( id number(4), 
  nume varchar2(30),
  orase ntip_ar,
  status varchar2(20))
  nested table orase store as nume_ar;
  
insert into excursie_ar values (1, 'a', ntip_ar('abc', 'def', 'ghi'), 'disponibil');
insert into excursie_ar values (3, 'a', ntip_ar('abc', 'def', 'ghi'), 'disponibil');
insert into excursie_ar values (5, 'a', ntip_ar('abc', 'def', 'ghi'), 'disponibil');
insert into excursie_ar values (6, 'a', ntip_ar('abc', 'def', 'ghi'), 'disponibil');

update excursie_ar set orase = ntip_ar('Bucharest', 'Pitesti', 'New York') where id = 1;

select * from excursie_ar;


declare
var_col ntip_ar:=ntip_ar();
begin
  select b.* bulk collect into var_col
  from excursie_ar a, table (a.orase) b
  where id = 1;
  dbms_output.put_line(var_col.count);
end;
/