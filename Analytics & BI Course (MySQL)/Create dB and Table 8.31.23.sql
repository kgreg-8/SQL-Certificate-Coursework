CREATE DATABASE IF NOT EXISTS Sales;
USE Sales2;
CREATE TABLE Sales2
(
	purchase_number INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    date_of_purchase DATE NOT NULL,
    customer_id INT,
    item_code VARCHAR(10) NOT NULL
    );