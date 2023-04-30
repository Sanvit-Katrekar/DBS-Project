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
cust_id int,
pid int,
offer float,
primary key(ord_id),
foreign key(cust_id) references customers(cust_id),
foreign key(pid) references product(pid)
);


create table cant_employee(
c_name varchar(255),
c_address varchar(255),
qualification varchar(255),
cant_eid int,
cust_id int,
designation varchar(255),
visa_validity date,
salary int,
cant_id int,
primary key(cant_eid),
foreign key(cust_id) references customers(cust_id),
foreign key(cant_id) references canteen(cant_id));

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
foreign key(sup_id) references suppliers(sup_id));


create table suppliers(
sup_id int,
sup_name varchar(255),
sup_address varchar(255),
sup_pid int,
sup_prices float,
primary key(sup_id),
foreign key(sup_pid) references init_products(sup_pid));

create table init_products(
sup_pid int,
product_names varchar(255));

create table customers(
status bool,
cust_id int,
cust_name varchar(255),
s_id int,
e_id int,
primary key(cust_id),
foreign key(s_id) references student(s_id),
foreign key(e_id) references employee(e_id));

#status- if 0 then student and 1 for employee, if 0 e_id null else not null