USE academics;

/* Student table*/


CREATE TABLE Student AS (
	SELECT s_id,
    SUBSTRING_INDEX(full_name,' ', 1) AS fname,
    SUBSTRING_INDEX(full_name,' ', -1) AS lname,
    get_student_year(join_date) AS current_year
    FROM campus.master_student
);
CREATE INDEX idx_student_s_id ON Student (s_id);

ALTER TABLE Student
	ADD COLUMN dept_id VARCHAR(50),
    ADD FOREIGN KEY (dept_id) REFERENCES Department(dept_id);
    
/* Department table */

CREATE TABLE Department (
	dept_id VARCHAR(10) PRIMARY KEY,
	dept_name VARCHAR(50) UNIQUE NOT NULL
);

SELECT * FROM academics.Student;

SHOW TABLES;
SHOW TRIGGERS;

/* Course table */

CREATE TABLE Course (
	c_id VARCHAR(10) PRIMARY KEY,
    dept_id VARCHAR(10),
    credits INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id) ON DELETE CASCADE
);

/* Student - Course relation table */ 

CREATE TABLE Enrolled (
	s_id VARCHAR(15),
    c_id VARCHAR(10),
    FOREIGN KEY (s_id) REFERENCES Student(s_id),
    FOREIGN KEY (c_id) REFERENCES Course(c_id)
);

/*Professor table */
CREATE TABLE Professor AS (
	SELECT e_id AS prof_id,
    SUBSTRING_INDEX(full_name,' ', 1) AS fname,
    SUBSTRING_INDEX(full_name,' ', -1) AS lname,
    designation,
    email
    FROM campus.master_employee
    WHERE management = 'academics'
);
ALTER TABLE Professor ADD PRIMARY KEY (prof_id);
ALTER TABLE Professor ADD FOREIGN KEY (email) REFERENCES campus.master_employee(email) ON DELETE CASCADE;
ALTER TABLE Professor ADD UNIQUE (email);
ALTER TABLE Professor ADD COLUMN (dept_id VARCHAR(10));
ALTER TABLE Professor ADD FOREIGN KEY (dept_id) REFERENCES Department(dept_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Professor ADD FOREIGN KEY (email) REFERENCES campus.master_employee(email) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Professor ADD FOREIGN KEY (dept_id) REFERENCES Department(dept_id) ON DELETE CASCADE ON UPDATE CASCADE;

SELECT * FROM Professor;

SHOW TRIGGERS;

DELIMITER $$
CREATE PROCEDURE add_prof(IN prof_id VARCHAR(15))
BEGIN
	IF EXISTS(SELECT e_id, management FROM campus.master_employee WHERE e_id = prof_id AND management IS NULL) THEN
	UPDATE campus.master_employee SET management = 'academics' WHERE e_id = prof_id;
	ELSE SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Could not add employee as professor';
    END IF;
END $$
DELIMITER ;


USE academics;
CALL add_prof(265);
SELECT * FROM Professor;
CALL add_prof_to_dept(265, 'CS');

DELIMITER $$
CREATE PROCEDURE add_prof_to_dept(IN professor_id VARCHAR(15), IN department_id VARCHAR(10))
BEGIN
	IF EXISTS(SELECT prof_id FROM Professor WHERE prof_id = professor_id) AND EXISTS (SELECT dept_id FROM Department WHERE dept_id = department_id) THEN
	UPDATE Professor SET dept_id = department_id WHERE prof_id = professor_id;
	ELSE SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Could not professor to department';
    END IF;
END $$
DELIMITER ;


/*Professor teaching courses table */

CREATE TABLE Teaches (
	c_id VARCHAR(10),
    prof_id VARCHAR(10),
    section VARCHAR(5),
    FOREIGN KEY (c_id) REFERENCES Course(c_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (prof_id) REFERENCES Professor(prof_id) ON DELETE CASCADE ON UPDATE CASCADE
);

DELIMITER $$
CREATE FUNCTION get_student_year(join_date DATE) RETURNS INT
READS SQL DATA # Need to put this line, or else SQL throws an error
BEGIN
	RETURN YEAR(from_days(datediff(current_date(), join_date))) + 1;
END $$
DELIMITER ;

SELECT * FROM academics.Student;

SHOW TRIGGERS;

DELIMITER $$
CREATE PROCEDURE enroll_to_course(IN course_id VARCHAR(10), IN student_id VARCHAR(15))
BEGIN
	IF EXISTS(SELECT c_id FROM Course WHERE c_id = course_id) AND EXISTS(SELECT s_id FROM Student WHERE s_id = student_id) THEN
    INSERT INTO Enrolled VALUES (student_id, course_id);
    ELSE SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Could not enroll student to course';
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE complete_course(IN course_id VARCHAR(10), IN student_id VARCHAR(15))
BEGIN 
	IF EXISTS(SELECT c_id FROM Course WHERE c_id = course_id) AND EXISTS(SELECT s_id FROM Student WHERE s_id = student_id) THEN
    DELETE FROM Enrolled WHERE (s_id, c_id) = (student_id, course_id);
    ELSE SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Could not mark course as complete for student';
    END IF;
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE teach_course(IN course_id VARCHAR(10), IN professor_id VARCHAR(15), IN section VARCHAR(5))
BEGIN 
	IF EXISTS(SELECT c_id FROM Course WHERE c_id = course_id) AND EXISTS(SELECT prof_id FROM Professor WHERE prof_id = professor_id) THEN
    INSERT INTO Teaches VALUES (course_id, professor_id, section);
    ELSE SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Could not add professor to teach course';
    END IF;
END $$
DELIMITER ;

CALL teach_course(1, 265, 'G34');
SELECT * FROM Teaches;
SELECT * FROM Course;
INSERT INTO Course VALUES (1, 'CS', 3);

SELECT * FROM Professor;


DELIMITER $$
CREATE PROCEDURE add_student_to_dept(IN student_id VARCHAR(15), IN department_id VARCHAR(10))
BEGIN
	IF EXISTS(SELECT s_id FROM Student WHERE s_id = student_id) AND EXISTS(SELECT dept_id FROM Department WHERE dept_id = department_id) THEN
	UPDATE Student SET dept_id = department_id WHERE s_id = student_id;
    ELSE SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Could not add student to department';
    END IF;
END $$
DELIMITER ;


SELECT * FROM Student;

CALL add_student_to_dept('2019A4PS0100U', 'CS');

SELECT * FROM Department;

INSERT INTO Department VALUES ('CS', 'Computer Science Engineering');

USE academics;
SHOW TRIGGERS;

DELIMITER $$
CREATE TRIGGER remove_prof
AFTER DELETE ON Professor FOR EACH ROW
BEGIN
	DELETE FROM campus.master_employee WHERE e_id = OLD.prof_id;
END $$
DELIMITER ;


SELECT * FROM Professor;
USE academics;

DELIMITER $$
CREATE PROCEDURE graduate_student(IN student_id VARCHAR(15))
BEGIN
	IF EXISTS(SELECT s_id FROM Student WHERE s_id = student_id AND current_year >= 3) THEN
    DELETE FROM Student WHERE s_id = student_id;
    ELSE SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Could not allow student to graduate';
    END IF;
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE update_student_year()
BEGIN
	DECLARE length INT DEFAULT 0;
	DECLARE counter INT DEFAULT 0;
    DECLARE student_id VARCHAR(15);
	SELECT COUNT(*) FROM Student INTO length;
	SET counter = 0;
	WHILE counter < length DO
		SET student_id = (SELECT s_id FROM Student LIMIT counter, 1);
		UPDATE Student SET current_year = get_student_year(student_id) WHERE s_id = student_id;
		SET counter = counter + 1;
	END WHILE;
END $$
DELIMITER ;

CALL update_student_year()

