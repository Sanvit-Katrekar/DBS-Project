use library;

CREATE TABLE Book (
    book_id int PRIMARY KEY AUTO_INCREMENT,
    title varchar(200) ,
    author varchar(200) ,
    isbn varchar(200)  UNIQUE,
    total_copies int ,
    available_copies int 
);

CREATE TABLE Student AS (
	SELECT s_id,
    SUBSTRING_INDEX(full_name,' ', 1) AS fname,
    SUBSTRING_INDEX(full_name,' ', -1) AS lname,
    email
    FROM campus.master_student
);
ALTER TABLE Student ADD PRIMARY KEY(s_id);
ALTER TABLE Student ADD UNIQUE(email);
ALTER TABLE Student ADD FOREIGN KEY (email) REFERENCES campus.master_student(email) ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE LibraryStaff AS (
	SELECT e_id AS staff_id,
    SUBSTRING_INDEX(full_name,' ', 1) AS fname,
    SUBSTRING_INDEX(full_name,' ', -1) AS lname,
    designation,
    email
    FROM campus.master_employee
    WHERE management = 'library'
);
ALTER TABLE LibraryStaff ADD PRIMARY KEY (staff_id);
ALTER TABLE LibraryStaff ADD UNIQUE (email);
ALTER TABLE LibraryStaff ADD FOREIGN KEY (email) REFERENCES campus.master_employee(email) ON DELETE CASCADE ON UPDATE CASCADE;

DELIMITER $$
CREATE PROCEDURE add_staff(IN staff_id VARCHAR(15))
BEGIN
	IF EXISTS(SELECT e_id, management FROM campus.master_employee WHERE e_id = staff_id AND management IS NULL) THEN
	UPDATE campus.master_employee SET management = 'library' WHERE e_id = staff_id;
	ELSE SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Could not add employee to library';
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER remove_staff
AFTER DELETE ON LibraryStaff FOR EACH ROW
BEGIN
	UPDATE campus.master_employee SET management = NULL WHERE staff_id = OLD.staff_id;
END $$
DELIMITER ;


CREATE TABLE Borrow (
    borrow_id int PRIMARY KEY AUTO_INCREMENT,
    book_id int,
    s_id VARCHAR(15),
    borrow_date date ,
    due_date date ,
    return_date date,
    FOREIGN KEY (book_id) REFERENCES Book(book_id),
    FOREIGN KEY (s_id) REFERENCES Student(s_id)
);

CREATE TABLE Author (
    author_id int PRIMARY KEY AUTO_INCREMENT,
    name varchar(200) 
);

CREATE TABLE Book_Author (
    book_id int,
    author_id int,
    FOREIGN KEY (book_id) REFERENCES Book(book_id),
    FOREIGN KEY (author_id) REFERENCES Author(author_id)
);


CREATE TABLE AUTHENTICATION(
	login_id varchar(200),
    staff_password varchar(200)
);

insert into Student values
	(078, "Aouchitya", "@United",0000),
    (059, "Sanvit", "@GM",0001),
    (073, "Aryan", "@ALNASSR",0002),
    (077, "Siddarth", "@Anime",0003),
    (063, "JJ", "@Bruh",0004);
insert into Book values
	(001, "CS", "John Cena", "Hellooooo123", 20, 13),
    (002, "How to be Goat Defender", "Harry Maguire","LOL01", 100, 100),
    (003, "Story of the GOAT", "Cristiano Ronaldo", "LOL02",10000, 0),
    (004, "How to win trophies", "Tottenham Hotspurs", "LOL03",10000, 10000);
insert into Author values
	(007, "Cristiano Ronaldo"),
    (002, "Harry Maguire"),
    (000,"Tottenham Hotspurs"),
    (009, "John Cena");
    
/* Procedures */

DELIMITER $$
CREATE PROCEDURE AddBook (IN book_title VARCHAR(200), IN book_author VARCHAR(200), IN book_isbn VARCHAR(200), IN total_copies INT)
BEGIN
    INSERT INTO Book (title, author, isbn, total_copies, available_copies)
    VALUES (book_title, book_author, book_isbn, total_copies, total_copies);
END $$
DELIMITER ;

-- Removing Book--
DELIMITER $$
CREATE PROCEDURE RemoveBook(IN book_id INT)
BEGIN
    DELETE FROM Book WHERE book_id = book_id;
END $$
DELIMITER ;

CREATE OR REPLACE VIEW AvailableBooks AS
SELECT Book.book_id, title, author, total_copies - COUNT(Borrow.book_id) AS copies_available
FROM Book
LEFT JOIN Borrow ON Book.book_id = Borrow.book_id AND return_date IS NULL
GROUP BY Book.book_id;

SELECT * FROM AvailableBooks;

-- BorrowingBook
DELIMITER $$
CREATE PROCEDURE BorrowBook (IN book_id INT, IN student_id INT, IN borrow_date DATE, IN due_date DATE)
BEGIN
    INSERT INTO Borrow (book_id, student_id, borrow_date, due_date) 
    VALUES (book_id, student_id, borrow_date, due_date);
END $$
DELIMITER ;

-- Returning Book
DELIMITER $$
CREATE PROCEDURE ReturnBook (IN brw_id INT, IN ret_date DATE)
BEGIN
    UPDATE Borrow SET return_date = ret_date WHERE borrow_id = brw_id;
END $$
DELIMITER ;

USE library;

SELECT * FROM library.LibraryStaff;
SELECT * FROM campus.master_employee;

CALL add_staff('302');
DELETE FROM LibraryStaff WHERE staff_id = '302';
