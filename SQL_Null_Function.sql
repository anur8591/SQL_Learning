use SalesDB

select * from Sales.Orders

select
BillAddress,
len(BillAddress)
from Sales.Orders

select
ISNULL(nullif(TRIM(BillAddress), ''), ShipAddress) as [AddressAdded]
from Sales.Orders

--ISNull()
select
ISNULL(ShipAddress,'unknown') as [null removed]
from Sales.Orders

--coalesce
select
coalesce(BillAddress, shipAddress, 'N/A')
from Sales.Orders


--Data aggregation(Null/Coalesce)
--Find the average score of the customers
select
*
from Sales.Customers

select 
CustomerID,
Score,
coalesce(Score,0) as score2,
AVG(Score) over() as avgScore,
AVG(coalesce(score,0)) over() as [AvgScore2]
from Sales.Customers

--Display the full name of the customers in a single field by merging their first and last name 
--and add 10 bonus points to each customer's score 

select 
CustomerID as customerID,
FirstName as firstName,
LastName as lastName,
FirstName +' '+coalesce(LastName,' ') as FullName,
Score as score,
coalesce(Score,0) + 10 as AddScore
from Sales.Customers


--IsNull()
--find the sales price for each order by dividing th esales by the quantity
select
OrderID,
Sales,
Quantity,
Sales/nullif(Quantity, 0) as price
from Sales.Orders

--Identify the customer who have no scores
select
*
from Sales.Customers
where Score is null

select
*
from Sales.Customers
where Score is not null


--join & IsNull
--find the unmatch rows between two table 

--list all details for customers who have not placed any orders
select
c.*,
o.OrderID
from Sales.Customers as c
left join Sales.Orders as o
On c.CustomerID = o.CustomerID
where o.CustomerID is null

