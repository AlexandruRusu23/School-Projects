create or replace function f2_ra 
  (v_nume employees.last_name%TYPE DEFAULT 'Bell')
return number is
  salariu employees.salary%TYPE;
  begin
    select salary into salariu
    from employees
    where last_name = v_nume;
    return salariu;
  exception
    when no_data_found then
      insert into info_ra values (n_nume, sysdate, SQLCODE, 1, SQLERRM);
    when too_many_rows then
      insert into info_ra values (n_nume, sysdate, SQLCODE, 1, SQLERRM);
    when others then
      insert into info_ra values (n_nume, sysdate, SQLCODE, 1, SQLERRM);
end f2_ra;
/

create table info_ra(
utilizator varchar2(50),
data date,
comanda varchar2(50),
nr_linii number(3),
eroare varchar2(50));
