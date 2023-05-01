# DATABASES design queries
DROP DATABASE IF EXISTS campus;
CREATE DATABASE campus;
USE campus;


CREATE TABLE nationalities(
	n_id VARCHAR(3) PRIMARY KEY,
    nationality VARCHAR(56)
);

INSERT INTO nationalities VALUES ('IND', 'India');

CREATE TABLE master_student(
	s_id VARCHAR(15) PRIMARY KEY,
	full_name VARCHAR(50),
	email VARCHAR(250) UNIQUE,
	phone varchar(15) UNIQUE,
    address varchar(255),
	nationality_id VARCHAR(3),
	emirates_id INT UNIQUE,
    passport_no VARCHAR(15) UNIQUE,
    join_date DATE,
    is_hosteler TINYINT,
    FOREIGN KEY (nationality_id) REFERENCES nationalities(n_id)
);

SELECT * FROM master_student;

DELIMITER $$	
CREATE TRIGGER student_to_hostel
AFTER INSERT ON
master_student FOR EACH ROW
BEGIN
	IF NEW.is_hosteler THEN
	INSERT INTO hostel.HostlersInfo VALUES (
    NEW.s_id,
    SUBSTRING_INDEX(NEW.full_name,' ', 1),
    SUBSTRING_INDEX(NEW.full_name,' ', -1),
    NEW.emirates_id,
    NEW.passport_no,
    NEW.phone
    );
    END IF;
END $$
DELIMITER ;

DELIMITER $$	
CREATE TRIGGER student_to_hostel_2
AFTER UPDATE ON
master_student FOR EACH ROW
BEGIN
	IF NOT OLD.is_hosteler AND NEW.is_hosteler THEN
	INSERT INTO hostel.HostlersInfo VALUES (
    NEW.s_id,
    SUBSTRING_INDEX(NEW.full_name,' ', 1),
    SUBSTRING_INDEX(NEW.full_name,' ', -1),
    NEW.emirates_id,
    NEW.passport_no,
    NEW.phone
    );
    END IF;
END $$
DELIMITER ;

DELIMITER $$	
CREATE TRIGGER student_to_hostel_2
AFTER UPDATE ON
master_student FOR EACH ROW
BEGIN
	IF NOT OLD.is_hosteler AND NEW.is_hosteler THEN
	INSERT INTO hostel.HostlersInfo VALUES (
    NEW.s_id,
    SUBSTRING_INDEX(NEW.full_name,' ', 1),
    SUBSTRING_INDEX(NEW.full_name,' ', -1),
    NEW.emirates_id,
    NEW.passport_no,
    NEW.phone
    );
    END IF;
END $$
DELIMITER ;

DELIMITER $$	
CREATE TRIGGER update_student_details
AFTER UPDATE ON
master_student FOR EACH ROW
BEGIN
	IF OLD.is_hosteler AND NEW.is_hosteler THEN # No change in the hostler status
	UPDATE hostel.HostlersInfo SET
    s_id = NEW.s_id,
    fname = SUBSTRING_INDEX(NEW.full_name,' ', 1),
    lname = SUBSTRING_INDEX(NEW.full_name,' ', -1),
    emirates_id = NEW.emirates_id,
    passport_no = NEW.passport_no,
    phone = NEW.phone
    WHERE s_id = OLD.s_id;
    END IF;
    
	IF OLD.is_hosteler AND NOT NEW.is_hosteler THEN # Status change from hostler to day scholar
    DELETE FROM hostel.HostlersInfo WHERE s_id = OLD.s_id;
    END IF;
    
	UPDATE academics.Student SET
    s_id = NEW.s_id,
    fname = SUBSTRING_INDEX(NEW.full_name,' ', 1),
    lname = SUBSTRING_INDEX(NEW.full_name,' ', -1)
    WHERE s_id = OLD.s_id;

	UPDATE library.Student SET
    s_id = NEW.s_id,
    fname = SUBSTRING_INDEX(NEW.full_name,' ', 1),
    lname = SUBSTRING_INDEX(NEW.full_name,' ', -1),
    email = NEW.email
    WHERE s_id = OLD.s_id;
END $$
DELIMITER ;


UPDATE master_student SET s_id = '2019A4PS0100U', passport_no = '111111' WHERE s_id = '2019A4PS0076U';

DELIMITER $$
CREATE TRIGGER student_to_academics
AFTER INSERT ON
master_student FOR EACH ROW
BEGIN
	INSERT INTO academics.Student VALUES (
    NEW.s_id,
    SUBSTRING_INDEX(NEW.full_name,' ', 1),
    SUBSTRING_INDEX(NEW.full_name,' ', -1),
    academics.get_student_year(NEW.join_date)
    );
END $$
DELIMITER ;

INSERT INTO master_student VALUES
('2021A7PS0045U','Harry Potter','harry@potter.com','+97145334','Bruh', 'IND', '4353', '234234', '23-11-02', TRUE),
('2021AATS0078U','Manuel Akanji','manuel@qq.com','+971534542','Switzerland, Sector 45, Jungefrau','IND', '4343',42343, '23-11-02', FALSE),
('2019A4PS0076U','Cristiano Ronaldo', 'finis@ronaldo.com', '+971535542','Portugal, near ronaldo','IND','67123','89567', '24-02-11', TRUE),
('2021A7PS0063U','Lionel Messi', 'goat@ronaldo.com', '+9714534525','Argentina, BuenoAires airport','IND','45321','90891', '21-12-01', TRUE),
('2020A1PS0008U','Sadio Mane', 'mane@sad.com','+9719839473','Senegal, Al Qusqa, near Touba Mosque','IND','55555','67671', '20-12-12', FALSE);

SELECT * FROM master_student;


CREATE TABLE master_employee(
	e_id VARCHAR(15) PRIMARY KEY,
    full_name VARCHAR(50),
	email VARCHAR(250) UNIQUE,
	phone varchar(15) UNIQUE,
    emirates_id INT UNIQUE,
    nationality_id VARCHAR(3),
    designation VARCHAR(50),
    address VARCHAR(255),
    yearly_salary DECIMAL(10, 2),
    join_date DATE,
    management VARCHAR(15)
);

DELIMITER $$	
CREATE TRIGGER employee_to_hostel
AFTER INSERT ON
master_employee FOR EACH ROW
BEGIN
	IF NEW.management = 'hostel' THEN
	INSERT INTO hostel.HostelStaff VALUES (
    NEW.e_id,
    SUBSTRING_INDEX(NEW.full_name,' ', 1),
    SUBSTRING_INDEX(NEW.full_name,' ', -1),
    NEW.email,
    NEW.phone,
    NEW.designation
    );
    END IF;
END $$
DELIMITER ;

DELIMITER $$	
CREATE TRIGGER employee_to_canteen
AFTER INSERT ON
master_employee FOR EACH ROW
BEGIN
	IF NEW.management = 'canteen' THEN
	INSERT INTO canteen.CanteenStaff VALUES (
    NEW.e_id,
    SUBSTRING_INDEX(NEW.full_name,' ', 1),
    SUBSTRING_INDEX(NEW.full_name,' ', -1),
    NEW.phone,
    NEW.designation
    );
    END IF;
END $$
DELIMITER ;

USE campus;

DELIMITER $$	
CREATE TRIGGER employee_to_library
AFTER INSERT ON
master_employee FOR EACH ROW
BEGIN
	IF NEW.management = 'library' THEN
	INSERT INTO library.LibraryStaff VALUES (
    NEW.e_id,
    SUBSTRING_INDEX(NEW.full_name,' ', 1),
    SUBSTRING_INDEX(NEW.full_name,' ', -1),
    NEW.designation,
    NEW.email
    );
    END IF;
END $$
DELIMITER ;


DELIMITER $$	
CREATE TRIGGER assign_employee
AFTER UPDATE ON
master_employee FOR EACH ROW
BEGIN
	IF OLD.management IS NULL THEN
		IF NEW.management = 'hostel' THEN
		INSERT INTO hostel.HostelStaff VALUES (
		NEW.e_id,
		SUBSTRING_INDEX(NEW.full_name,' ', 1),
		SUBSTRING_INDEX(NEW.full_name,' ', -1),
		NEW.email,
		NEW.phone,
		NEW.designation
		);

		ELSEIF NEW.management = 'academics' THEN
		INSERT INTO academics.Professor(prof_id, fname, lname,designation, email) VALUES (
		NEW.e_id,
		SUBSTRING_INDEX(NEW.full_name,' ', 1),
		SUBSTRING_INDEX(NEW.full_name,' ', -1),
		NEW.designation,
		NEW.email
		);
		ELSEIF NEW.management = 'canteen' THEN
		INSERT INTO canteen.CanteenStaff(staff_id, fname, lname, phone, designation) VALUES (
		NEW.e_id,
		SUBSTRING_INDEX(NEW.full_name,' ', 1),
		SUBSTRING_INDEX(NEW.full_name,' ', -1),
		NEW.phone,
		NEW.designation
		);
		ELSEIF NEW.management = 'library' THEN
		INSERT INTO library.LibraryStaff VALUES (
		NEW.e_id,
		SUBSTRING_INDEX(NEW.full_name,' ', 1),
		SUBSTRING_INDEX(NEW.full_name,' ', -1),
		NEW.designation,
		NEW.email
		);
        END IF;
	END IF;
END $$
DELIMITER ;

DROP TRIGGER assign_employee;


SELECT * FROM campus.master_employee;
# (e_id, full_name, email, phone, emirates_id, nationality_id, designation, address, yearly_salary, join_date, management)
INSERT INTO master_employee VALUES
('145','Roy Keane','keen@roy.com','+971561893232','488242','IND','Warden', 'DSO', 10000, '23-09-12', 'hostel'),
('132','Mark Jackson','jack@mark.com','+98278347834','488243','IND','Coordinator', 'Al Quaa', 20000, '23-09-12', 'library'),
('176','Jones Jackson','jones@indiana.com','+9322423423','488244','IND','Cafeteria Personal', 'Georgia', 30000, '23-09-12', 'hostel'),
('260','Mark Bober','mark@1.com','+971458954652','488240','IND','Cleaning Staff', 'Sky Zone', 50000, '23-07-11', NULL);
USE campus;
INSERT INTO master_employee VALUES
('265','Mark Rober','mark@42.com','+9714589232','488245','IND','Cleaning Staff', 'Sky Zone', 40000, '23-07-11', NULL);

USE campus;
INSERT INTO master_employee VALUES
('302','Idk whats','brugdfg@bruh.com','+9714584534','748332423','IND','Cleaning Staff', 'Sky Zone', 40000, '23-07-11', NULL);

SELECT * FROM campus.master_employee;

USE campus;
SELECT * FROM master_student;
SELECT * FROM hostel.HostlersInfo;
SELECT * FROM academics.Student;

SELECT * FROM master_employee;
SELECT * FROM hostel.HostelStaff;

DELIMITER $$
CREATE TRIGGER update_employee_details
AFTER UPDATE ON
master_employee FOR EACH ROW
BEGIN
	IF OLD.management = 'hostel' AND NEW.management = 'hostel' THEN # No change in the hostler status
	UPDATE hostel.HostelStaff SET
    staff_id = NEW.e_id,
    fname = SUBSTRING_INDEX(NEW.full_name,' ', 1),
    lname = SUBSTRING_INDEX(NEW.full_name,' ', -1),
    email= NEW.email,
    phone = NEW.phone
    WHERE staff_id = OLD.e_id;
    END IF;
    
	IF OLD.management = 'academics' AND NEW.management = 'academics' THEN # No change in academics status
	UPDATE academics.Professor SET
    prof_id = NEW.e_id,
    fname = SUBSTRING_INDEX(NEW.full_name,' ', 1),
    lname = SUBSTRING_INDEX(NEW.full_name,' ', -1),
    email= NEW.email,
    phone = NEW.phone
    WHERE prof_id = OLD.e_id;
    END IF;

	IF OLD.management = 'canteen' AND NEW.management = 'canteen' THEN # No change in canteen status
	UPDATE canteen.CanteenStaff SET
    staff_id = NEW.e_id,
    fname = SUBSTRING_INDEX(NEW.full_name,' ', 1),
    lname = SUBSTRING_INDEX(NEW.full_name,' ', -1),
    phone = NEW.phone,
    designation = NEW.designation
    WHERE staff_id = OLD.e_id;
    END IF;

	IF OLD.management = 'library' AND NEW.management = 'library' THEN # No change in canteen status
	UPDATE canteen.CanteenStaff SET
    staff_id = NEW.e_id,
    fname = SUBSTRING_INDEX(NEW.full_name,' ', 1),
    lname = SUBSTRING_INDEX(NEW.full_name,' ', -1),
    designation = NEW.designation,
    email = NEW.email
    WHERE staff_id = OLD.e_id;
    END IF;
END $$
DELIMITER ;

DROP TRIGGER update_employee_details;

USE campus;
SHOW TRIGGERS;
