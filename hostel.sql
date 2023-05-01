DROP DATABASE IF EXISTS hostel;
CREATE DATABASE hostel;
USE hostel;

CREATE TABLE HostlersInfo AS (
	SELECT s_id,
    SUBSTRING_INDEX(full_name,' ', 1) AS fname,
    SUBSTRING_INDEX(full_name,' ', -1) AS lname,
    emirates_id,
    passport_no,
    phone
    FROM campus.master_student
    WHERE is_hosteler = TRUE
);
ALTER TABLE HostlersInfo ADD PRIMARY KEY (s_id);
ALTER TABLE HostlersInfo ADD FOREIGN KEY (emirates_id) REFERENCES campus.master_student(emirates_id) ON DELETE CASCADE;
ALTER TABLE HostlersInfo
	ADD UNIQUE (emirates_id),
    ADD UNIQUE (passport_no),
    ADD UNIQUE (phone);
ALTER TABLE HostlersInfo ADD FOREIGN KEY (emirates_id) REFERENCES campus.master_student(emirates_id) ON DELETE CASCADE ON UPDATE CASCADE;

SELECT * FROM HostlersInfo;

DELIMITER $$
CREATE TRIGGER remove_student
AFTER DELETE ON HostlersInfo FOR EACH ROW
BEGIN
	UPDATE campus.master_student SET is_hosteler = FALSE WHERE s_id = OLD.s_id;
END $$
DELIMITER ;

SHOW TRIGGERS;

DELIMITER $$
CREATE PROCEDURE add_student(IN student_id VARCHAR(15))
BEGIN
	IF EXISTS(SELECT s_id, is_hosteler FROM campus.master_student WHERE s_id = student_id AND is_hosteler = 0) THEN
	UPDATE campus.master_student SET is_hosteler = 1 WHERE s_id = student_id;
    END IF;
END $$
DELIMITER ;



CREATE TABLE Room(
	room_no INT,
	floor INT,
	block VARCHAR(10),
	resident_id VARCHAR(15),
	PRIMARY KEY (room_no, floor, block),
	FOREIGN KEY (resident_id) REFERENCES HostlersInfo(s_id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE Insurance(
	policy_no INT PRIMARY KEY,
	company VARCHAR(250),
	s_id VARCHAR(15),
	start_date DATE,
	end_date DATE,
	FOREIGN KEY (s_id) REFERENCES HostlersInfo(s_id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE HostelStaff AS (
	SELECT e_id AS staff_id,
    SUBSTRING_INDEX(full_name,' ', 1) AS fname,
    SUBSTRING_INDEX(full_name,' ', -1) AS lname,
    email,
    phone,
    designation
    FROM campus.master_employee
    WHERE management = 'hostel'
);
ALTER TABLE HostelStaff ADD PRIMARY KEY (staff_id);
ALTER TABLE HostelStaff ADD FOREIGN KEY (email) REFERENCES campus.master_employee(email) ON DELETE CASCADE;
ALTER TABLE HostelStaff
	ADD UNIQUE (email),
    ADD UNIQUE (phone);
ALTER TABLE HostelStaff ADD FOREIGN KEY (email) REFERENCES campus.master_employee(email) ON DELETE CASCADE ON UPDATE CASCADE;

DELIMITER $$
CREATE TRIGGER remove_staff
AFTER DELETE ON HostelStaff FOR EACH ROW
BEGIN
	UPDATE campus.master_employee SET management = NULL WHERE staff_id = OLD.staff_id;
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE add_staff(IN staff_id VARCHAR(15))
BEGIN
	IF EXISTS(SELECT e_id, management FROM campus.master_employee WHERE e_id = staff_id AND management IS NULL) THEN
	UPDATE campus.master_employee SET management = 'hostel' WHERE e_id = staff_id;
	ELSE SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Could not add employee to hostel';
    END IF;
END $$
DELIMITER ;



CREATE TABLE Mess(
	menu varchar(250),
	served_on varchar(250),
	cuisine varchar(250),
	food_type varchar(250)
);

SELECT * FROM HostlersInfo;
insert into Room values
(12,1,'A','2021A7PS0045U'),
(21,2,'C','2019A4PS0076U'),
/*
(54,5,'G','2021AATS0078U'),
(42,4,'C','2020A1PS0008U'),
*/
(78,7,'A','2021A7PS0063U');


insert into Insurance
values(1456,'ICICI','2021A7PS0063U','2021-06-05','2025-06-05'),
(1678,'LIC','2021A7PS0045U','2021-07-21','2025-06-12'),
(1987,'Apollo','2019A4PS0076U','2019-04-12','2023-07-05');
/*
(1888,'StarLife','2020A1PS0008U','2020-07-31','2024-09-07'),
(3336,'LIC','2021AATS0078U','2021-11-11','2025-04-17');
*/

USE hostel;
CALL add_staff('260');
SELECT * FROM HostlersInfo;
CALL add_student('2021AATS0078U');

delimiter //
create trigger block_availibility before insert on room
for each row
begin
declare row_count int;
select count(*) from room group by Block into row_count;
if row_count>=100 then
signal sqlstate '45000' set message_text='Block is Fully Occupied.';
end if;
end//
delimiter ;



delimiter //
create procedure get_hostler_info(in input_id varchar(250))
begin
select * from hostlersinfo where s_id=input_id;
END//

SELECT * FROM insurance;

delimiter ;


CALL get_hostler_info('2021A7PS0063U');


delimiter //
create procedure get_hostler_insurance(in input_id varchar(250))
begin
select * from insurance where s_id=input_id;
END//
delimiter ;

call get_hostler_insurance('2021A7PS0063U');

delimiter //
create procedure get_room_info_from_resident(in input_id varchar(250))
begin
select * from room where resident_id=input_id;
END//

delimiter ;

call get_room_info_from_resident('2021A7PS0063U');

delimiter //
create procedure get_mess_cuisine(in cus varchar(250))
begin
select * from mess where cuisine=cus;
END//

delimiter ;

delimiter //
create procedure get_staff_info(in input_id int)
begin
select * from hostelstaff where staff_id=input_id;
END//
delimiter ;

call get_staff_info(145);

delimiter //
create procedure get_mess_menu(in d varchar(250))
begin
select menu from mess where Servedon=d;
END//
delimiter ;

delimiter //
create trigger floor_availibility before insert on room
for each row
begin
declare row_count int;
select count(*) from room group by Block,Floor into row_count;
if row_count>=10 then
signal sqlstate '45000' set message_text='Floor is Fully Occupied.';
end if;
end//
delimiter ;


delimiter //
create procedure generate_menu()
begin
select menu,cuisine from mess order by rand() limit 1;
end//
delimiter ;

call generate_menu();

SELECT * FROM hostel.HostlersInfo;

USE hostel;
SHOW TRIGGERS;



