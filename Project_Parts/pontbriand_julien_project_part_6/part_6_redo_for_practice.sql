CREATE OR REPLACE PROCEDURE P6Q1 AS

CURSOR fac_cur IS
SELECT f_id, f_first, f_last
FROM faculty;

fac_record fac_cur%ROWTYPE;

CURSOR stud_cur(pc_f_id NUMBER) IS
SELECT s_id, s_first, s_last
FROM student
WHERE f_id = pc_f_id;

stud_record stud_cur%ROWTYPE;

BEGIN

OPEN fac_cur;

FETCH fac_cur INTO fac_record;

WHILE fac_cur%FOUND LOOP
    DBMS_OUTPUT.PUT_LINE('Faculty ID: ' || fac_record.f_id || ' - First Name:' || fac_record.f_first || ' - Last Name: ' || fac_record.f_last);
    DBMS_OUTPUT.PUT_LINE('-----------------');

    OPEN stud_cur(fac_record.f_id);
    FETCH stud_cur INTO stud_record;
    WHILE stud_cur%FOUND LOOP
        DBMS_OUTPUT.PUT_LINE('Student ID: ' || stud_record.s_id || ' - First Name: ' ||stud_record.s_first || ' - Last Name: ' || stud_record.s_last);
    FETCH stud_cur INTO stud_record;
    IF stud_cur%NOTFOUND THEN
    DBMS_OUTPUT.PUT_LINE('|');
    END IF;
    END LOOP;
    CLOSE stud_cur;
    
    FETCH fac_cur INTO fac_record;
END LOOP;
END;
/
exec P6Q1;





CREATE OR REPLACE PROCEDURE P6Q2 AS

v_current_consultant_id NUMBER;

BEGIN

FOR cur_index IN (
    SELECT c_id, c_first, c_last
        FROM CONSULTANT
) LOOP
v_current_consultant_id := cur_index.c_id;

DBMS_OUTPUT.PUT_LINE('Consultant ID: ' || cur_index.c_id);

    FOR cur_index IN (
        SELECT cs.c_id, cs.skill_id, cs.certification, s.skill_description
            FROM skill s
                JOIN consultant_skill cs
                    ON s.skill_id = cs.skill_id
                        WHERE cs.c_id = v_current_consultant_id
    ) LOOP
    
    DBMS_OUTPUT.PUT_LINE('Skill ID: ' || cur_index.skill_id);
    END LOOP;

END LOOP;
END;
/
EXEC P6Q2;




--
connect des02/des02;

CREATE OR REPLACE PROCEDURE P6Q3 AS

var_current_item_id NUMBER;

BEGIN

FOR cur_index IN 
(
    SELECT item_id, item_desc
        FROM item
) LOOP

var_current_item_id := cur_index.item_id;

DBMS_OUTPUT.PUT_LINE('Item ID : ' || cur_index.item_id || ' - Item Desc : ' || cur_index.item_desc);

DBMS_OUTPUT.PUT_LINE('|');

    FOR cur_index IN 
    (
        SELECT inv_id, inv_qoh, inv_price
            FROM inventory
                WHERE item_id = var_current_item_id
    ) LOOP
    DBMS_OUTPUT.PUT_LINE('Inventory ID: ' || cur_index.inv_id);
    END LOOP;

END LOOP;
END;
/
EXEC P6Q3;