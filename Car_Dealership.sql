
CREATE TABLE salesperson (
  salesperson_id SERIAL PRIMARY KEY,
  first_name VARCHAR(200) NOT NULL,
  last_name VARCHAR(200) NOT NULL,
  email VARCHAR(200),
  phone VARCHAR(20)
);

CREATE TABLE customer (
  customer_id SERIAL PRIMARY KEY,
  first_name VARCHAR(200) NOT NULL,
  last_name VARCHAR(200) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  email VARCHAR(200) NULL,
  address VARCHAR(200) NULL,
  new_customer BOOLEAN
);

CREATE TABLE car (
  car_id SERIAL PRIMARY KEY,
  year INT NOT NULL,
  make VARCHAR(200) NOT NULL,
  model VARCHAR(200) NOT NULL,
  color VARCHAR(200) NOT NULL,
  new_or_used VARCHAR(200) NULL,
  price NUMERIC(10,2) NULL,
  service BOOLEAN NULL,
  salesperson_id INT NULL,
  customer_id INT NULL,
  FOREIGN KEY (salesperson_id) REFERENCES salesperson(salesperson_id),
  FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);


CREATE TABLE service_ticket (
  ticket_id SERIAL PRIMARY KEY,
  description VARCHAR(200) NOT NULL,
  solution VARCHAR(200),
  last_update TIMESTAMP NOT NULL DEFAULT NOW(),
  car_id INT NOT NULL,
  FOREIGN KEY(car_id) REFERENCES car(car_id)
);


CREATE TABLE mechanic (
  mechanic_id SERIAL PRIMARY KEY,
  first_name VARCHAR(200) NOT NULL,
  last_name VARCHAR(200) NOT NULL,
  phone VARCHAR(20),
  email VARCHAR(200),
  expertise VARCHAR(200)
);

CREATE TABLE service_history (
  service_history_id SERIAL PRIMARY KEY,
  date TIMESTAMP NOT NULL,
  description VARCHAR(200) NOT NULL,
  cost NUMERIC(10,2) NOT NULL,
  car_id INT NOT NULL,
  FOREIGN KEY(car_id) REFERENCES car(car_id)
);

CREATE TABLE maintenance (
    maintenance_id SERIAL PRIMARY KEY,
    mechanic_id INT NOT NULL,
    ticket_id INT NOT NULL,
    car_id INT NOT NULL,
    assigned_date TIMESTAMP NOT NULL DEFAULT NOW(),
    completed_date TIMESTAMP,
    FOREIGN KEY(mechanic_id) REFERENCES mechanic (mechanic_id),
    FOREIGN KEY(ticket_id) REFERENCES service_ticket(ticket_id),
    FOREIGN KEY(car_id) REFERENCES car (car_id)
);

CREATE TABLE invoice (
  invoice_id SERIAL PRIMARY KEY,
  date TIMESTAMP NOT NULL,
  amount NUMERIC(10,2) NOT NULL,
  salesperson_id INT NOT NULL,
  customer_id INT NOT NULL,
  car_id INT NOT NULL,
  FOREIGN KEY(salesperson_id) REFERENCES salesperson(salesperson_id),
  FOREIGN KEY(customer_id) REFERENCES customer(customer_id),
  FOREIGN KEY(car_id) REFERENCES car(car_id)
);



CREATE OR REPLACE PROCEDURE add_new_salesperson(
  first_name VARCHAR(200),
  last_name VARCHAR(200),
  email VARCHAR(200),
  phone VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO salesperson (first_name, last_name, email, phone)
  	VALUES (first_name, last_name, email, phone);
END;
$$;

CALL add_new_salesperson ('Apollo', 'Jupiter','@gmail.com','4242742370');
CALL add_new_salesperson ('Anthony', 'Vodovva','donkeysong@yahoo.com','424-464-7454');

---------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE add_customer(
  first_name VARCHAR(200),
  last_name VARCHAR(200),
  phone VARCHAR(20),
  email VARCHAR(200),
  address VARCHAR(200),
  new_customer BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO customer(first_name, last_name, email, phone, address, new_customer)
  	VALUES (first_name, last_name, email, phone, address, new_customer);
END;
$$;

CALL add_customer('Sammy', 'Jones','123-456-7890', 'sammy@aol.com','123 North 10th Ave',TRUE);

INSERT INTO customer(first_name, last_name, phone, address, new_customer) 
VALUES ('Davis', 'Sweeny', '234-567-8910','743 Abbey Lane',FALSE);

CALL add_customer('Kate','Dawson','345-678-9012','dawss@gmail.com','n/a',FALSE);

INSERT INTO customer(first_name, last_name, phone, email, address, new_customer) 
VALUES ('Bianca', 'Adams', '456-789-0123','bbbabe@yahoo.com','12 Gray St.',TRUE);

-----------------------------------------------------------------
CREATE OR REPLACE PROCEDURE add_car_sale(
  year INT, 
  make VARCHAR(200), 
  model VARCHAR(200), 
  color VARCHAR(200), 
  price NUMERIC(10,2),
  service BOOLEAN,
  new_or_used VARCHAR(4),
  salesperson_id INT,
  customer_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO car (year, make, model, color, price,service, new_or_used, salesperson_id, customer_id)
  	VALUES (year, make, model, color, price,service, new_or_used, salesperson_id, customer_id);
END;
$$;

CALL add_car_sale(2023, 'Toyota', 'Tacoma', 'Blue', 39000.00,FALSE,'new',1,1);
CALL add_car_sale(2019, 'Jeep', 'Compass', 'White', 25000.00,FALSE,'used',2,2);

-----------------------------------------------------------------
CREATE OR REPLACE PROCEDURE serviced_vehicle(
  service BOOLEAN,
  year INT, 
  make VARCHAR(200), 
  model VARCHAR(200), 
  color VARCHAR(200),
  new_or_used VARCHAR(4),
  customer_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO car (service, year, make, model, color, new_or_used, customer_id)
  	VALUES (service, year, make, model, color, new_or_used, customer_id);
END;
$$;
CALL serviced_vehicle(TRUE,2016, 'GMC', 'Arcadia', 'Blue','used', 3);
CALL serviced_vehicle(TRUE,2019, 'Chevy', 'Malibu', 'Gold','used', 4);

-----------------------------------------------------------------
CREATE OR REPLACE PROCEDURE add_service_ticket(
  description VARCHAR(200),
  solution VARCHAR(200),
  car_id INT,
  last_update TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO service_ticket (description, solution, car_id, last_update)
  VALUES (description, solution, car_id, last_update);
END;
$$;
-- Explicit type cast --  
CALL add_service_ticket('oil_change'::VARCHAR, 'changed'::VARCHAR, 3::INT, now()::TIMESTAMP);

INSERT INTO service_ticket (description, solution, car_id,last_update)
VALUES('alternator', 'replaced', 4, now());

-----------------------------------------------------------------
INSERT INTO mechanic (first_name, last_name, phone, expertise)
VALUES('Adrian', 'Brody','567-890-1234','motor');

INSERT INTO mechanic (first_name, last_name, phone, email, expertise)
VALUES('Beyonce', 'Carter','678-901-2345','queenbee@gmail.com','alternators');

INSERT INTO mechanic (first_name, last_name, phone, email, expertise)
VALUES('Norah', 'Jones','789-012-3456','nearnessofyou@aol.com','electical');

-----------------------------------------------------------------
CREATE OR REPLACE PROCEDURE add_service_history(
  date TIMESTAMP, 
  description VARCHAR(200), 
  cost NUMERIC(10,2),
  car_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO service_history (date, description, cost, car_id)
  	VALUES (date, description, cost, car_id);
END;
$$;

CALL add_service_history('2024-12-24 ', 'oil_change', 150.90, 3);
CALL add_service_history('2024-01-04 ', 'alternator_repair', 550.00, 4);

-----------------------------------------------------------------
CREATE OR REPLACE PROCEDURE add_maintenance(
  mechanic_id INT, 
  ticket_id INT,
  car_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO maintenance (mechanic_id, ticket_id, car_id)
    VALUES (mechanic_id, ticket_id, car_id);
END;
$$;

CALL add_maintenance(1, 1, 3);
CALL add_maintenance(2, 2, 4);

-----------------------------------------------------------------
CREATE OR REPLACE PROCEDURE add_invoice(
  date TIMESTAMP, 
  amount NUMERIC(10,2),
  salesperson_id INT,
  customer_id INT,
  car_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO invoice (date, amount, salesperson_id, customer_id, car_id)
    VALUES (date, amount, salesperson_id, customer_id, car_id);
END;
$$;

CALL add_invoice('2024-01-07 ',39000.00, 1, 1, 1);
CALL add_invoice('2024-01-02 ',25000.00, 2, 2, 2);