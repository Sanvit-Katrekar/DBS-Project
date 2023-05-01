USE canteen;

create table product(
	pid int,
	p_name varchar(255),
	p_price float,
	p_quantity int,
	veg bool,
	meal_time varchar(255),
	primary key(pid)
);

#veg-1 otherwise nonveg 0
#meal time-creates views based on lunch,all time and breakfast(beverage comes under all time)


create table orders1(
	ord_id int,
	pid int,
    cust_id VARCHAR(15),
	offer float,
	primary key(ord_id),
	foreign key(pid) references product(pid)
);



CREATE TABLE CanteenStaff AS (
	SELECT e_id AS staff_id,
    SUBSTRING_INDEX(full_name,' ', 1) AS fname,
    SUBSTRING_INDEX(full_name,' ', -1) AS lname,
    phone,
    designation
    FROM campus.master_employee
    WHERE management = 'canteen'
);
ALTER TABLE CanteenStaff ADD PRIMARY KEY (staff_id);
ALTER TABLE CanteenStaff ADD FOREIGN KEY (phone) REFERENCES campus.master_employee(phone) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE CanteenStaff ADD UNIQUE (phone);
ALTER TABLE CanteenStaff ADD COLUMN cant_id INT;

SELECT * FROM canteen.CanteenStaff;

create table init_products(
	sup_pid int,
	product_names varchar(255)
);

create table suppliers(
	sup_id int,
	sup_name varchar(255),
	sup_address varchar(255),
	sup_pid int,
	sup_prices float,
	primary key(sup_id),
	foreign key(sup_pid) references init_products(sup_pid)
);
CREATE INDEX idx_canteen_sup_pid ON init_products(sup_pid);

create table canteen(
	cant_name varchar(255),
	cant_id int,
	rent int,
	emp_no int,
	monthly_cost int,
	monthly_sales int,
	closing_stock int,
	sup_id int,
	purchase_date_from_sup date,
	primary key(cant_id),
	foreign key(sup_id) references suppliers(sup_id)
);

DELIMITER $$
CREATE PROCEDURE add_staff(IN staff_id VARCHAR(15))
BEGIN
	IF EXISTS(SELECT e_id, management FROM campus.master_employee WHERE e_id = staff_id AND management IS NULL) THEN
	UPDATE campus.master_employee SET management = 'canteen' WHERE e_id = staff_id;
    ELSE SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot add employee to Canteen Staff';
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE add_staff_to_cant(IN e_id VARCHAR(15), IN canteen_id INT)
BEGIN
	IF EXISTS(SELECT staff_id FROM CanteenStaff WHERE staff_id = e_id) AND EXISTS (SELECT cant_id FROM canteen WHERE cant_id = canteen_id) THEN
	UPDATE CanteenStaff SET cant_id = canteen_id WHERE staff_id = e_id;
    END IF;
END $$
DELIMITER ;


SELECT * FROM campus.master_employee;
SELECT * FROM CanteenStaff;
USE canteen;

CREATE VIEW veg1 AS (SELECT p_name, p_price FROM Product WHERE veg = 1);
delimiter :
 create trigger show_veg
 after insert on product
 for each row
 begin 
	if new.veg = 1 then insert into veg1 values (new.p_name, new.p_price);
    end if;
end :
delimiter ;

CREATE VIEW nonveg1 AS (SELECT p_name, p_price FROM Product WHERE veg = 0);
delimiter :
 create trigger show_nonveg
 after insert on product
 for each row 
 begin 
	if new.veg = 0 then insert into nonveg1 values (new.p_name, new.p_price);
    end if;
end :
delimiter ;
 

create view lunch as (select p_name, p_price from product where meal_time="L" or meal_time="l")
delimiter :
create trigger show_lunch_menu
 after insert on product
 for each row 
 begin 
	if new.meal_time="L" or new.meal_time="l" then insert into lunch values (new.p_name, new.p_price);
    end if;
end :
delimiter ;

create view breakfast as (select p_name, p_price from product where meal_time="B" or meal_time="b");
delimiter :
 create trigger show_breakfast_menu
 after insert on product
 for each row 
 begin 
 	if new.meal_time="B" or new.meal_time="b" then insert into breakfast values (new.p_name, new.p_price);
    end if;
end :
delimiter ;

create view all_time as (select p_name, p_price from product where meal_time="A" or meal_time="a");
delimiter :
 create trigger show_all_menu
 after insert on product
 for each row 
 begin 
 	if new.meal_time="A" or new.meal_time="a" then insert into breakfast values (new.p_name, new.p_price);
    end if;
end :
delimiter ;
