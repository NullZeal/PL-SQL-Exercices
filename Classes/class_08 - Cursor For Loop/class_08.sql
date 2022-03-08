-- CURSOR FOR LOOP

-- Syntax 1

You only need step 1 (Declare the cursor)
FOR cursor_index IN nameOfCursor LOOP

use . dot notation to access the columns
END LOOP;

Note that the cursor_index need not to be declared 

EXAMPLE : Using schema scott, create a procedure named mar7_ex1 to display all departments using cursor for loop syntax #1.

Solution :

CREATE OR REPLACE PROCEDURE mar7_ex1 AS

CURSOR dep_cur IS

SELECT deptno, dname, loc
    FROM dept;

BEGIN

FOR cur_index IN dep_cur LOOP
    DBMS_OUTPUT.PUT_LINE('Department Number: ' || cur_index.deptno || ' is ' || cur_index.dname || ' and his location is : ' || cur_index.loc);
END LOOP;
END;
/

EXEC mar7_ex1;


-- Syntax 2

FOR cursor_index IN (SELECT statement) LOOP 
use . dot notation to access the columns
END LOOP;

Note that the cursor_index need not to be declared 

EXAMPLE : Using schema scott, create a procedure named mar7_ex1 to display all departments using cursor for loop syntax #2.

CREATE OR REPLACE PROCEDURE mar7_ex2 AS
BEGIN
FOR cur_index IN (SELECT deptno, dname, loc FROM dept) LOOP
    DBMS_OUTPUT.PUT_LINE('Department Number: ' || cur_index.deptno || ' is ' || cur_index.dname || ' and his location is : ' || cur_index.loc);
    END LOOP;
END;
/
EXEC mar7_ex2;

