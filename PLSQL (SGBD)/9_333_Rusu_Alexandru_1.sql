/* Punctul 1 */
CREATE OR REPLACE PACKAGE Pachet_Examen IS
  type hoteluri IS record(nume hotel.denumire%TYPE, camere_libere number);
  CURSOR cursorB(oras hotel.localitate%TYPE, numar_stele number) RETURN hoteluri;
  
  PROCEDURE procedureA;
  PROCEDURE procedureC;
END Pachet_Examen;
/

CREATE OR REPLACE PACKAGE BODY Pachet_Examen IS

CURSOR cursorB(oras hotel.localitate%TYPE, numar_stele NUMBER)
  RETURN hoteluri
IS
  SELECT hotel.denumire,
    (SELECT COUNT(camera.id_camera)
    FROM camera
    JOIN cazare
    ON camera.id_camera      = cazare.id_camera
    WHERE camera.id_hotel    = hotel.id_hotel
    AND (cazare.data_plecare < sysdate
    OR data_sosire           > sysdate)
    )
FROM hotel
WHERE hotel.localitate IN (oras)
AND hotel.numar_stele   = numar_stele;

/*********************************************************************************/

  PROCEDURE procedureA IS
    type numar is table of number;
    numar_stele numar;
    nume_hotel hotel.denumire%TYPE;
    oras hotel.localitate%TYPE;
    numar_camere number;
    aux number;
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Subprogram A:');
    
    select numar_stele bulk collect into numar_stele from hotel group by numar_stele order by numar_stele;
    
    FOR i IN numar_stele.first..numar_stele.last LOOP
      DBMS_OUTPUT.PUT_LINE('Pentru ' || numar_stele(i) || ' stele:');
      DBMS_OUTPUT.PUT_LINE('  Hoteluri: ');
      FOR j IN (SELECT * FROM hotel WHERE numar_stele = numar_stele(i)) LOOP
        DBMS_OUTPUT.PUT('     ' || j.denumire);
        DBMS_OUTPUT.PUT_LINE(' Oras: ' || j.localitate);
        FOR k IN (SELECT * FROM camera WHERE id_hotel = j.id_hotel) LOOP
          SELECT COUNT(id_camera) into aux from cazare where id_camera = k.id_camera AND data_plecare > sysdate AND data_sosire < sysdate;
          numar_camere := numar_camere + aux;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('        Numar camere ocupate: ' || numar_camere);
        numar_camere := 0;
      END LOOP;
    END LOOP;
  END procedureA;
  
/*********************************************************************************/

  PROCEDURE procedureC IS
    type oras is table of hotel.localitate%TYPE;
    orase oras;
    nume_hotel hotel.denumire%TYPE;
    numar_camere number;
    aux number;
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Subprogram C:');
    
    select localitate bulk collect into orase from hotel group by localitate order by localitate;
    
    FOR i IN orase.first..orase.last LOOP
      DBMS_OUTPUT.PUT_LINE('Pentru orasul ' || orase(i) || ' :');
      DBMS_OUTPUT.PUT_LINE('  Hoteluri: ');
      FOR j IN (SELECT * FROM hotel WHERE localitate = orase(i)) LOOP
        DBMS_OUTPUT.PUT_LINE('     ' || j.denumire);
        FOR k IN (SELECT * FROM camera WHERE id_hotel = j.id_hotel) LOOP
          SELECT COUNT(id_camera) into aux from cazare where id_camera = k.id_camera AND (data_plecare < sysdate OR data_sosire > sysdate);
          numar_camere := numar_camere + aux;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('        Numar camere libere: ' || numar_camere);
        numar_camere := 0;
      END LOOP;
    END LOOP;
    
  END procedureC;

BEGIN
  DBMS_OUTPUT.PUT_LINE('Pachetul lui Alex:');
END Pachet_Examen;
/

/* Punctul 2 */

DECLARE
  d_sosire cazare.data_sosire%TYPE;
  d_plecare cazare.data_plecare%TYPE;
  cursor pct2 is
    select * from camera;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Punctul 2:');
  
  for i in pct2 loop
    SELECT data_sosire, data_plecare into d_sosire, d_plecare from cazare where cazare.id_camera = i.id_camera; 
    IF d_sosire < sysdate AND d_plecare > sysdate THEN
      UPDATE camera SET observatii = 'Ocupat' WHERE id_camera = i.id_camera;
    ELSE
      UPDATE camera SET observatii = 'Disponibil' WHERE id_camera = i.id_camera;
    END IF;
  END LOOP;
END;
/

/* Punctul 3 */

CREATE OR REPLACE TRIGGER T1 AFTER
  INSERT OR UPDATE ON cazare FOR EACH ROW
  DECLARE 
    d_sosire CAZARE.DATA_SOSIRE%TYPE;
    d_plecare CAZARE.DATA_PLECARE%TYPE;
  BEGIN
    IF :NEW.data_sosire < sysdate AND :NEW.data_plecare > sysdate THEN
      UPDATE camera
      SET observatii   = 'Ocupat'
      WHERE id_camera = :NEW.id_camera;
    ELSE
      UPDATE camera
      SET observatii   = 'Disponibil'
      WHERE id_camera = :NEW.id_camera;
    END IF;
END;
/

begin

Pachet_Examen.procedureC;

end;
/

select * from hotel;
select * from hotel where localitate = 'Bucuresti';
select * from hotel where denumire = 'Ambassador';
select * from camera;
select * from cazare;

update cazare set data_plecare = to_date('10-03-2017', 'dd-mm-yyyy') where id_cazare = 1;

select localitate from hotel group by localitate order by localitate;

SELECT hotel.denumire, (SELECT count(camera.id_camera) from camera join cazare on camera.id_camera = cazare.id_camera where camera.id_hotel = hotel.id_hotel and cazare.data_plecare < sysdate) FROM hotel where hotel.localitate IN ('Bucuresti') AND hotel.numar_stele > 1;

SELECT COUNT(id_camera) from cazare where id_camera = 7 AND data_plecare > to_date('24-01-11', 'dd-mm-yy') AND data_sosire < sysdate;

select numar_stele from hotel group by numar_stele order by numar_stele;