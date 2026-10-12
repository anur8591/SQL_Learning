use MyDatabase
--DQL = Data Query language (select, from, where, order by, 


select
	first_name,
	country,
	score
from customers


-- retrive customers with a score not equal to 0

select *
from customers
where score != 0


-- (Where clause)--
-- retrive customer form germany

select 
	first_name
from customers 
where country = 'Germany'


--(Order By)---
-- Retrieve all customers and short the results by the lowest score first 

select *
from customers
order by score ASC


-- suppose we have to sort the country in alphabetic order and score must be DESC

select *
from customers 
order by country ASC, score DESC


--(Group By)---
--find the total socore for each country 

select 
	country,
	sum(score) as total_score
from customers 
Group by country


--find the total score and total number of customers for each country

select 
	country,
	sum(score) as total_score,
	count(id) as total_customers
from customers
group by country



select country, sum(score)
from customers
where score >400
group by country
having sum(score)>800


--find the average score for each country considering only, 
--customers with a score not equal to 0 and return only those,
--country with an average score grater than 430


select 
	country,
	AVG(score) as average
from customers
where score != 0
group by country
having avg(score)>430


--(Distinct)---
--Return unique list of all country

select Distinct
	country
from customers 


--(Top)---
--Restrict the number of rows Returned 
--retrieve only top 3 customers

select top 3 *
from customers 


--retrieve the Top 3 customers with the Highest Score / Lowest Score

select top 3 *
from customers 
order by score DESC


select top 3 *
from customers 
order by score ASC

/*
create table person(
	id int primary key not null,
	person_name varchar(20) not null,
	age int not null,
	gender varchar(6)
)*/

/*
insert into person(id,person_name,age, gender)
values(1,'Anurag Pal', 20, 'Male'),
(2, 'Prachi Upadhyay', 20, 'Female')*/


--Drop table person

select 
 *
from sys.tables

select *
from person

--Update

select *
from customers

update customers
set score = 0
where id = 3

update customers
set score = 250
where id = 5

update customers
set score = 1500,
	country = 'India'
where id = 4

update customers
set score = 0
where score is null

select *
from customers

select *
from customers
where score is null

--Delete
select * from customers

Delete from customers
where id > 4

select * from 
customers
/*
select *
from sys.tables;

truncate table persons

select *
from sys.tables;
*/
--OPerators
-- 1. comparision operators = (=, =!/<>, >, >=, <, <=)
-- 2. logical operators = (AND, OR, NOT)
-- 3. range operators = (BETWEEN)
-- 4. membership operators = (IN, NOT IN)
-- 5. search operators = (LIKE, NOT LIKE )



--find all customer whose first_name start with m 
select *
from customers
where first_name like 'M%'

--find all customer whose first_name end with n
select *
from customers
where first_name like '%n'

--find all customer whose first name contains r 
select *
from customers
where first_name like '%r%'

--find all customer whose first name has 'r' in the 3rd position
select * 
from customers
where first_name like '__r%'

--JOINS
        --Basic joins
		--1. no joins
		--2. left joins 
		--3. right joins 
		--4. inner joins 
		--5. full joins


--retrive all data from customers and orders as seperate result

select * from customers
select * from orders

--Inner join 
select * 
from customers
Inner join orders
on id = customer_id

select 
	id,
	first_name,
	order_id,
	sales
from customers
inner join orders
on id = customer_id

select
	c.id,
	c.first_name,
	o.order_id,
	o.sales
from orders as o
inner join customers as c
on c.id = o.customer_id

--Left Join
--return all row from left table and only match from right table

--get all customers along with their order including those without orders
select 
c.id,
c.first_name,
o.order_id,
o.sales
from customers as c
left join orders as o
on c.id = o.customer_id

--Right join
--Get all customers along with their orders including orders without matching customer

select 
c.id,
c.first_name,
o.customer_id,
o.sales
from customers as c
right join orders as o
on c.id = o.customer_id

--(HW) solving same task using left join
select
c.id,
c.first_name,
o.customer_id,
o.sales
from orders as o
left join customers as c
on o.customer_id = c.id

--Full join
select *
from customers as c
full join orders as o
on c.id = o.customer_id

--Advance SQL JOIN
--left anti join
--right anti join
--full anti join
--cross join


--left anti join
--get all customer who haven't placed any order
select *
from customers as c 
left join orders as o
on c.id = o.customer_id
where o.customer_id is null


--right anti join
--get all orders without matching customer 
select *
from customers as c 
right join orders as o
on c.id = o.customer_id
where c.id is null
--solve the same task using left join
select *
from orders as o
left join customers as c
on c.id = o.customer_id
where c.id is null 

--Full anti join
--Find customers without orders, and orders without customer

select *
from customers as c 
full join orders as o
on c.id = o.customer_id
where c.id is null 
			or 
	  o.customer_id is null 


--CHALLENGE
--get all customers along with their orders, but only for customers who have placed an order (without using inner join)

select *
from customers as c
left join orders as o 
on c.id = o.customer_id
where o.customer_id is  not null

--cross join
--generate all possible combination of customers and order
select *
from customers
cross join orders

--Multi-Table join
/*
using SalesDB, Retrieve a list of all orders,
along with the related customers product and 
employee details for each order display
orderID, Customer Name, Product Name, Sales Amount, product Price and sales person's name
*/

use SalesDB

select *
from Sales.Orders as o
left join Sales.Customers as c
on o.OrderID = c.CustomerID
left join Sales.Products as p
on o.ProductID = p.ProductID
left join Sales.Employees as e 
on o.SalesPersonID = e.EmployeeID

-- SQL Set Operators 
/* diff btwn join and sets
SET = it use to combine the rows & it require same column to combine
JOINS = it use to combine the column & it require key column to combine

Types: 
	Union
	Union All
	Exvept(minus)
	Intersect

*/

--combine the data from employee and customers into one table
select 
FirstName,
LastName
from Sales.Customers

union

select 
FirstName,
LastName
from Sales.Employees

--Union All
--return all rows from both queries, including duplicates.
select 
FirstName,
LastName
from Sales.Customers

union all 

select 
FirstName,
LastName
from Sales.Employees

--Except
--find the employee who are not customer at the same time 
select 
FirstName,
LastName
from Sales.Employees

Except

select 
FirstName,
LastName
from Sales.Customers

--Intersect 
--find the employee, who are also customer 
select 
FirstName,
LastName
from Sales.Customers

Intersect

select
FirstName,
LastName
from Sales.Employees

--order are stored in separate tables (order and orders Archive).
--combine all data order data into one report without duplicates.

select *
from Sales.Orders

union 

select *
from Sales.OrdersArchive

--SQL Function
--  1.manipulation
--  2.calculation
--  3.string Extraction

--Manipulation(concat, upper, lower, trim, replace)

--Concat, upper, lower
select 
c.FirstName,
c.Country,
CONCAT(FirstName,' ',LastName) as Name_Country,
upper(FirstName) as upper_Name,
lower(LastName) as lower_lastn
from sales.Customers as c

--trim 
--method 1
select 
c.FirstName
from Sales.Customers as c
where c.FirstName != TRIM(c.FirstName)

--method 2 
select
c.FirstName,
len(c.FirstName) - len(Trim(c.FirstName)) as flag
from Sales.Customers as c

--Replace
--replace specific character with a new character
select
'91-831-8031-831' as phone,
replace('91-831-8031-831','-','') as clean_phone

select
'report.txt' as old_file,
replace('report.txt', '.txt', '.csv') as new_folder

--Calculation (LEN)

--calculate the length of each customer's first name
select
FirstName,
len(FirstName) as Name_Length
from Sales.Customers

----String Extraction (Left, Right, Substring)
--retrive the first two characters of each first name 
select
FirstName,
left(FirstName,2) as first_2_char
from Sales.Customers

--retrive the last two characters of each first name 
select
FirstName,
right(FirstName,2) as last_2_char
from Sales.Customers

--substring
--substring(value, start, length or end)

select 
FirstName,
substring(FirstName, 2, len(FirstName)) as sub_name
from Sales.Customers

--number function (Round, ABS)
--  1. Round
select
3.516,
ROUND(3.516,2) as round_2,
ROUND(3.516,1) as round_1,
ROUND(3.516,0) as round_0

--  2.ABS
select
-10,
abs(-10),
abs(10)

----Date and time 