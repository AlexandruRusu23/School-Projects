/**************************************************************************/
SELECT * FROM employees;

CREATE OR REPLACE PROCEDURE proc_2(
    an employees.hire_date%TYPE)
IS
type agentie
IS
  TABLE OF agentie_imobiliara.denumire%TYPE;
  agentii agentie;
type adresa
IS
  TABLE OF imobil.adresa%TYPE;
  adrese adresa;
  pret_curent NUMBER;
  total_pret  NUMBER;
BEGIN
  SELECT denumire BULK COLLECT INTO agentii FROM agentie_imobiliara;
  FOR i IN agentii.first..agentii.last
  LOOP
    DBMS_OUTPUT.PUT_LINE('Denumire agentie: ' || agentii(i));
    SELECT i.adresa
    BULK COLLECT INTO adrese
    FROM imobil i
    JOIN tranzactioneaza t
    ON i.id_imobil = t.cod_imobil
    JOIN agentie_imobiliara a
    ON t.cod_agentie = a.id_agentie
    WHERE a.denumire = agentii(i);
    FOR j IN adrese.first..adrese.last
    LOOP
      DBMS_OUTPUT.PUT_LINE('    Adresa imobil: ' || adrese(j));
      SELECT t.pret
      INTO pret_curent
      FROM tranzationeaza t
      JOIN imobil i
      ON t.cod_imobil = i.id_imobil
      WHERE i.adresa  = adrese(j);
      total_pret     := total_pret + pret_curent;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('    Total: ' || total_pret);
    total_pret := 0;
    adrese.delete;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Sunt proc 2');
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION(-20001, 'HELLO!');
END proc_2;
/

SET serveroutput ON;

BEGIN
  proc_2(to_date('19-01-2010', 'dd-mm-yyyy'));
END;
/

/************************************************************************/
DECLARE
  type mytip is table of employees.hire_date%TYPE index by number;
  datele mytip;
BEGIN
  select hire_date bulk collect into datele from employees;
END;
/

CREATE TABLE test_33
  ( nume VARCHAR2(50), numar NUMBER
  );
  
DROP TABLE test_32;

ALTER TABLE agentie_imobiliara ADD noua_coloana mytip;

CREATE type tipuri
AS
  TABLE OF VARCHAR2(50);
  /

DROP type tipuri;

/************************************************************************/

CREATE OR REPLACE PROCEDURE proc_5(
    nume_proprietar proprietar.nume%TYPE)
IS
  cod_proprietar NUMBER;
type apartament
IS
  TABLE OF imobil.tip%TYPE;
  apartamente apartament;
type id_apartament
IS
  TABLE OF imobil.id_imobil%TYPE;
  id_apartamente id_apartament;
  nr_apartamente NUMBER;
  max_imobile    NUMBER;
  top_firma agentie_imobiliara.id_agentie%TYPE;
BEGIN
  SELECT id_proprietar
  INTO cod_proprietar
  FROM proprietar
  WHERE nume         = nume_proprietar;
  IF cod_proprietar IS NOT NULL THEN
    SELECT i.id_imobil bulk collect
    INTO id_apartamente
    FROM imobil i
    WHERE i.cod_proprietar = cod_proprietar
    AND i.tip LIKE '%apartament%';
    FOR i IN id_apartamente.first..id_apartamente.last
    LOOP
      SELECT MAX(COUNT(cod_imobil)),
        cod_agentie
      INTO max_imobile,
        top_firma
      FROM tranzactioneaza
      WHERE cod_imobil = id_apartamente(i)
      GROUP BY cod_agentie;
      nr_apartamente := nr_apartamente + max_imobile;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Numar apartamente: ' || nr_apartamente);
  END IF;
  DBMS_OUTPUT.PUT_LINE('');
END proc_5;
/

SELECT COUNT(job_id), job_id FROM employees GROUP BY job_id;

/*****************************************************************************/
CREATE OR REPLACE TRIGGER trig_4 AFTER
  INSERT OR
  UPDATE ON imobil FOR EACH ROW 

DECLARE type id_proprietar IS TABLE OF proprietar.id_proprietar%TYPE;
  id_proprietari id_proprietar;
type numar
IS
  TABLE OF NUMBER;
  numere numar;
  cod_imb tranzactioneaza.cod_imobil%TYPE;
BEGIN
  SELECT COUNT(p.id_proprietar),
    p.id_proprietar bulk collect
  INTO numere,
    id_proprietari
  FROM proprietar p
  JOIN imobil i
  ON p.id_proprietar = i.cod_proprietar
  JOIN tanzactioneaza t
  ON i.id_imobil               = t.cod_imobil
  WHERE COUNT(p.id_proprietar) > 2;
  FOR i IN id_proprietari.first..id_proprietari.last
  LOOP
    SELECT t.cod_imobil
    INTO cod_imb
    FROM tranzactioneaza t
    JOIN imobil i
    ON t.cod_imobil = i.id_imobil
    JOIN proprietar p
    ON i.cod_proprietar   = p.id_proprietar
    WHERE p.id_proprietar = id_proprietari(i);
    IF :NEW.cod_imobil    = cod_imb THEN
      UPDATE tranzactioneaza
      SET valoare_comision = valoare_comision - valoare_comision * 5 / 20
      WHERE cod_imobil     = cod_imb;
    END IF;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('');
EXCEPTION
  WHEN OTHERS THEN
   RAISE_APPLICATION(-20001, 'Eroare');
END;
/


/**************************************************************************/
INSERT INTO test_33 VALUES
  ('AlexAA', 10
  );
  
SELECT * FROM test_32;

CREATE OR REPLACE TRIGGER trig_test AFTER
  UPDATE OR
  INSERT ON test_33 FOR EACH row BEGIN
  UPDATE test_32 SET numar = numar + 10;
END;
/

DROP TRIGGER trig_test;

/**************************************************************************/
CREATE OR REPLACE type coloana_noua IS varray(2) OF NUMBER;
/
ALTER TABLE tabel_to_modify ADD nr_prod_prod coloana_noua;
UPDATE magazin
SET nr_prod_prod = coloana_noua(
  (SELECT COUNT(cod#) FROM produs
  ) ,
  (SELECT COUNT() FROM producator
  ) );
DECLARE
  nr_produs_producator coloana_noua := coloana_noua(0, 0);
  nr_produse     NUMBER;
  nr_producatori NUMBER;
BEGIN
  FOR i IN
  (SELECT cod FROM magazin
  )
  LOOP
    SELECT COUNT(p.cod#)
    INTO nr_produse
    FROM comercializeaza c
    JOIN produs p
    ON c.cod_produs#     = p.cod#
    WHERE c.cod_magazin# = i.cod;
    SELECT COUNT(p2.cod#)
    INTO nr_producatori
    FROM comercializeaza c
    JOIN produs p
    ON c.cod_produs# = p.cod#
    JOIN producator p2
    ON p.cod_producator   = p2.cod#
    WHERE c.cod_magazin#  = i.cod;
    nr_produs_producator := coloana_noua(nr_produse, nr_producatori);
    UPDATE magazin SET nr_prod_prod = nr_produs_producator;
    nr_produs_producator := coloana_noua(0, 0);
  END LOOP;
END;
/

