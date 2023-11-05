USE Sales2;
CREATE TABLE sales
(
	purchase_number INT AUTO_INCREMENT,
    date_of_purchase DATE NOT NULL,
    customer_id INT,
    item_code VARCHAR(10),
PRIMARY KEY(purchase_number)
    );
DROP TABLE customers;
CREATE TABLE customers
(
	customer_id INT AUTO_INCREMENT,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email_address VARCHAR(255),
    number_of_complaints INT,
PRIMARY KEY (customer_id)
);
CREATE TABLE items
(
	item_code VARCHAR(255),
    item VARCHAR(255),
    unit_price NUMERIC(10,2),
PRIMARY KEY (item_code)
);    
CREATE TABLE companies
(
    company_id VARCHAR(255) Default "X",
    company_name VARCHAR(255),
    headquarters_phone_number VARCHAR(255),
Primary Key (company_id),
UNIQUE KEY (headquarters_phone_number)
);    

ALTER TABLE sales
ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE;

DROP TABLE sales;
DROP TABLE customers;
DROP TABLE items;
drop table companies;

Alter table customers
Add unique key (email_address);

alter table customers
ADD COLUMN gender ENUM('M','F') AFTER last_name;
Insert into customers (first_name, last_name, gender, email_address, number_of_complaints)
Values('John', 'Mackinley', 'M', 'john.mckinley@365careers.com', 0);
alter table customers
change column number_of_complaints number_of_complaints INT DEFAULT 0;

insert into customers (first_name, last_name, gender)
values ('Peter', 'Figaro', 'M');

Select * from customers;

alter table companies
change column headquarters_phone_number headquarters_phone_number varchar(255) NOT NULL;

alter table companies
change column company_id company_id INT auto_increment;

Insert into companies (headquarters_phone_number, company_name)
values ('+1 (202) 555-0196', 'Company A');

Select * from companies;

Drop database Sales;
