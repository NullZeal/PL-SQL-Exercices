-----Q1
connect des02/des02;

CREATE OR REPLACE VIEW specific_inventory_item_view AS
SELECT item.item_desc, inventory.item_id, inventory.inv_price, inventory.color, inventory.inv_id, inventory.inv_size
FROM   item, inventory
WHERE  item.item_id = inventory.item_id;

--TESTING INSERT BEFORE INSTEAD OF TRIGGER

INSERT INTO specific_inventory_item_view(item_desc, item_id, inv_price, color, inv_id, inv_size) VALUES ('testdesc', 888, 888, 'testcolor', 888, 'Z');

--TESTING UPDATE BEFORE INSTEAD OF TRIGGER

UPDATE des02.specific_inventory_item_view
  SET   item_desc = '3-Season TentZZZZZ'
  WHERE inv_price = 259.99;

CREATE OR REPLACE TRIGGER insteadof_update_insert_cw
INSTEAD OF UPDATE OR INSERT 
ON specific_inventory_item_view
FOR EACH ROW
BEGIN
    IF UPDATING THEN
        UPDATE inventory
        SET 
            inv_id  = :NEW.inv_id,
            inv_price = :NEW.inv_price,
            color = :NEW.color,
            inv_size = :NEW.inv_size,
            item_id = :NEW.item_id
        WHERE inv_id = :NEW.inv_id;

        UPDATE item
        SET    item_desc = :NEW.item_desc
        WHERE  item_id = :NEW.item_id;

    ELSIF INSERTING THEN

        INSERT INTO item(item_id, item_desc) 
        VALUES (:NEW.item_id, :NEW.item_desc);
        
        INSERT INTO inventory(inv_id, inv_price, color, inv_size, item_id)
        VALUES(:NEW.inv_id, :NEW.inv_price, :NEW.color, :NEW.inv_size, :NEW.item_id);

  END IF;
  END;
/

SELECT * FROM specific_inventory_item_view;

--TESTING INSERT AFTER INSTEAD OF TRIGGER

INSERT INTO specific_inventory_item_view(item_desc, item_id, inv_price, color, inv_id, inv_size) 
VALUES ('testdesc', 888, 888, 'Blue', 99, 'Z');

--TESTING UPDATE AFTER INSTEAD OF TRIGGER

UPDATE des02.specific_inventory_item_view
  SET   item_desc = '3-Season TentZZZZZ'
  WHERE inv_price = 259.99;


SELECT * FROM specific_inventory_item_view;

----Q2

connect des03/des03;
set linesize 300

CREATE OR REPLACE VIEW course_student_view AS
SELECT  course.course_id, student.s_id, course.course_name, course.credits, student.s_last, 
        student.s_first, course_section.c_sec_id, course_section.sec_num, course_section.term_id, course_section.max_enrl, enrollment.grade
FROM course, student, course_section, enrollment
WHERE   enrollment.s_id = student.s_id
AND enrollment.c_sec_id = course_section.c_sec_id
AND enrollment.s_id = student.s_id
AND course_section.course_id = course.course_id;

--TESTING INSERT BEFORE INSTEAD OF TRIGGER

INSERT INTO des03.course_student_view(course_name, credits, s_last, s_first, c_sec_id, sec_num, grade) 
VALUES ('DATABASE2', 499, 'Pontbriand', 'Julien', 399, '299', 'A');

--TESTING UPDATE BEFORE INSTEAD OF TRIGGER

UPDATE des03.course_student_view
  SET   course_name = 'Haloween Fun'
  WHERE grade = 'B';

CREATE OR REPLACE TRIGGER insteadof_update_insert_csv
INSTEAD OF UPDATE OR INSERT 
ON course_student_view
FOR EACH ROW
BEGIN
    IF UPDATING THEN
        UPDATE course
        SET
        course_name = :NEW.course_name,
        credits = :NEW.credits
        WHERE course_id = :NEW.course_id;

        UPDATE student
        SET
        s_last = :NEW.s_last,
        s_first = :NEW.s_first
        WHERE s_id = :NEW.s_id;
        
        UPDATE course_section
        SET
        c_sec_id = :NEW.c_sec_id,
        sec_num = :NEW.sec_num
        WHERE c_sec_id = :NEW.c_sec_id;
        
        UPDATE enrollment
        SET
        grade = :NEW.grade
        WHERE s_id = :NEW.s_id AND c_sec_id = :NEW.c_sec_id;

    ELSIF INSERTING THEN

        INSERT INTO course(course_id, course_name, credits) 
        VALUES (:NEW.course_id, :NEW.course_name, :NEW.credits);

        INSERT INTO student(s_id, s_last, s_first) 
        VALUES (:NEW.s_id, :NEW.s_last, :NEW.s_first);

        INSERT INTO course_section(c_sec_id, course_id, term_id, max_enrl, sec_num) 
        VALUES (:NEW.c_sec_id, :NEW.course_id, :NEW.term_id, :NEW.max_enrl, :NEW.sec_num);

        INSERT INTO enrollment(s_id, c_sec_id, grade) 
        VALUES (:NEW.s_id, :NEW.c_sec_id, :NEW.grade);
        
  END IF;
END;
/

SELECT * from course_student_view;

--TESTING INSERT AFTER INSTEAD OF TRIGGER

INSERT INTO des03.course_student_view(course_id, s_id, course_name, credits, s_last, s_first, c_sec_id, max_enrl, term_id, sec_num, grade) 
VALUES (15, 55, 'SUPER DATABASE CLASS', 42, 'Pontbriandhi', 'Juliani', 40, 3, 5, 12, 'A');

--TESTING UPDATE AFTER INSTEAD OF TRIGGER

UPDATE des03.course_student_view
  SET   credits = 12
  WHERE course_id = 1;

--RESULT OF UPDATE AND INSERT IN STUDENT AND COURSE TABLES

SELECT * from course_student_view;
