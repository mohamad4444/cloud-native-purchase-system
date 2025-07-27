DROP TABLE IF EXISTS purchases;
CREATE TABLE purchases (
       id SERIAL PRIMARY KEY,
       lager_item_id BIGINT NOT NULL,
       product_name VARCHAR(100) NOT NULL,
       quantity INT NOT NULL,
       timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
