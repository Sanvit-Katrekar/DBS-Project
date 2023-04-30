use library;
show databases;
CREATE TABLE Book (
    book_id int PRIMARY KEY AUTO_INCREMENT,
    title varchar(200) ,
    author varchar(200) ,
    isbn varchar(200)  UNIQUE,
    total_copies int ,
    available_copies int 
);
CREATE TABLE Student (
    student_id int PRIMARY KEY AUTO_INCREMENT,
    name varchar(200) ,
	email varchar(200) UNIQUE,
    phone_number int 
);
CREATE TABLE Staff (
	staff_id int,
    S_name varchar(200)
    );
CREATE TABLE Borrow (
    borrow_id int PRIMARY KEY AUTO_INCREMENT,
    book_id int,
    student_id int,
    borrow_date date ,
    due_date date ,
    return_date date,
    FOREIGN KEY (book_id) REFERENCES Book(book_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id)
);
CREATE TABLE Book_Author (
    book_id int,
    author_id int,
    FOREIGN KEY (book_id) REFERENCES Book(book_id),
    FOREIGN KEY (author_id) REFERENCES Author(author_id)
);
CREATE TABLE Author (
    author_id int PRIMARY KEY AUTO_INCREMENT,
    name varchar(200) 
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