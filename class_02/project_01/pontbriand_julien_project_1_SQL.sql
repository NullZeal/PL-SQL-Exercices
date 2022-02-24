--Q1

CREATE OR REPLACE PROCEDURE triple_value (p_value_to_triple IN NUMBER) AS
	v_tripled_value NUMBER;
	BEGIN
		v_tripled_value := p_value_to_triple * 3;
		DBMS_OUTPUT.PUT_LINE('The triple of ' || p_value_to_triple || ' is ' || v_tripled_value || '.');
		END;
			/

EXEC triple_value(333);			



--Q2

CREATE OR REPLACE PROCEDURE convert_celcius_to_fahrenheit (p_temp_celcius IN NUMBER) AS 
	v_temp_fahrenheit NUMBER;
	BEGIN
		v_temp_fahrenheit := (9/5) * p_temp_celcius + 32;
		DBMS_OUTPUT.PUT_LINE(p_temp_celcius || ' degree in C is equivalent to ' || v_temp_fahrenheit || ' in F');
		END;
			/
EXEC convert_celcius_to_fahrenheit(100);			


			
--Q3

CREATE OR REPLACE PROCEDURE convert_fahrenheit_to_celcius (p_temp_fahrenheit IN NUMBER) AS 
	v_temp_celcius NUMBER;
	BEGIN
		v_temp_celcius := (5/9) * (p_temp_fahrenheit - 32);
		DBMS_OUTPUT.PUT_LINE(p_temp_fahrenheit || ' degree in F is equivalent to ' || v_temp_celcius || ' in C');
		END;
			/
			
EXEC convert_fahrenheit_to_celcius(100);			


			
-- Q4

CREATE OR REPLACE PROCEDURE calculate_gst_qst_total (p_initial_price IN NUMBER) AS
	v_gst NUMBER;
	v_qst NUMBER;
	v_tax_total NUMBER;
	v_grand_total NUMBER;
	BEGIN
		v_gst := p_initial_price * 0.05;
		v_qst := p_initial_price * 0.0998;
		v_tax_total := v_gst + v_qst;
		v_grand_total := v_qst + v_gst + p_initial_price;
		DBMS_OUTPUT.PUT_LINE('For the price of $' || p_initial_price);
		DBMS_OUTPUT.PUT_LINE('You will have to pay $' || v_gst || ' GST');
		DBMS_OUTPUT.PUT_LINE('$' || v_qst || ' QST for a total of $' || v_tax_total);
		DBMS_OUTPUT.PUT_LINE('The GRAND TOTAL is $' || v_grand_total);
		END;
		/
		
EXEC calculate_gst_qst_total(100);



-- Q5 

CREATE OR REPLACE PROCEDURE calculate_area_perimeter(p_width IN NUMBER, p_height IN NUMBER) AS
	v_area NUMBER;
	v_perimeter NUMBER;
	BEGIN
		v_area := p_width * p_height;
		v_perimeter := (p_width + p_height) * 2;
		DBMS_OUTPUT.PUT_LINE('The area of a ' || p_width || ' by ' || p_height || ' rectangle is ' || v_area || '. Its perimeter is ' || v_perimeter || '.'); 
		END;
		/
		
EXEC calculate_area_perimeter(6,2);


		
-- Q6 

CREATE OR REPLACE FUNCTION convert_C_to_F (p_temp_celcius IN NUMBER) RETURN NUMBER AS
	v_temp_fahrenheit NUMBER;
	BEGIN
		v_temp_fahrenheit := (9/5) * p_temp_celcius + 32;
		RETURN v_temp_fahrenheit;
		END;
		/

DROP TABLE temperature_in_C;
CREATE TABLE temperature_in_C(temp_id NUMBER, temp_in_C NUMBER);
INSERT INTO temperature_in_C (temp_id, temp_in_C) VALUES (1, 100);
INSERT INTO temperature_in_C (temp_id, temp_in_C) VALUES (2, 150);
INSERT INTO temperature_in_C (temp_id, temp_in_C) VALUES (3, 200);
SELECT temp_id, temp_in_C, convert_C_to_F(temp_in_C) Converted_in_F FROM temperature_in_C;



-- Q7		
		
CREATE OR REPLACE FUNCTION convert_F_to_C (p_temp_fahrenheit IN NUMBER) RETURN NUMBER AS
	v_temp_celcius NUMBER;
	BEGIN
		v_temp_celcius := (5/9) * (p_temp_fahrenheit - 32);
		RETURN v_temp_celcius;
		END;
		/
		
DROP TABLE temperature_in_F;
CREATE TABLE temperature_in_F(temp_id NUMBER, temp_in_F NUMBER);
INSERT INTO temperature_in_F (temp_id, temp_in_F) VALUES (1, 100);
INSERT INTO temperature_in_F (temp_id, temp_in_F) VALUES (2, 150);
INSERT INTO temperature_in_F (temp_id, temp_in_F) VALUES (3, 200);
SELECT temp_id, temp_in_F, convert_F_to_C(temp_in_F) Converted_in_C FROM temperature_in_F;
