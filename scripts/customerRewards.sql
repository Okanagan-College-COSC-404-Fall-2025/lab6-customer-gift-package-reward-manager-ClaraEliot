CREATE TABLE customer_rewards(
    reward_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_email VARCHAR2(255) NOT NULL,
    gift_id NUMBER REFERENCES gift_catalog(gift_id),
    reward_date DATE DEFAULT SYSDATE
);