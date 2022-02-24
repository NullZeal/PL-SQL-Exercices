SET SERVEROUTPUT ON

CREATE OR REPLACE FUNCTION does_Skill_SkillID_Exist(p_skill_id NUMBER) RETURN BOOLEAN AS

COUNTER NUMBER;

BEGIN

SELECT COUNT(*) 
	INTO COUNTER
		FROM skill
			WHERE (skill_id = p_skill_id);

IF( COUNTER = 0 )
  THEN
	RETURN FALSE;
ELSE
	RETURN TRUE;
END IF;
END;
/

CREATE OR REPLACE FUNCTION does_Consultant_CID_Exist(p_consultant_id NUMBER) RETURN BOOLEAN AS

COUNTER NUMBER;

BEGIN

SELECT COUNT(*) 
	INTO COUNTER
		FROM consultant
			WHERE (c_id = p_consultant_id);

IF( COUNTER = 0 )
  THEN
	RETURN FALSE;
ELSE
	RETURN TRUE;
END IF;
END;
/


CREATE OR REPLACE FUNCTION does_CID_SKILLID_MatchExist(p_consultant_id NUMBER, p_skill_id NUMBER) RETURN BOOLEAN AS

COUNTER NUMBER;

BEGIN

SELECT COUNT(*) 
	INTO COUNTER
		FROM consultant_skill
			WHERE (c_id = p_consultant_id) AND (skill_id = p_skill_id);

IF( COUNTER = 0 )
  THEN
	RETURN FALSE;
ELSE
	RETURN TRUE;
END IF;
END;
/

SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE insert_or_update(p_consultant_id IN NUMBER, p_skillid IN NUMBER, p_certification_status IN VARCHAR2) AS

v_c_id_match NUMBER;
v_certification VARCHAR2(20);

v_consultant_first_name VARCHAR2(30);
v_consultant_last_name VARCHAR2(30);
v_skill_description VARCHAR2(50);

BEGIN

CASE 
	WHEN p_certification_status = 'Y' THEN
		v_certification := v_certification;
	
	WHEN p_certification_status = 'N' THEN
		v_certification := v_certification;
END CASE;

IF (does_Consultant_CID_Exist(p_consultant_id) = FALSE) AND (does_Skill_SkillID_Exist(p_skillid) = FALSE) THEN
	DBMS_OUTPUT.PUT_LINE('Both Consultant ID and skill ID are not present in the database.');

ELSIF does_Consultant_CID_Exist(p_consultant_id) = FALSE THEN
	DBMS_OUTPUT.PUT_LINE('Consultant Id input is not present in the database.');
	
ELSIF does_Skill_SkillID_Exist(p_skillid) = FALSE THEN 
	DBMS_OUTPUT.PUT_LINE('Skill ID input is not present in the database.');
	
ELSIF does_CID_SKILLID_MatchExist(p_consultant_id, p_skillid) = FALSE THEN
	INSERT 
		INTO consultant_skill (c_id, skill_id, certification)
			VALUES (p_consultant_id, p_skillid, p_certification_status);
			
	DBMS_OUTPUT.PUT_LINE('New entry added to Database!');

ELSE 
	UPDATE consultant_skill
		SET c_id = p_consultant_id,
			skill_id = p_skillid,
			certification = p_certification_status
				WHERE (c_id = p_consultant_id) AND (skill_id = p_skillid);
				
	DBMS_OUTPUT.PUT_LINE('Database Updated!');
	
END IF;

SELECT c_first, c_last
	INTO v_consultant_first_name, v_consultant_last_name
		FROM consultant
			WHERE c_id = p_consultant_id;
		
SELECT skill_description
	INTO v_skill_description
		FROM skill
			WHERE skill_id = p_skillid;


DBMS_OUTPUT.PUT_LINE('Consultant first name: ' || v_consultant_first_name || ' - Consultant last name: ' || v_consultant_last_name || ' - Skill Description: ' || v_skill_description);
								
COMMIT;
											
EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('Warning - An attempt to retrieve a specific data from the database has failed. Look for previous error message.');
WHEN CASE_NOT_FOUND THEN
DBMS_OUTPUT.PUT_LINE('Certification input incorrect. It should be either Y or N .');
-- WHEN OTHERS THEN
-- DBMS_OUTPUT.PUT_LINE('An error has occured. ');

END;
/
show error

EXEC insert_or_update(100,2,'N');
EXEC insert_or_update(100,2,'N');
EXEC insert_or_update(101,2,'ZZZZ');
EXEC insert_or_update(102,8,'Y');
EXEC insert_or_update(10023123213123,8,'Y');
EXEC insert_or_update(104,81231231231123,'Y');
EXEC insert_or_update(9999999999999999,81231231231123,'Z');
EXEC insert_or_update(9999999999999999,81231231231123,'Y');




SCOTT

7 CLEAR WATER

7NORTHWOODS

7SOFTWARE