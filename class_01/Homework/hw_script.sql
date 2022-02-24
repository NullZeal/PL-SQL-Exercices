CREATE OR REPLACE PROCEDURE hw1(p_price_in IN NUMBER) AS
	v_gst NUMBER;
	v_qst NUMBER;
	v_total NUMBER;
		BEGIN
			v_gst := p_price_in * 0.05;
			v_qst := p_price_in * 0.095;
			v_total := p_price_in + v_gst + v_qst;
				DBMS_OUTPUT.PUT_LINE('For a price of $' || p_price_in || ', you will have to pay $' || v_gst || ' GST, $' || v_qst || ' QST. Your total is $' || v_total);
					END;
						/
			