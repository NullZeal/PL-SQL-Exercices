What is a View?
  Is a SELECT statement looks like a table

Why view?
  -- For sensitive data
  -- To make the select statement simpler

Example 1:  Create a view named employee with column empno, ename,job, and deptno of table emp. 

Give User Lota full access to the view created so that Lota can manipulate the data of the view.

  -- scott
CREATE OR REPLACE VIEW employee AS
  SELECT empno, ename, job, deptno
  FROM   emp;
GRANT SELECT, INSERT, UPDATE, DELETE ON employee TO lota;

connect sys/sys as sysdba;
GRANT CREATE VIEW TO scott;
CREATE USER lota IDENTIFIED BY 123;
GRANT CONNECT, RESOURCE TO lota;

-- Lota
   SELECT * FROM scott.employee;
   UPDATE scott.employee
   SET ename = 'Lota', job = 'MANAGER'
   WHERE empno = 7934;

Example 2: Create a view name emp_dept_view with column 
empno, ename, sal, deptno from table emp and dname from table dept

CREATE OR REPLACE VIEW	 emp_dept_view AS
SELECT empno, ename, sal, dept.deptno, dname
FROM   emp ,dept
WHERE  emp.deptno = dept.deptno;

-- scott
GRANT SELECT , INSERT, UPDATE, DELETE ON emp_dept_view 
TO lota;
-- Lota
  UPDATE scott.emp_dept_view
  SET   sal = 5000
  WHERE empno = 7934;  ok

  UPDATE scott.emp_dept_view
  SET   dname = 'SALES'
  WHERE deptno = 10;  Not ok

------------------ INSTEAD OF TRIGGER ----------------
  Syntax:
    CREATE OR REPLACE TRIGGER name_of_trigger
    INSTEAD OF INSERT | UPDATE | DELETE ON name_of_view
    FOR EACH ROW
      BEGIN
         executable statement;
      END;
    /

-- Example 2: Create a view name emp_dept_view with column 
-- empno, ename, sal, deptno from table emp and dname from table dept

-- CREATE OR REPLACE VIEW	 emp_dept_view AS
-- SELECT empno, ename, sal, dept.deptno, dname
-- FROM   emp ,dept
-- WHERE  emp.deptno = dept.deptno;


Last example of the course databases II
  Create an instead of trigger for the view of example 2
so that the user can update the data of the view
emp_dept_view.

CREATE OR REPLACE TRIGGER instead_emp_dept
INSTEAD OF UPDATE ON emp_dept_view
FOR EACH ROW
  BEGIN
    UPDATE emp
    SET 
        ename = :NEW.ename, 
        sal = :NEW.sal, 
        deptno  = :NEW.deptno
    WHERE empno = :NEW.empno;

    UPDATE dept
    SET    dname = :NEW.dname
    WHERE  deptno = :NEW.deptno;
  END;
/

Testing

UPDATE scott.emp_dept_view
  SET   dname = 'COOKING'
  WHERE deptno = 10;   ok now


