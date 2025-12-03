CREATE OR REPLACE PACKAGE customer_manager AS

    FUNCTION get_total_purchase(p_customer_id NUMBER) RETURN NUMBER;

    PROCEDURE assign_gifts_to_all;

END customer_manager;
/

CREATE OR REPLACE PACKAGE BODY customer_manager AS

    FUNCTION choose_gift_package(p_total_purchase NUMBER) RETURN NUMBER AS
        v_gift_id GIFT_CATALOG.gift_id%TYPE;

    BEGIN
        CASE 
            WHEN p_total_purchase IS NULL THEN
                RETURN NULL;
            WHEN p_total_purchase < 0 THEN
                RETURN NULL;
            ELSE
                NULL;
        END CASE;
        
        SELECT gift_id INTO v_gift_id
        FROM (
            SELECT gift_id
            FROM gift_catalog
            WHERE min_purchase <= p_total_purchase
            ORDER BY min_purchase DESC
        )
        WHERE ROWNUM = 1;

        RETURN v_gift_id;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;

    END choose_gift_package;

    FUNCTION get_total_purchase(p_customer_id NUMBER) RETURN NUMBER AS
        v_total NUMBER;

    BEGIN
        SELECT NVL(SUM(oi.unit_price * oi.quantity), 0) INTO v_total
        FROM orders o, order_items oi
        WHERE o.order_id = oi.order_id AND
                o.customer_id = p_customer_id AND
                o.order_status = 'COMPLETE';

        RETURN v_total;
    
    END get_total_purchase;

    PROCEDURE assign_gifts_to_all AS
        CURSOR c_customers IS
            SELECT customer_id, email_address
            FROM customers;
        
        v_total NUMBER;
        v_gift_id NUMBER;
    
    BEGIN
        FOR rec IN c_customers LOOP
            v_total := get_total_purchase(rec.customer_id);
            v_gift_id := choose_gift_package(v_total);

            IF v_gift_id IS NOT NULL THEN
                INSERT INTO customer_rewards (customer_email, gift_id)
                VALUES (rec.email_address, v_gift_id);
            END IF;
        END LOOP;

        COMMIT;
    
    END assign_gifts_to_all;

END customer_manager;
/