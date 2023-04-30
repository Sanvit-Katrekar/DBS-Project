USE academics;

/* Student table*/

create table Student 
(F_Name varchar(255),
L_Name varchar(255),
roll_no int primary key not null,
en_year int,
DeptName varchar(255),
foreign key (DeptName) references Department(Dept_name)
);

/* Department table */

create table Department
(Dept_name varchar(255) primary key,
Dept_id int not null,
C_id int);

/* Course table */

create table Course  
(C_Name varchar(255),
C_id int primary key,
Dept varchar(255),
foreign key (Dept) references Department(Dept_name) 
);

/* Student - Course relation table */ 

create table Enrolled
(Section varchar(255),
rollnum int,
CourseID int,
foreign key (rollnum) references Student(roll_no),
foreign key (CourseID) references Course(C_id)
);

/* Staff table where staff includes teaching and non-teaching staff like lab assistants and also security personnel*/

create table staff
(StaffF_Name varchar(255),
StaffL_Name varchar(255),
StaffID int primary key,
StaffRole varchar(255)
);

/*Professor table */

create table Professor
(Prof_Name varchar(255) not null,
ProfID int primary key,
Department varchar(255) ,
Postion varchar(255),
foreign key (Department) references Department(Dept_name)
);

/*Professor teaching courses table */

create table teaches 
( CourseID int,
Course_Name varchar(255),
ProfessorID int,
Professor_Name varchar(255),
Section varchar(255),
Department varchar(255),
foreign key (CourseID) references Course(C_id),
foreign key (ProfessorID) references Professor(ProfID),
foreign key (Department) references Department(Dept_name)
);
