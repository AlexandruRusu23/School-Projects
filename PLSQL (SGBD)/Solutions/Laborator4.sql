/* exercitiul 1 */
CREATE TABLE info_ar
  (
    utilizator VARCHAR2(50),
    data       DATE,
    comanda    VARCHAR2(50),
    nr_linii   NUMBER,
    eroare     VARCHAR2(100)
  );

SET serveroutput ON;

SELECT * FROM info_ar;

/* exercitiul 2 */
CREATE OR REPLACE FUNCTION f2_ar(
    v_nume employees.last_name%TYPE DEFAULT 'Bell')
  RETURN NUMBER
IS
  salariu employees.salary%type;
BEGIN
  SELECT salary INTO salariu FROM employees WHERE last_name = v_nume;
  RETURN salariu;
EXCEPTION
WHEN NO_DATA_FOUND THEN
  INSERT
  INTO info_ar
    (
      utilizator,
      data,
      comanda,
      nr_linii,
      eroare
    )
    VALUES
    (
      'Student',
      sysdate,
      'salariu',
      '0',
      'Nu exista angajati'
    );
  RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele dat');
WHEN TOO_MANY_ROWS THEN
  INSERT
  INTO info_ar
    (
      utilizator,
      data,
      comanda,
      nr_linii,
      eroare
    )
    VALUES
    (
      'Student',
      sysdate,
      'salariu',
      '2',
      'Prea multi angajati'
    );
  RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi angajati cu numele dat');
WHEN OTHERS THEN
  INSERT
  INTO info_ar
    (
      utilizator,
      data,
      comanda,
      nr_linii,
      eroare
    )
    VALUES
    (
      'Student',
      sysdate,
      'salariu',
      '-1',
      'Nu exista angajati'
    );
  RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
END f2_ar;
/

/* exercitiul 3 */
SELECT * FROM jobs;
SELECT * FROM job_history;

SELECT COUNT(job_id) FROM job_history WHERE employee_id = 101 GROUP BY job_id;

SELECT COUNT(e.employee_id)
FROM employees e
JOIN jobs j
ON e.job_id = j.job_id
JOIN job_history jh
ON e.employee_id = jh.employee_id
WHERE (SELECT COUNT(jh2.job_id)
  FROM job_history jh2
  WHERE jh2.employee_id      = e.employee_id
  GROUP BY jh2.employee_id) >= 2;

CREATE OR REPLACE FUNCTION f3_ar(
    oras locations.city%TYPE)
  RETURN NUMBER
IS
  nr_angajati NUMBER;
BEGIN
  SELECT COUNT(e.employee_id)
  INTO nr_angajati
  FROM employees e
  JOIN jobs j
  ON e.job_id = j.job_id
  JOIN job_history jh
  ON e.employee_id = jh.employee_id
  WHERE (SELECT COUNT(jh2.job_id)
    FROM job_history jh2
    WHERE jh2.employee_id      = e.employee_id
    GROUP BY jh2.employee_id) >= 2;
  DBMS_OUTPUT.PUT_LINE('');
  RETURN nr_angajati;
EXCEPTION
WHEN NO_DATA_FOUND THEN
  RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati.');
  -- plus insert in info_ar (bla-bla)
WHEN TOO_MANY_ROWS THEN
  RAISE_APPLICATION_ERROR(-20001, 'Prea multe date');
  -- insett in info_ar (bla-bla)
WHEN OTHERS THEN
  RAISE_APPLICATION_ERROR(SQLCODE, SQLERRM);
END f3_ar;
/

/* exercitiul 4 */
select * from employees;

CREATE OR REPLACE PROCEDURE proc4_ar(
    cod_manager NUMBER)
IS
  cod NUMBER;
BEGIN
  SELECT employee_id INTO cod FROM employees WHERE employee_id = cod_manager;
  IF cod IS NOT NULL THEN
    UPDATE employees
    SET salary       = salary + salary/10
    WHERE manager_id =
      (SELECT employee_id FROM employees WHERE employee_id = cod
      );
    -- insert into info_ar that we updated successfully the table
  END IF;
  IF cod IS NULL THEN
    -- insert into info_ar that there is no manager
    DBMS_OUTPUT.PUT_LINE('Nu exista manager');
  END IF;
  DBMS_OUTPUT.PUT_LINE('');
END proc4_ar;
/
