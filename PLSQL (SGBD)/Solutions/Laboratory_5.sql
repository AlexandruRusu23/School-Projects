declare
 myvar JOBS.JOB_ID%TYPE;
 mynume EMPLOYEES.LAST_NAME%TYPE;
 cursor mycurs is 
 select job_id from jobs;
 cursor cursparam(param JOBS.JOB_ID%TYPE) is
 select last_name from employees where job_id = param;

begin
  open mycurs;
  loop
      fetch mycurs into myvar;
      EXIT WHEN mycurs%NOTFOUND;
      open cursparam(myvar);
      loop
        fetch cursparam into mynume;
         EXIT WHEN cursparam%NOTFOUND;
         DBMS_OUTPUT.PUT_LINE(myvar || mynume);
      end loop;
      close cursparam;
  end loop;
  close mycurs;
end;
/

select * from jobs;

-- ciclu cursor
declare
 myvar JOBS.JOB_ID%TYPE;
 mynume EMPLOYEES.LAST_NAME%TYPE;
 cursor mycurs is 
 select job_id job_id from jobs;
 cursor cursparam(param JOBS.JOB_ID%TYPE) is
 select last_name from employees where job_id = param;

begin
  for i in mycurs loop
    
     
      open cursparam(i.job_id);
      loop
        fetch cursparam into mynume;
         EXIT WHEN cursparam%NOTFOUND;
         DBMS_OUTPUT.PUT_LINE(i.job_id || mynume);
      end loop;
      close cursparam;
  end loop;

end;
/

-- ciclu cursor cu subcereri
declare
 myvar JOBS.JOB_ID%TYPE;
 mynume EMPLOYEES.LAST_NAME%TYPE;
 cursor cursparam(param JOBS.JOB_ID%TYPE) is
 select last_name from employees where job_id = param;

begin
  for i in (select job_id job_id from jobs) loop
   open cursparam(i.job_id);
      loop
        fetch cursparam into mynume;
         EXIT WHEN cursparam%NOTFOUND;
         DBMS_OUTPUT.PUT_LINE(i.job_id || mynume);
      end loop;
      close cursparam;
  end loop;

end;
/

--expresii cursor
-- ciclu cursor cu subcereri
declare
 myvar JOBS.JOB_ID%TYPE;
 mynume EMPLOYEES.LAST_NAME%TYPE;
  TYPE reflilicursor IS REF CURSOR;
  lilicursor reflilicursor;
  cursor mare is select j.job_id , cursor(select last_name from EMPLOYEES where job_id =j.job_id ) from jobs j;
begin
 open mare;
 loop
   fetch mare into myvar,lilicursor;
   EXIT WHEN mare%NOTFOUND;
   loop
      fetch lilicursor into mynume;
      DBMS_OUTPUT.PUT_LINE(mynume || myvar);
      EXIT WHEN lilicursor%NOTFOUND;
    end loop; 
   
  end loop;
  close mare;
end;
/