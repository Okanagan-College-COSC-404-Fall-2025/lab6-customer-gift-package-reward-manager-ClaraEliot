CREATE OR REPLACE TYPE gift_item_table AS TABLE OF VARCHAR2(100);
/

CREATE TABLE gift_catalog(
    gift_id NUMBER PRIMARY KEY,
    min_purchase NUMBER NOT NULL,
    gifts GIFT_ITEM_TABLE
)NESTED TABLE gifts STORE AS gift_catalog_gifts_nt;

INSERT INTO gift_catalog VALUES(
    1,
    100,
    gift_item_table('Stickers', 'Critter Pick Blind Bag')
);

INSERT INTO gift_catalog VALUES(
    2,
    1000,
    gift_item_table('Awoo Awoo Plush', 'Origami Bird Blind Bag', 'Perfume Smaple')
);

INSERT INTO gift_catalog VALUES(
    3,
    10000,
    gift_item_table('Shoulder Bag', 'Impression Series Ear Cuff', 'Chocolate Collection')
);

COMMIT;