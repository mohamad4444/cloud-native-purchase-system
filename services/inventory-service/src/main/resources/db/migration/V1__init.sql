DROP TABLE IF EXISTS lager_item;
CREATE TABLE lager_item (
    id SERIAL PRIMARY KEY,
    product VARCHAR(255),
    quantity INTEGER
);
