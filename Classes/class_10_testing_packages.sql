Menu du jour
  Review what need to be ready for the Test
   -- CREATE PROCEDURE:
         CREATE PROCEDURE name_of_procedure (parameter_name MODE DATATYPE, ...)  AS

          BEGIN
             executable statement    ;
          END;
          /

MODE :  IN          pass by value      exec p1q1(3)       v_variable := parameter_name ;  READ
        OUT         pass by variable      P1Q1(v_tax)     parameter_name :=  3;         WRITE
        IN OUT      pass by variable      P1q1(v_old_new_sal) 
                                                            V_OLD_SAL := v_old_new_sal;  READ
                                                              ...
                                                          v_old_new_sal := 5000;      WRITE

                                               OR         v_old_new_sal := V_NEW_SAL;  WRITE

READ  :   v_value := parameter_name;
          SELECT ...
          FROM 
          WHERE s_id = parameter_name;


CREATE OR REPLACE FUNCTION (paramter_name DATATYPE) RETURN datatype AS
  BEGIN
    RETURN variable;
  END;
/

CREATE FUNCTION find_gst (p_price NUMBER) RETURN number AS
  BEGIN
    RETURN p_price * 5 / 100;
  END;
/


CREATE FUNCTION find_gst (p_price NUMBER) RETURN number AS
    v_result NUMBER;
  BEGIN
    v_result := p_price * 5 / 100;
    RETURN  v_result;
  END;
/

CREATE FUNCTION find_gst (p_price NUMBER) RETURN number AS
    v_price NUMBER := p_price;
    v_result NUMBER;
  BEGIN
    v_result := v_price * 5 / 100;
    RETURN  ROUND(v_result,2);
  END;
/

SELECT inv_id, inv_price, find_gst(inv_price) "5% GST"
FROM   inventory;
-----------------------------
   SELECT  ... INTO 

     SELECT inv_price
     INTO   v_inv_price
     FROM   inventory
     WHERE  inv_id = p_inv_id;

       UPDATE ...


  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         INSERT  ...

--------------- EXPLICIT CURSOR ------

   NORMAL CURSOR  -- 4 steps   --   Declaration
                               --   OPEN
                               --   FETCH
                               --   CLOSE

   CURSOR WITH PARAMETER
                              CURSOR emp_cur (pc_deptno NUMBER) IS
                                 SELECT empno, ename
                                 FROM   emp
                                 WHERE  deptno = pc_deptno;

                              OPEN emp_cur(v_deptno);
                              FETCH emp_cur INTO v_empno, v_ename;
                                  IF emp_cur%FOUND THEN
                                     DBMS_OUTPUT ...  (v_empno );
                                  ELSE
                                     DBMS_OUTPUT ...  ('Your select return no data my friend Abdul'); 
                                  END IF;
                                WHILE emp_cur%FOUND  LOOP
                                    BMS_OUTPUT ...  (v_empno );
                                    FETCH emp_cur INTO v_empno, v_ename;
                                END LOOP;

   CURSOR FOR LOOP       

             Syntax 1 :    Declare cursor
                              
                                   
                      FOR cursor_index IN name_of_cursor LOOP
                        DBMS_OUTPUT ...  (       cursor_index.column_name , ...);
                      END LOOP;


Example


Declare cursor
                              CURSOR emp_cur (pc_deptno NUMBER) IS
                                 SELECT empno, ename
                                 FROM   emp
                                 WHERE  deptno = pc_deptno;
                                   
                      FOR lota IN emp_cur(v_deptno) LOOP
                        DBMS_OUTPUT.PUT_LINE  ('Employee number' || lota.empno || ' is ' || lota.ename);
                      END LOOP;


             Syntax 2 :  
                      FOR cursor_index IN (SELECT statement) LOOP
                        DBMS_OUTPUT ...  (       cursor_index.column_name , ...);
                      END LOOP;

Example:
       FOR lota IN (SELECT empno, ename FROM emp WHERE deptno = v_deptno) LOOP
          DBMS_OUTPUT.PUT_LINE  ('Employee number' || lota.empno || ' is ' || lota.ename);
       END LOOP;

----------- Project Part 6
Q1:

   CREATE OR REPLACE PROCEDURE  p6q1 AS
      CURSOR fac_cur IS
        SELECT f_id, f_last, f_first FROM faculty;
      v_f_id faculty.f_id%TYPE;
      v_f_last faculty.f_last%TYPE;
      v_f_first faculty.f_first%TYPE;
           CURSOR stud_cur(pc_f_id NUMBER) IS
             SELECT s_id, s_last, s_first, s_dob 
             FROM   student
             WHERE  f_id = pc_f_id;
        student_record stud_cur%ROWTYPE;
   BEGIN
     OPEN fac_cur ;
     FETCH fac_cur INTO v_f_id, v_f_last, v_f_first;
       WHILE fac_cur%FOUND LOOP
         DBMS_OUTPUT.PUT_LINE('----------------------');
         DBMS_OUTPUT.PUT_LINE('Faculty # '|| v_f_id || ' is ' || v_f_last || ' ' || v_f_first);
           OPEN stud_cur(v_f_id);
           FETCH stud_cur INTO student_record;
             WHILE stud_cur%FOUND LOOP
               DBMS_OUTPUT.PUT_LINE('Student # '|| student_record.s_id || ' is ' 
                                    || student_record.s_last || ' ' || student_record.s_last
                                    ||  ' born on  ' ||student_record.s_dob);
           FETCH stud_cur INTO student_record;
           END LOOP;
           CLOSE stud_cur;

        FETCH fac_cur INTO v_f_id, v_f_last, v_f_first;
       END LOOP;
     CLOSE fac_cur;
   END;
   /
SET serveroutput on
exec p6q1





-- extra
CREATE OR REPLACE PROCEDURE  p7q1 AS
      CURSOR fac_cur IS
        SELECT f_id, f_last, f_first FROM faculty;
      
   BEGIN
      FOR lota IN fac_cur LOOP
    DBMS_OUTPUT.PUT_LINE('----------Syntax 1------------');
    DBMS_OUTPUT.PUT_LINE('Faculty # '|| lota.f_id || ' is ' || lota.f_last || ' ' || lota.f_first);       
      END LOOP;
   END;
   /
SET serveroutput on
exec p7q1


CREATE OR REPLACE PROCEDURE  p6q2 AS
      CURSOR fac_cur IS
        SELECT c_id, c_last, c_first FROM consultant;
      v_c_id consultant.c_id%TYPE;
      v_c_last consultant.c_last%TYPE;
      v_c_first consultant.c_first%TYPE;
           CURSOR stud_cur(pc_c_id NUMBER) IS
             SELECT cs.c_id, cs.skill_id, certification, skill_description
             FROM   consultant_skill cs, skill s
             WHERE  cs.skill_id = s.skill_id
             AND    c_id = pc_c_id;

        student_record stud_cur%ROWTYPE;
   BEGIN
     OPEN fac_cur ;
     FETCH fac_cur INTO v_c_id, v_c_last, v_c_first;
       WHILE fac_cur%FOUND LOOP
         DBMS_OUTPUT.PUT_LINE('----------------------');
         DBMS_OUTPUT.PUT_LINE('Consultant # '|| v_c_id || ' is ' || v_c_last || ' ' || v_c_first);
           OPEN stud_cur(v_c_id);
           
      FETCH stud_cur INTO student_record;
             WHILE stud_cur%FOUND LOOP
                DBMS_OUTPUT.PUT_LINE('Skill # '|| student_record.skill_id || ' is ' 
                                  || student_record.skill_description || ' Certified Y/N?: ' 
            || student_record.certification);
           FETCH stud_cur INTO student_record;
           END LOOP;
           CLOSE stud_cur;

        FETCH fac_cur INTO v_c_id, v_c_last, v_c_first;
       END LOOP;
     CLOSE fac_cur;
   END;
   /
SET serveroutput on
exec p6q2


CREATE OR REPLACE PROCEDURE  p6q3 AS
      CURSOR item_cur IS
        SELECT item_id, item_desc, cat_id
        FROM    item;
      v_item_id item.item_id%TYPE;
      v_item_desc item.item_desc%TYPE;
      v_cat_id item.cat_id%TYPE;

           CURSOR inv_cur(pc_item_id NUMBER) IS
             SELECT inv_id, inv_price, inv_qoh 
             FROM inventory 
             WHERE  item_id = pc_item_id;

      v_inv_id inventory.inv_id%TYPE;
      v_inv_price inventory.inv_price%TYPE;
      v_inv_qoh inventory.inv_qoh%TYPE;
   BEGIN
     OPEN item_cur ;
     FETCH item_cur INTO v_item_id, v_item_desc, v_cat_id;
       WHILE item_cur%FOUND LOOP
         DBMS_OUTPUT.PUT_LINE('----------------------');
         DBMS_OUTPUT.PUT_LINE('Item # '|| v_item_id || ' is ' || v_item_desc || 
             ' belonged to category number: ' || v_cat_id);
             OPEN inv_cur(v_item_id);
           
             FETCH inv_cur INTO v_inv_id, v_inv_price, v_inv_qoh;
             WHILE inv_cur%FOUND LOOP
                DBMS_OUTPUT.PUT_LINE('inventory # '|| v_inv_id || ' price is ' 
                        || v_inv_price || ' Quatntiy: ' || v_inv_qoh);
             FETCH inv_cur INTO v_inv_id, v_inv_price, v_inv_qoh;
             END LOOP;
           CLOSE inv_cur;

        FETCH item_cur INTO v_item_id, v_item_desc, v_cat_id;
       END LOOP;
     CLOSE item_cur;
   END;
   /
SET serveroutput on
exec p6q3

CREATE OR REPLACE PROCEDURE  p6q4 AS
      CURSOR item_cur IS
        SELECT item_id, item_desc, cat_id
        FROM    item;
      v_item_id item.item_id%TYPE;
      v_item_desc item.item_desc%TYPE;
      v_cat_id item.cat_id%TYPE;

           CURSOR inv_cur(pc_item_id NUMBER) IS
             SELECT inv_id, inv_price, inv_qoh 
             FROM inventory 
             WHERE  item_id = pc_item_id;

      v_inv_id inventory.inv_id%TYPE;
      v_inv_price inventory.inv_price%TYPE;
      v_inv_qoh inventory.inv_qoh%TYPE;
    v_value NUMBER;
    v_item_value NUMBER := 0;
   BEGIN
     OPEN item_cur ;
     FETCH item_cur INTO v_item_id, v_item_desc, v_cat_id;
       WHILE item_cur%FOUND LOOP
         DBMS_OUTPUT.PUT_LINE('----------------------');
        -- DBMS_OUTPUT.PUT_LINE('Item # '|| v_item_id || ' is ' || v_item_desc || 
        --     ' belonged to category number: ' || v_cat_id);
             OPEN inv_cur(v_item_id);
           
             FETCH inv_cur INTO v_inv_id, v_inv_price, v_inv_qoh;
             WHILE inv_cur%FOUND LOOP
                  v_value := v_inv_price * v_inv_qoh;
                  v_item_value := v_item_value + v_value;
                --DBMS_OUTPUT.PUT_LINE('inventory # '|| v_inv_id || ' price is ' 
                 --       || v_inv_price || ' Quatntiy: ' || v_inv_qoh || ' VALUE: ' ||
                 -- v_value);
             FETCH inv_cur INTO v_inv_id, v_inv_price, v_inv_qoh;
             END LOOP;
           CLOSE inv_cur;

    DBMS_OUTPUT.PUT_LINE('Item # '|| v_item_id || ' is ' || v_item_desc ||
            ' Value of Item is: ' || v_item_value ||
             ' belonged to category number: ' || v_cat_id);
         v_item_value := 0;
      OPEN inv_cur(v_item_id);
           
             FETCH inv_cur INTO v_inv_id, v_inv_price, v_inv_qoh;
             WHILE inv_cur%FOUND LOOP
                  v_value := v_inv_price * v_inv_qoh;
                  v_item_value := v_item_value + v_value;
                DBMS_OUTPUT.PUT_LINE('inventory # '|| v_inv_id || ' price is ' 
                        || v_inv_price || ' Quatntiy: ' || v_inv_qoh || ' VALUE: ' ||
                  v_value);
             FETCH inv_cur INTO v_inv_id, v_inv_price, v_inv_qoh;
             END LOOP;
           CLOSE inv_cur;


          v_item_value := 0;
        FETCH item_cur INTO v_item_id, v_item_desc, v_cat_id;
       END LOOP;
     CLOSE item_cur;
   END;
   /
SET serveroutput on
exec p6q4
------------------- PACKAGE -----------------------------

   Package has 2 parts   -- Package Specification
                         -- Package BODY
a/
     Specification
                  Syntax:
    CREATE OR REPLACE PACKAGE name_of_package IS
      declaration variable
      declaration cursor
      declaration procedure of function
    END;

Ex:
    CREATE OR REPLACE PACKAGE order_package IS
      global_inv_id NUMBER(6);
      global_quantity NUMBER(6);
    END;
    /

BEGIN
  order_package.global_inv_id := 7;
  order_package.global_quantity := 2;
END;
/

Ex1:  Create a procedure to display the content of the global variable of the package ORDER_PACKAGE

   CREATE OR REPLACE PROCEDURE ex1 AS
     BEGIN
       DBMS_OUTPUT.PUT_LINE('inv id ' || order_package.global_inv_id);
       DBMS_OUTPUT.PUT_LINE('Quantity ' || order_package.global_quantity);
     END;
   /

Add procedure to the package

  CREATE OR REPLACE PACKAGE order_package IS
      global_inv_id NUMBER(6);
      global_quantity NUMBER(6);
      PROCEDURE create_new_order(current_c_id NUMBER, current_meth_pmt VARCHAR2, 
                                 current_os_id NUMBER);
      PROCEDURE create_new_order_line(current_o_id NUMBER);
    END;
    /

--------------- Package BODY  -----------
   Syntax:
        CREATE OR REPLACE PACKAGE BODY name_of_package IS
              private variable declaration
              UNIT PROGRAM CODE (body of procedure/function)
        END;
        /

CREATE SEQUENCE order_sequence START WITH 7;

CREATE OR REPLACE PACKAGE BODY order_package IS

      PROCEDURE create_new_order(current_c_id NUMBER, current_meth_pmt VARCHAR2, 
                                 current_os_id NUMBER) AS
              current_o_id NUMBER;
            BEGIN
               SELECT order_sequence.NEXTVAL
               INTO   current_o_id
               FROM   dual;
               INSERT INTO orders VALUES(current_o_id, sysdate, current_meth_pmt,
                        current_c_id, current_os_id);
               create_new_order_line(current_o_id);
             COMMIT;
            END create_new_order;

      PROCEDURE create_new_order_line(current_o_id NUMBER) AS
            BEGIN
               INSERT INTO order_line 
               VALUES(current_o_id, global_inv_id, global_quantity);
               COMMIT;
            END create_new_order_line;
    END;
    /

 BEGIN
  order_package.global_inv_id := 1;
  order_package.global_quantity := 100;
END;
/ 

BEGIN
  order_package.create_new_order(4,'CASH',5);
END;
/

EXEC order_package.create_new_order(4,'FAVOR',5)
