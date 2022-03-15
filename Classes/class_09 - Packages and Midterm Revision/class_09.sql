Review what need dto be ready for test

CREATE PROCEDURE :

CREATE PROCEDURE na_of_procedure (parameter_name MODE DATATYPE, ...) AS

BEGIN
    executable statement;

END;



MODE :  IN (READ)    pass by value    exec p1q1(value) v_var := parameter_name; 

        ex : v_value := parameter_name;
            SELECT ...
                FROM
                    WHERE x = parameter_name;


        OUT (WRITE)  pass by variable exec PQ1Q(v_tax) parameter_name := 3;



        IN OUT       pass by variable exec P1Q1(v_old_new_sal) 
                     v_old_sal := v_old_new_sal; READ
                     v_new_sal := 5000;
                     v_old_new_sal := v_new_sal ;



CREATE OR REPLACE FUNCTION (parameter_name DATATYPE) RETURN DATATYPE AS

BEGIN 
    RETURN variable;
END;
/

(BOOLEAN IS A PL/SQL, not a SQL)




CREATE FUNCTION find_fst(p_price NUMBER) RETURN number AS
BEGIN
    RETURN p_price * 5 / 100;
END;
/

CREATE FUNCTION find_fst(p_price NUMBER) RETURN number AS
v_price NUMBER := p_price;

BEGIN
    RETURN ROUND(p_price * 5 / 100, 2);
END;
/

You can yield a function in a SELECT statement in a procedure!

SELECT inv_id, inv_price, find_gst(inv_price) "5% GST"
    FROM inventory;




SELECT INTO ... (SELECT 1 and ONLY 1 VALUE, ELSE EXCEPTION)
                (NO DATA FOUND EXCEPTION FOR PRIMARY KEYS!!!)


SELECT inv_price
    INTO v_inv_price
        FROM inventory
            WHERE inv_id = p_inv_id; 

EXCEPTION
    WHEN NO_DATA_FOUND THEN


IF FOUD THEN UPDATE, ELSE INSERT!


WHEN YOU HANDLE MANY ROWS, YOU HAVE TO DO THE EXPLICIT CURSOR

Normal cursor -- 4 steps

1 - declaration
2 - OPEN
3 - FETCH
4 - CLOSE

cursor with parameter (if we want a cursor with a different select everytime)

ex : CURSOR emp_cur (p_deptno NUMBER) IS
        SELECT empno, ename
        FROM emp
        WHERE deptno = pc_deptno;

    OPEN emp_cur(v_deptno);
    FETCH emp_cur INTO v_empno, v_ename;
    IF emp_cur%FOUND THEN
        DBMS_OUTPUT ... (v_empno);
    ELSE DBMS_OUTPUT .. ('Your select return no data my friend')
    END IF;
    WHILE emp_cur%FOUND LOOP
        DBMS_OUTPUT (v_empno);
        FETCH emp_cur INTO v_empno, v_ename;
    END LOOP;
    END;
    /

CURSOR FOR LOOP
    SYNTAX 1 : DECLARE CURSOR
                    FOR cursor_index IN name_of_cursor LOOP
                        DBMS_OUTPUT ... (cursor_index.column_name);
                        END LOOP;
    
    SYNTAX 2 : FOR cursor_index IN (SELECT statement) LOOP
                DBMS_OUTPUT ... (cursor_index.column_name);
            END LOOP;





-------------------------
Packages (GLOBAL VARIABLES)

