-- QUESTION 4 
connect des04/des04;

CREATE OR REPLACE FUNCTION does_skill_id_Exist(p_c_id_in IN NUMBER, p_skill_id_in IN NUMBER) RETURN NUMBER AS

v_counter_id NUMBER;
v_counter_skill NUMBER;
v_output NUMBER;

BEGIN

SELECT COUNT(*) 
	INTO v_counter_id
		FROM consultant
			WHERE (c_id = p_c_id_in);
SELECT COUNT(*) 
	INTO v_counter_skill
		FROM skill
			WHERE (skill_id = p_skill_id_in);
			
IF v_counter_skill = 1 AND v_counter_id = 0 THEN
v_output := 2;

ELSIF v_counter_skill = 0 AND v_counter_id = 1 THEN
v_output := 1;

ELSIF v_counter_skill = 0 AND v_counter_id = 0 THEN
v_output := 0;

END IF;

RETURN v_output;
END;
/

SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE insert_or_update(p_consultant_id IN NUMBER, p_skill_id_in IN NUMBER, p_certification_status IN VARCHAR2) AS

v_consultant_first_name VARCHAR2(30);
v_consultant_last_name VARCHAR2(30);
v_skill_description VARCHAR2(50);

v_certification_status VARCHAR2(8);
v_match NUMBER;

ex_wrong_cert_found EXCEPTION;

BEGIN

SELECT c_first, c_last
	INTO v_consultant_first_name, v_consultant_last_name
		FROM consultant
			WHERE c_id = p_consultant_id;
		
SELECT skill_description
	INTO v_skill_description
		FROM skill
			WHERE skill_id = p_skill_id_in;
			


CASE

WHEN p_certification_status = 'Y' THEN
v_certification_status := v_certification_status;

WHEN p_certification_status = 'N' THEN
v_certification_status := v_certification_status;
END CASE;

SELECT COUNT(*) 
	INTO v_match
		FROM consultant_skill
			WHERE c_id = p_consultant_id AND skill_id = p_skill_id_in;
		
IF v_match = 0 THEN
	INSERT 
		INTO consultant_skill (c_id, skill_id, certification)
			VALUES (p_consultant_id, p_skill_id_in, p_certification_status);
			
	DBMS_OUTPUT.PUT_LINE('New entry added to Database!');

ELSE 
	SELECT certification 
		INTO v_certification_status
			FROM consultant_skill
				WHERE c_id = p_consultant_id AND skill_id = p_skill_id_in;
	
	IF  v_certification_status = p_certification_status THEN
	DBMS_OUTPUT.PUT_LINE('Values are the same, no need for update!');

	ELSE
		UPDATE consultant_skill
			SET certification = p_certification_status
				WHERE (c_id = p_consultant_id) AND (skill_id = p_skill_id_in);
				
	DBMS_OUTPUT.PUT_LINE('Database Updated!');
	END IF;
	
END IF;

COMMIT;

DBMS_OUTPUT.PUT_LINE('Consultant first name: ' || v_consultant_first_name || ' - Consultant last name: ' || v_consultant_last_name || ' - Skill Description: ' || v_skill_description);
																		
EXCEPTION

WHEN NO_DATA_FOUND THEN 
IF does_skill_id_Exist(p_consultant_id, p_skill_id_in) = 0 THEN
	DBMS_OUTPUT.PUT_LINE('Both Consultant ID AND Skill ID input do not exist in the database.');

ELSIF does_skill_id_Exist(p_consultant_id, p_skill_id_in) = 1 THEN
	DBMS_OUTPUT.PUT_LINE('Skill ID input does not exist in the database.');	
	
ELSIF does_skill_id_Exist(p_consultant_id, p_skill_id_in) = 2 THEN
	DBMS_OUTPUT.PUT_LINE('Consultant ID input does not exist in the database.');
END IF;

WHEN CASE_NOT_FOUND THEN
DBMS_OUTPUT.PUT_LINE('Certification Status can only be Y or N.');

END;
/
show error
SET SERVEROUTPUT ON
SELECT * FROM consultant_skill;

EXEC insert_or_update(999999,8,'Y');
EXEC insert_or_update(104,999999,'Y');
EXEC insert_or_update(9999999,8121123,'Z');
EXEC insert_or_update(9999999,81231123,'Y');
EXEC insert_or_update(100,2,'ZZZ');
EXEC insert_or_update(101,2,'ZZZZ3r32fd');
EXEC insert_or_update(101,4,'N');

EXEC insert_or_update(100,2,'N');
EXEC insert_or_update(100,2,'N');
EXEC insert_or_update(100,2,'Y');
EXEC insert_or_update(102,8,'Y');

SELECT * FROM consultant_skill;
