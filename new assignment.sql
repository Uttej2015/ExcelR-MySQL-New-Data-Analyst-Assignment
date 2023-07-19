#--------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# day 3 
# 1)	Show customer number, customer name, state and credit limit from customers table for below conditions. Sort the results by highest to lowest values of creditLimit.
# ●	State should not contain null values
# ●	credit limit should be between 50000 and 100000

select customernumber,customername,state,creditlimit 
from customers
where state is not null and creditlimit between 50000 and 100000
order by creditlimit desc;

#*********************************************************************************************************************************#

# 2)Show the unique productline values containing the word cars at the end from products table.
select distinct(productline)
from products
where productline like '%cars';
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# day 4
# 1)Show the orderNumber, status and comments from orders table for shipped status only. If some comments are having null values then show them as “-“.
select ordernumber,status,ifnull(comments,'-') as 'comments'
from orders
where status='shipped';
#*********************************************************************************************************************************#
/*2)	Select employee number, first name, job title and job title abbreviation from employees table based on following conditions.
If job title is one among the below conditions, then job title abbreviation column should show below forms.
●	President then “P”
●	Sales Manager / Sale Manager then “SM”
●	Sales Rep then “SR”
●	Containing VP word then “VP”*/
select employeenumber,firstname,jobtitle, 
case when jobtitle='President' then 'P' 
	when  jobtitle='Sales rep' then 'SR'
    when jobtitle like 'Sales manager%' or jobtitle like 'Sale manager%' then 'SM'
    when jobtitle like '%VP%' then 'VP'
    end as 'job abbrevation'
from employees;
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# Day 5
# 1)For every year, find the minimum amount value from payments table.
select year(paymentdate) as 'year',min(amount) as 'Min Amount'
from payments
group by year(paymentdate);

#*********************************************************************************************************************************#
# 2)For every year and every quarter, find the unique customers and total orders from orders table. Make sure to show the quarter as Q1,Q2 etc.
select * from orders;
with cte as (select *,
case when month(orderdate) between 1 and 3 then 'Q1'
	when month(orderdate) between 4 and 6 then 'Q2'
	when month(orderdate) between 7 and 9 then 'Q3'
	when month(orderdate) between 10 and 12 then 'Q4'
    end as 'Quarter' from orders)
    select year(orderdate) as 'Year',quarter,count(distinct(customernumber)) as 'Unique Customers',count(orderdate) as 'Total Orders' 
    from cte 
    group by year(orderdate),quarter;

#*********************************************************************************************************************************#
# 3)Show the formatted amount in thousands unit (e.g. 500K, 465K etc.) for every month (e.g. Jan, Feb etc.) 
# with filter on total amount as 500000 to 1000000. Sort the output by total amount in descending mode. [ Refer. Payments Table]
with cte as (select sum(amount) as 'Formatted_amount',monthname(paymentdate) as 'Month'
from payments
group by monthname(paymentdate))
select substr(month,1,3) as 'Month', concat(round(formatted_amount/1000),'K') as 'Formatted Amount'
from cte
where formatted_amount between 500000 and 1000000
order by formatted_amount desc;
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# Day 6:
/*1)Create a journey table with following fields and constraints.
●	Bus_ID (No null values)
●	Bus_Name (No null values)
●	Source_Station (No null values)
●	Destination (No null values)
●	Email (must not contain any duplicates)*/
create table journey (bus_id int not null,
bus_name varchar(25) not null,
source_station varchar(50) not null,
destination varchar(30) not null,
email varchar(50) unique);
desc journey;
#*********************************************************************************************************************************#
/*2)	Create vendor table with following fields and constraints.
●	Vendor_ID (Should not contain any duplicates and should not be null)
●	Name (No null values)
●	Email (must not contain any duplicates)
●	Country (If no data is available then it should be shown as “N/A”)*/
create table vendor(vendor_id int primary key, name varchar(30) not null,email varchar(50) unique,country varchar(25) default 'N/A');
desc vendor;
#*********************************************************************************************************************************#
/*3)	Create movies table with following fields and constraints.
●	Movie_ID (Should not contain any duplicates and should not be null)
●	Name (No null values)
●	Release_Year (If no data is available then it should be shown as “-”)
●	Cast (No null values)
●	Gender (Either Male/Female)
●	No_of_shows (Must be a positive number)*/
create table movies (movie_id int primary key,name varchar(30) not null,release_year char(4) default '-',
cast varchar(20) not null,gender varchar(6),no_of_shows int check(no_of_shows>0));
desc movies;
#*********************************************************************************************************************************#
/* 4)	Create the following tables. Use auto increment wherever applicable
a. Product ✔	product_id - primary key ✔	product_name - cannot be null and only unique values are allowed
✔	description ✔	supplier_id - foreign key of supplier table
b. Suppliers ✔	supplier_id - primary key ✔supplier_name ✔	location
c. Stock ✔	id - primary key ✔	product_id - foreign key of product table ✔	balance_stock*/

create table suppliers (supplier_id int primary key auto_increment, supplier_name varchar(30),location varchar(30));
desc suppliers;
create table product (product_id int primary key auto_increment,product_name varchar(30) not null unique,
description varchar(50), supplier_id int , foreign key (supplier_id) references suppliers(supplier_id));
desc product;
create table stock (stock_id int primary key auto_increment,product_id int,balance_stock int,
foreign key (product_id) references product(product_id));
desc stock;

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# Day 7
/* 1)	Show employee number, Sales Person (combination of first and last names of employees), unique customers for each employee number 
and sort the data by highest to lowest unique customers. Tables: Employees, Customers*/
select * from employees; desc employees;
select * from customers; desc customers;
with cte as (select *,concat(firstname,lastname) as 'Sales_Person',count(employeenumber) over(partition by employeenumber) as 'Unique_customers'
from employees inner join customers on employeenumber=salesRepEmployeeNumber)
select distinct(employeenumber),sales_person,unique_customers from cte
order by unique_customers desc;
#*********************************************************************************************************************************#
/*2)	Show total quantities, total quantities in stock, left over quantities for each product and each customer. 
Sort the data by customer number. Tables: Customers, Orders, Orderdetails, Products */
select * from Customers;
select * from Orders; 
select * from Orderdetails; 
select * from Products;

select c.customernumber,customername,od.productcode,productname,quantityOrdered as 'Ordered Qty',quantityInStock as 'Total Inventory', quantityInStock-quantityOrdered as 'Left Qty'
from customers c inner join orders o inner join orderdetails od inner join products p
on c.customerNumber=o.customerNumber and o.orderNumber=od.orderNumber and od.productCode=p.productCode 
order by c.customernumber,od.productcode;
#*********************************************************************************************************************************#
/*3)	Create below tables and fields. (You can add the data as per your wish)
●	Laptop: (Laptop_Name) ●	Colours: (Colour_Name) Perform cross join between the two tables and find number of rows.*/
create table laptop(laptop_name varchar(25));
create table colours (colour_name varchar(25));

insert into laptop values ('Dell'),('HP');
insert into colours values ('White'),('Silver'),('Black');

select * from laptop;
select * from colours;

select * from laptop cross join colours
order by laptop_name;
#*********************************************************************************************************************************# 
#4)	Create table project with below fields. ●EmployeeID ●FullName ●Gender ●	ManagerID 
create table project (employee_id int,fullname varchar(20),gender varchar(6),managerid int);
#Add below data into it.
INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);
select * from project;
# Find out the names of employees and their related managers.
select b.fullname as 'Manager Name',a.fullname as 'Employee Name' from project a inner join project b 
on b.employee_id=a.managerid;

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# Day 8
#Create table facility. Add the below fields into it. ●	Facility_ID ● Name ●	State ●	Country
create table facility (facility_id int,name varchar(30),state varchar(20), country varchar(20));
# i) Alter the table by adding the primary key and auto increment to Facility_ID column.
alter table facility modify column facility_id int primary key auto_increment;
# ii) Add a new column city after name with data type as varchar which should not accept any null values.
alter table facility add column city varchar(30) not null;
desc facility;
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# Day 9
# Create table university with below fields. ●ID ●Name
create table university (id int,name varchar(50));
#Add the below data into it as it is.
INSERT INTO University
VALUES (1, "       Pune          University     "), 
               (2, "  Mumbai          University     "),
              (3, "     Delhi   University     "),
              (4, "Madras University"),
              (5, "Nagpur University");
select * from university;
# Remove the spaces from everywhere and update the column like Pune University etc.
update university set name = replace(replace(replace(name,' ',''),'  ',''),'University',' University');
select * from university;

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------#

# Day 10
# Create the view products status. Show year wise total products sold. Also find the percentage of total value for each year. The output should look as shown in below figure.
select * from products;
select * from orderdetails;
select * from orders;

create view products_status as 
			with cte as(select od.ordernumber,year(orderdate) as 'Year',count(od.productcode) over() as 'totalcount'
			from products p inner join orderdetails od inner join orders o
			on p.productcode=od.productcode and od.ordernumber=o.ordernumber),
			cte1 as (select *,count(ordernumber) over(partition by year) as 'yeartotal' from cte)
			select year,concat(yeartotal,' (',round((yeartotal/totalcount)*100),'%)') as 'Value' from cte1 group by year,yeartotal,totalcount;

select * from products_status;
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------#

# Day 11
# 1)	Create a stored procedure GetCustomerLevel which takes input as customer number and gives the output as either Platinum, Gold or Silver as per below criteria.
 # Table: Customers
/*●	Platinum: creditLimit > 100000
●	Gold: creditLimit is between 25000 to 100000
●	Silver: creditLimit < 25000 */

DELIMITER //
CREATE  PROCEDURE `GetCustomerLevel_procedure`(custnumber int)
BEGIN
declare climit int;
set climit = (select creditlimit 
			from customers
            where customernumber=custnumber);
if climit > 100000 then select 'Platinum' as 'Credit type';
	elseif climit between 100000 and 25000 then select 'Gold' as 'Credit type';
    elseif climit < 25000 then select 'Silver' as 'Credit type';
    end if; 
END //
DELIMITER ;
call classicmodels.GetCustomerLevel_procedure(103);
# created stored procedure GetCustomerLevel(custnumber int)
#*********************************************************************************************************************************# 

# 2)	Create a stored procedure Get_country_payments which takes in year and country as inputs and gives year wise, country wise total amount as an output. 
# Format the total amount to nearest thousand unit (K) Tables: Customers, Payments
DELIMITER //
CREATE  PROCEDURE `Get_country_payments_procedure`(y int,cntry varchar(50))
BEGIN
 select year(paymentdate),country,concat(round(sum(amount)/1000),'K')  from customers c inner join payments p on c.customernumber=p.customernumber
 where country=cntry and year(paymentdate)=y;
END //
 DELIMITER ;
 #created stored procedure Get_country_payments(y int,cntry varchar(50));
call classicmodels.Get_country_payments_procedure(2003, 'FRANCE');
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------#
 
# Day 12
# 1)Calculate year wise, month name wise count of orders and year over year (YoY) percentage change. Format the YoY values in no decimals and show in % sign.Table: Orders

with cte as(select year(orderdate) as 'Year',monthname(orderdate) as 'Month',count(orderdate) as 'presorders'
from orders group by  year(orderdate),monthname(orderdate)),
cte1 as (select *,lag(presorders) over () as 'prevorders' from cte)
select year,month,presorders as 'Total Orders', concat(round((((presorders/prevorders)-1)*100)),'%') as 'YoY Change' from cte1;
#*********************************************************************************************************************************# 

# 2)	Create the table emp_udf with below fields. ●Emp_ID ●Name ●	DOB
create table emp_udf(emp_id int primary key auto_increment,name varchar(50),DOB date);
desc emp_udf;
#Add the data as shown in below query.
INSERT INTO Emp_UDF(Name, DOB)
VALUES ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");
select * from emp_udf;
DELIMITER //
CREATE  FUNCTION `age_calculation_function`(dobirth date) 
RETURNS varchar(150) 
    DETERMINISTIC
BEGIN
declare age varchar(150);
set age = concat(floor(datediff('2023-03-30',dobirth)/365),' Years ',round(round(((datediff('2023-03-30',dobirth)%365)/30),1)),' Months');
RETURN age;
END;
END//
DELIMITER ;
# Create a user defined function calculate_age which returns the age in years and months (e.g.30 years 5 months) by accepting DOB column as a parameter.
select *,age_calculation_function(dob) as 'age' from emp_udf;
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# Day 13
# 1)Display the customer numbers and customer names from customers table who have not placed any orders using subquery Table: Customers, Orders
select customernumber,customername from customers where customernumber not in 
(select customerNumber from orders);
#*********************************************************************************************************************************# 
# 2)Write a full outer join between customers and orders using union and get the customer number, customer name, count of orders for every customer. Table: Customers, Orders
select * from customers;
select * from orders;
with cte as (select c.customerNumber,c.customerName,ordernumber from customers c left join orders o on c.customerNumber=o.customerNumber
union
select c.customerNumber,c.customerName,ordernumber from customers c right join orders o on c.customerNumber=o.customerNumber)
select customernumber,customername,count(*) as 'Total Orders' from cte group by customernumber,customername;

#*********************************************************************************************************************************# 
# 3)Show the second highest quantity ordered value for each order number. Table: Orderdetails
with cte as (select orderNumber,quantityOrdered,dense_rank() over(partition by ordernumber order by quantityOrdered desc) as 'dr'
from orderdetails)
select ordernumber,quantityordered from  cte
where dr=2;

#*********************************************************************************************************************************# 
# 4)For each order number count the number of products and then find the min and max of the values among count of orders. Table: Orderdetails
with cte as (select count(ordernumber) as 'Total' from orderdetails
group by orderNumber) select MAX(Total),MIN(Total) from cte;

#*********************************************************************************************************************************# 
# 5)Find out how many product lines are there for which the buy price value is greater than the average of buy price value. Show the output as product line and its count.

with cte as (select productline,buyPrice,avg(buyPrice) over() as 'avg' from products)
select productline,count(productline) from cte
where buyprice > avg
group by productline
order by count(productline) desc;

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# Day 14 Create the table Emp_EH. Below are its fields. ● EmpID (Primary Key)  ●	EmpName  ●	EmailAddress
create table emp_eh(empid int primary key,Empname varchar(50),emailaddress varchar(150) unique);
DELIMITER //
CREATE  PROCEDURE `exit_handler_procedure`(eid int,ename varchar(100),eemail varchar(150))
BEGIN
declare exit handler for sqlexception,sqlwarning
begin
select 'Error Occured' as 'Message';
end;
insert into emp_eh values(eid,ename,eemail);
END//
DELIMITER ;
# Create a procedure to accept the values for the columns in Emp_EH. Handle the error using exception handling concept. Show the message as “Error occurred” in case of anything wrong.
call classicmodels.exit_handler_procedure(1,'Uttej', 'puppalauttej27@gmail.com'); # inseted succesfully
call classicmodels.exit_handler_procedure(2,'Uday', 'puppalaudaykumarr@gmail.com'); 
call classicmodels.exit_handler_procedure(1, 'Uttej', 'puppalauttej@gmail.com'); # error occured becz we given unique empid
select * from emp_eh;
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------#

# Day 15 Create the table Emp_BIT. Add below fields in it. ●Name ●	Occupation ●	Working_date ●	Working_hours
create table emp_bit (name varchar(60),occupation varchar(100),working_date date,working_hours int);
# Insert the data as shown in below query.
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);
select * from emp_bit; 
# Create before insert trigger to make sure any new value of Working_hours, if it is negative, then it should be inserted as positive.
DELIMITER //
create trigger trig1 before insert
on emp_bit for each row
begin
if new.working_hours<0 then set new.working_hours=abs(new.working_hours);
end if;
END//
DELIMITER ;
INSERT INTO Emp_BIT VALUES ('Uttej', 'Student', '2020-07-20',-9);
INSERT INTO Emp_BIT VALUES ('Uday', 'Employee', '2021-03-15',-10),('Padma rao','Retired','2022-04-09',-7);
select * from emp_bit;
