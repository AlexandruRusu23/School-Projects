CREATE OR REPLACE PACKAGE pachet
IS
  type carte IS record(titlu books.title%type);

  CURSOR cB(categorie books.category%type) RETURN carte;
    
  PROCEDURE procA(oras BOOKCUST.city%type);
  PROCEDURE procC;
END pachet;
/
  
CREATE OR REPLACE PACKAGE body pachet
IS
  CURSOR cB(categorie books.category%type) RETURN carte IS
    SELECT title
    FROM books
    JOIN bookorderitems USING(isbn)
    WHERE category = categorie
    GROUP BY (isbn, title)
    HAVING SUM(quantity) =
      (SELECT MAX(SUM(quantity)) FROM bookorders GROUP BY (isbn)
      );
      
  PROCEDURE procA(oras BOOKCUST.city%type) IS
    type client IS record (nume bookcust.lastname%type, prenume bookcust.firstname%type);
    nrcarti NUMBER(3);
    topClient client;
    total NUMBER(5);
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Clienti:');
    FOR i IN (SELECT firstname, lastname FROM bookcust WHERE lower(city) = lower(oras)) LOOP
      DBMS_OUTPUT.PUT_LINE(i.firstname || ' ' || i.lastname);
    END LOOP;
  SELECT SUM(quantity)
  INTO nrcarti
  FROM bookorders
  JOIN bookorderitems USING(order#)
  WHERE lower(shipcity) = lower(oras);
  DBMS_OUTPUT.PUT_LINE('Numar carti comandate: ' || nrcarti);
  SELECT lastname,firstname
  INTO topClient
  FROM (SELECT lastname, firstname FROM bookcust
        JOIN bookorders USING(customer#)
        JOIN bookorderitems USING(order#)
        JOIN books USING(isbn)
        WHERE lower(shipcity) = lower(oras)
        GROUP BY (customer#,lastname,firstname)
        ORDER BY SUM(quantity * cost) DESC)
  WHERE ROWNUM = 1;
  DBMS_OUTPUT.PUT_LINE('Top client: ' || topClient.prenume || ' ' || topClient.nume);

  SELECT SUM(quantity*cost)
  INTO total
  FROM bookorders
  JOIN bookorderitems USING(order#)
  JOIN books USING(isbn)
  WHERE lower(shipcity) = lower(oras);
  DBMS_OUTPUT.PUT_LINE('Valoare totala comenzi: ' || total);
  END;

PROCEDURE procC IS
BEGIN
  FOR categorie IN
  (SELECT DISTINCT category FROM books
  )
  LOOP
    DBMS_OUTPUT.PUT_LINE('Categoria: ' || categorie.category);
    FOR i IN pachet.cB(categorie.category)
    LOOP
      DBMS_OUTPUT.PUT_LINE(i.titlu);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('---');
  END LOOP;
END;
END pachet;
/
BEGIN
  pachet.procA('CHICAGO');
  DBMS_OUTPUT.PUT_LINE('---');
  pachet.procC();
END;
/
ALTER TABLE bookorders ADD discount NUMBER(3);
/
CREATE OR REPLACE TRIGGER T1 AFTER
  INSERT ON bookorders FOR EACH ROW DECLARE reff BOOKCUST.referred%type := NULL;
  BEGIN
    SELECT referred INTO reff FROM bookcust WHERE customer# = :NEW.customer#;
    IF reff IS NOT NULL THEN
      UPDATE bookorders
      SET discount    = 5
      WHERE customer# = :NEW.customer#
      AND order#      = :NEW.order#;
    ELSE
      UPDATE bookorders
      SET discount    = NULL
      WHERE customer# = :NEW.customer#
      AND order#      = :NEW.order#;
    END IF;
  END;
  /