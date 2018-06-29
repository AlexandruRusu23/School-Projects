declare
  nume member.first_name%type:='&t';
  nr_impr NUMBER(3);
  ocurente_nume number(3);
  nr_titluri number(3);
begin
  select count(*) into ocurente_nume from member where upper(first_name) = upper(nume);
  select unique count(*) into nr_titluri from title;
  
  select count(*) into nr_impr from rental r, member m
  where r.member_id = m.member_id
  and upper(m.first_name) = upper(nume);
  dbms_output.put_line(nume || ' a imprumutat ' || nr_impr);
  
  if nr_impr / nr_titluri >= 0.75
  then dbms_output.put_line('Categorie 1');
  update copie_member set Categorie='Categorie 1' where first_name = nume;  
  elsif nr_impr / nr_titluri >= 0.5
  then dbms_output.put_line('Categorie 2');
  update copie_member set Categorie='Categorie 2' where upper(first_name) = upper(nume);
  elsif nr_impr / nr_titluri >= 0.25
  then dbms_output.put_line('Categorie 3');
  update copie_member set Categorie='Categorie 3' where upper(first_name) = upper(nume);
  elsif nr_impr / nr_titluri >= 0
  then dbms_output.put_line('Categorie 4');
  update copie_member set Categorie='Categorie 4' where upper(first_name) = upper(nume);
  end if;
  
  if ocurente_nume = 0
  then dbms_output.put_line('Nu exista');
  elsif ocurente_nume > 1
  then dbms_output.put_line('Mai multi!');
  else
  select count(*)
  into nr_impr
  from rental r, member m
  where r.member_id = m.member_id
  and upper(m.first_name) = upper(nume);
  dbms_output.put_line(nume || ' a imprumutat ' || nr_impr);
  end if;
end;
/

set serveroutput on;

select * from member;
select * from copie_member;

create table copie_member as select * from member;
alter table copie_member add Categorie varchar2(25);

select * from title;

declare
 type ntip is record(fn member.first_name%type, ln member.last_name%type);
 type ntip1 is table of ntip index by binary_integer;
 var ntip1;
 var3 ntip;
 begin
  select first_name, last_name bulk collect into var from member;
  for i in var.first..var.last loop
    dbms_output.put_line(var(i).fn|| ' ' || var(i).ln);
  end loop;
 end;
/ 

declare
 var member%rowtype;
 begin
  select * into var from member where member_id = 109;
  dbms_output.put_line(var.first_name || ' ' || var.last_name);
 end;
/

declare
 type ntip is record(fn member.first_name%type, ln member.last_name%type);
 type ntip1 is table of ntip index by binary_integer;
 var ntip1;
 begin
  select first_name, last_name bulk collect into var from member;
  for i in var.first..var.last loop
    dbms_output.put_line(var(i).fn|| ' ' || var(i).ln);
  end loop;
 end;
/ 