/* exercitiul 1
 Crea?i tabelul salariat_*** având urm?toarea structur?: 
Nume                  Caracteristici                 Tip  
Cod_angajat              NOT NULL                  NUMBER(4)  
nume                                             VARCHAR2(25)  
prenume                                          VARCHAR2(25) 
functia                                          VARCHAR2(20)  
sef                                               NUMBER(4)  
Data_angajarii  Valoare implicit? data curent?       DATE  
varsta                                              NUMBER 
email                                              CHAR(10) 
salariu            Valoare implicit? 0            NUMBER(9,2) 
*/ 
create table salariat_abc 
(cod_angajat number(4) not null primary key,
nume varchar2(25),
prenume varchar2(25),
functia varchar2(20),
sef number(4),
data_angajarii date default sysdate,
varsta number,
email char(10),
salariu number(9,2) default 0 );

drop table salariat_abc;

/* exercitiul 2
Afi?a?i structura tabelului creat anterior
*/
select * from salariat_abc;

/* exercitiul 3
Insera?i în tabelul salariat_*** prima înregistrare din tabelul de mai sus 
f?r? s? preciza?i lista de coloane în comanda INSERT.
COMM: you have to insert for every column a value and to keep the order presented in table
*/
insert into salariat_abc values
(1, 'Rusu', 'Alexandru', 'Director', null, sysdate, 30, null, 5500);

/* exercitiul 4
Insera?i a doua înregistrare folosind o list? de coloane din care exclude?i 
data_angajarii ?i salariul care au valori implicite. Observa?i apoi rezultatul. 
*/
insert into salariat_abc (cod_angajat, nume, prenume, functia, sef, varsta) values 
(2,'Ghita', 'Tudor', 'functionar', 1, 25);

/* exercitiul 5
Crea?i tabelul functionar_*** care s? con?in? func?ionarii din tabelul salariat_***, 
având urm?toarele coloane: codul, numele, salariul anual ?i data angaj?rii. 
Verifica?i cum a fost creat tabelul ?i ce date con?ine.
*/
create table functionar_abc as 
(select cod_angajat, nume, salariu*12 "Salariu anual", data_angajarii from salariat_abc
where functia = 'functionar');

select * from functionar_abc;

/* exercitiul 6
 Ad?uga?i o nou? coloan? tabelului salariat_*** care s? con?in? data na?terii. 
*/
alter table salariat_abc add (data_nastere date);

alter table salariat_abc drop (data_nastere);

/* exercitiul 7
 Modifica?i dimensiunea coloanei nume la 30 si pe cea a salariului la 12 cu 3 zecimale.
*/
alter table salariat_abc modify
(nume varchar2(30), salariu number(12,3));

/* exercitiul 8
 Modifica?i tipul coloanei email la VARCHAR2. 
*/
alter table salariat_abc modify
(email varchar2(10));

/* exercitiul 9
 Modifica?i valoarea implicit? a coloanei data_angajarii la data sistemului+ o zi. 
*/
alter table salariat_abc modify (data_angajarii date default sysdate+1);

/* exercitiul 10
Elimina?i coloana varsta din tabelul salariat_***. 
*/
alter table salariat_abc drop (varsta);

/* exercitiul 12
Recrea?i tabelul functionar_*** utilizând tabelul funct_***. (CREATE TABLE AS SELECT)
*/
RENAME functionar_abc TO funct_abc;

create table functionar_abc as select * from funct_abc;

/* exercitiul 13
 Elimina?i tabelul funct_abc.
*/
drop table funct_abc;

/* exercitiul 15
?terge?i tabelul salariat_***, iar apoi recrea?i-l implementând toate 
constrângerile la nivel de tabel. 
COMM : I don't know how to make table's level constraint to make columns to have 
not null values
*/
DROP TABLE salariat_abc; 

CREATE TABLE salariat_abc
( cod_ang NUMBER(4),   
  nume VARCHAR2(25) NOT NULL,   
  prenume VARCHAR2(25),   
  data_nasterii DATE,    
  functia VARCHAR2(9) NOT NULL,   
  sef NUMBER(4),   
  data_angajarii DATE DEFAULT SYSDATE,   
  email VARCHAR2(20),   
  salariu NUMBER(9,2),   
  cod_dep NUMBER(4), 
  constraint const_pk_abc primary key(cod_ang),
  constraint const_fk_abc foreign key (sef) references salariat_abc(cod_ang),
  CONSTRAINT const_c_abc CHECK (data_angajarii > data_nasterii), 
  CONSTRAINT const_u_abc UNIQUE (nume,prenume,email,data_nasterii),
  constraint const_ck_abc check (salariu > 0)
); 

/* exercitiul 16
 Crea?i tabelul departament_*** care s? aib? urm?toarea structur?.
 NUME  TIP  CONSTRÂNGERI 
 COD_DEP  NUMBER(4)  Cheie primar? 
 NUME  VARCHAR2(20)  Not null 
 ORAS  VARCHAR2(25)  
*/
create table departament_abc (
cod_dep number(4),
nume varchar2(20) not null,
oras varchar2(25),
constraint const_pk2_abc primary key(cod_dep)
);

/* exercitiul 17
 Insera?i o nou? înregistrare în salariat_*** de forma: 
 cod  nume  prenume    data_n     functia    sef    data_ang   email  salariu  cod_dep 
  2    N2    P2      11-JUN1960  economist    1      Sysdate    E2     2000      10 
COMM : it works if you set sef = null
*/
insert into salariat_abc values
(2, 'N2', 'P2', '11-jun-1960', 'economist', null, sysdate, 'E2', 2000, 10);

/* exercitiul 19
Insera?i o nou? înregistrare în departament_***. Apoi ad?uga?i constrângerea de 
cheie extern? definit? anterior
cod_dep  nume  loc  
10    Economic Bucuresti 
*/
insert into departament_abc (cod_dep, nume, loc) values 
(10, 'Economic', 'Bucuresti');

ALTER TABLE salariat_abc ADD CONSTRAINT cce2_abc FOREIGN KEY (cod_dep) REFERENCES departament_abc (cod_dep);

/* exercitiul 20
 Insera?i noi înregistr?ri în salariat_***, respectiv în departament_***. 
 Care trebuie s? fie ordinea de inserare?
*/
insert into salariat_abc (cod_ang, nume, prenume, functia)
values (4, 'Num', 'Pren', 'ofiter');

insert into departament_abc values (4, 'Sales', 'Bacau');

/* exercitiul 21
?terge?i departamentul 20 din tabelul departament_***. Ce observa?i?
*/
delete from departament_abc where cod_dep = 4;

/* exercitiul 22
 ?terge?i constrângerea cce2_***. 
 Recrea?i aceast? constrângere ad?ugând op?iunea ON DELETE CASCADE. 
*/
alter table salariat_abc drop constraint cce2_abc;

ALTER TABLE salariat_*** ADD CONSTRAINT cce2_*** FOREIGN KEY (cod_dep) 
REFERENCES departament_*** (cod_dep) ON DELETE CASCADE; 

/* exercitiul 23
?terge?i departamentul 20 din tabelul departament_***. Ce observa?i în tabelul salariat_***? 
Anula?i modific?rile.
*/
delete from departament_abc where cod_dep = 4;

/* exercitiul 24
 ?terge?i constrângerea cce2_***. Recrea?i aceast? constrângere ad?ugând op?iunea 
 ON DELETE SET NULL.
*/
alter table salariat_abc
drop constraint cce2_abc;

alter table salariat_abc
add constraint cce2_abc foreign key (cod_dep) references departamant_abc (cod_dep) on delete set null;

/* exercitiul 25
Încerca?i s? ?terge?i departamentul 10 din tabelul departament_***. Ce observa?i? 
*/
delete from departament_abc where cod_dep = 10;
