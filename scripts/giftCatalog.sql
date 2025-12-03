CREATE OR REPLACE PROCEDURE show_first_five_rewards AS
    v_gift_list VARCHAR2(4000);
BEGIN
    DBMS_OUTPUT.PUT_LINE('EMAIL | GIFT_ID | MIN_PURCHASE | GIFTS');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------');

    FOR rec IN(
        SELECT cr.customer_email, gc.gift_id, gc.min_purchase, gc.gifts
        FROM customer_rewards cr, gift_catalog gc
        WHERE cr.gift_id = gc.gift_id
        ORDER BY cr.reward_id
        FETCH FIRST 5 ROWS ONLY
    ) LOOP
        v_gift_list := '{ ';

        IF rec.gifts IS NOT NULL THEN
            FOR i IN 1 .. rec.gifts.COUNT LOOP
                v_gift_list := v_gift_list || '''' || rec.gifts(i) || '''';
                IF i < rec.gifts.COUNT THEN
                    v_gift_list := v_gift_list || ', ';
                END IF;
            END LOOP;
        END IF;

        v_gift_list := v_gift_list || ' }';

        DBMS_OUTPUT.PUT_LINE(
            rec.customer_email || ' | ' ||
            rec.gift_id || ' | ' ||
            rec.min_purchase || ' | ' ||
            v_gift_list
        );
    END LOOP;
END;
/