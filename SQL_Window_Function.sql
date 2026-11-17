/*
window function

List of Window function
    |
    |                           |-- .avg()
    |                           |-- .count()
    |--- 1.Aggregate function --|-- .max()
    |                           |-- .min()
    |                           |-- .sum()
    |
    |                         |-- .row_number()
    |--- 2.Ranking function --|-- .rank()
    |           |             |-- .dense_rank()
    |           |                  |-- .percent_rank()
    |--- 3.Distribution function --|-- .cume_dist()
    |
    |                          |-- .lead()
    |                          |-- .lag()
    |--- 4.Analytic function --|-- .ntile()
                               |-- .first_value()
                               |-- .last_value()
                               |-- .nth_value()

*/

use SalesDB


--Aggregate function(count, sum, Avg, Min, Max)

--count()    ....it apply on all datatype
--find the total number of orders for each product

select 
*,
count(*) over(partition by ProductID) as [partition]
from Sales.Orders


--find the total number of sales for each product

select
*,
count(Sales) over(partition by ProductID) as Sales_grouped
from Sales.Orders


--check whether the table 'orders' contains any duplicate rows

select 
OrderID,
count(*) over(Partition by OrderID) as check_duplicate
from Sales.Orders

select
*,
count(*) over(partition by orderid) as check_duplicate
from Sales.OrdersArchive


--Sum()     ....it applys only on numeric values
--Returns the sum of values wihtin a window

--find the total sales for each product
select
*,
sum(Sales) over(partition by ProductID) as product_total_sales
from Sales.Orders

--find the total sales across all orders
--And the total sales for each porduct
--Additionally provide details such as order id, order date

select
OrderID,
OrderDate,
Sales,
sum(Sales) over() as total_sales,
sum(Sales) over(partition by ProductID ) as sales_by_product
from Sales.Orders

--find the percentage contribution of each product's sales to the total sales
select
OrderID, 
ProductID,
Sales,
sum(Sales) over() as Total_Sales,
Round(cast(Sales as float) / sum(Sales) over() * 100, 2) as Total_percentage
from Sales.Orders


--AVG()    ....Returns the average of values within a window

--find the average sales for each product
select
*,
AVG(Sales) over(partition by ProductID) as Average_sales
from Sales.Orders

--find the average sales across all orders
--And Find the average sales for each product
--Additionally provide details such as order id and order date\
select
OrderID,
OrderDate,
Sales,
AVG(Sales) over() as AVG_of_all_orders,
AVG(Sales) over(partition by ProductID) as AVG_product_sales
from Sales.Orders

--find the average scores of customers, Additionally, provide details such as customerid and last name
select
CustomerID,
LastName,
Score,
AVG(Score) over() as Customer_AVG_Score
from Sales.Customers
                      ---it have null value that's why the result is wrong we going to replace null with 0
select
CustomerID,
LastName,
Score,
coalesce(Score, 0) as customer_Score,
AVG(Score) over() as Customer_AVG_Score,
AVG(coalesce(score, 0)) over() AVG_Score_WithOutNull
from Sales.Customers

--find all orders where sales are higher than the average sales across all orders

           --we are using window function so it doesn't allow to use WHERE clause so we need to use SUBQUERY
select
*
from(
    select
        OrderID,
        ProductID,
        Sales,
        AVG(Sales) over() as avg_sales
    from Sales.Orders
)t where Sales > avg_sales

--MIN & MAX
--Min()   ....Returns the lowest value within a window
--MAX()   ....Returns the highest value wihtin a window

select 
ProductID,
OrderID,
OrderDate,
Sales,
MIN(Sales) over() as lowest_sales,
MAX(Sales) over() as highest_sales,
Min(Sales) over(Partition by ProductID) as Product_Lowest_Sales,
MAX(Sales) over(Partition by ProductID) as Product_Highest_Sales
from Sales.Orders

--show the employees who have the highest salaries
select
*
from(
    select
        *,
        MAX(Salary) over() as Highest_Salary
    from Sales.Employees
)t where Salary = Highest_Salary


--find the deviation of each sales from the minimum and maximum sales amounts
select
    OrderID,
    OrderDate,
    ProductID,
    Sales,
    MAX(Sales) over() as hightest_salary,
    MIN(Sales) over() as lowest_salary,
    Sales - MIN(Sales) over() as deviation_from_min,
    MAX(Sales) over() - Sales as deviation_from_max
from Sales.Orders


--Analytical Use case(Running & Rolling Total)
--Running === unbounded (it will work on starting to end of the row), example = Rows Between Unbounded Preceding and Current Row
--Rolling === n preceding (n = number(1,2,3,4,....) it will work till given number or row), example = Rows Between 2 Preceding And Current Row


--Moving Average
--Calculate moving average of sales for each product over time
select
    OrderID, 
    ProductID,
    OrderDate,
    Sales,
    AVG(Sales) over(partition by ProductID) as AVG_BY_Product,
    AVG(Sales) over(partition by ProductID order by OrderDate) as Moving_AVG
from Sales.Orders


--calculate the moving average of sales for each product over time, including only the next order 
select 
    OrderID,
    OrderDate,
    ProductID,
    Sales,
    AVG(Sales) over(partition by ProductID) as Avg_BY_Product,
    AVG(Sales) over(Partition by ProductID Order by OrderDate) as Moving_Avg,
    AVG(Sales) over(Partition by ProductID Order by OrderDate Rows between current Row And 1 following) rollingAVG
from Sales.Orders




/*
-------Rank function----
           |-Ranking function / Integer-Based Ranking         =    (row_number, rank, dense_rank)
           |-Distribution function                            =    (percent_rank, cume_dist)


           Rules
rank()   ....rank function doesn't allow to use any expression inside(Expression must be empty)
         ....Partition by is optional
         ....order by is required
         ....Frame are not allowed
*/


--Row_Number()

--SQL Task
--Rank the orders based on their sales from highest to lowest
select
OrderID,
ProductID,
Sales,
ROW_NUMBER() over(Order by Sales Desc) as Sales_Rank_Row
from Sales.Orders

--Rank()   ....Assign a rank to each row and it handles ties

select 
OrderID,
ProductID,
Sales,
RANK() over(Order by Sales Desc) as Sales_rank
from Sales.Orders

--Dense_Rank()    ....Assign a rank to each row, it handles ties, it doesn't leaves gaps in ranking
select
OrderID,
ProductID,
Sales,
DENSE_RANK() over(Order by Sales Desc) as [Dense_Rank]
from Sales.Orders

--find the top highest sales for each product
select
*
from(
select
    OrderID,
    ProductID,
    Sales,
    ROW_NUMBER() over(partition by ProductID Order By Sales Desc) as HighestSalesForEachProduct
    from Sales.Orders
)t where HighestSalesForEachProduct = 1

--find the lowest 2 customer based on their total sales
select
*
from(
select
    CustomerID,
    sum(Sales) as totalSales,
    ROW_NUMBER() over(Order by sum(Sales)) as lowestForEachProduct
from Sales.Orders
group by CustomerID
)t where lowestForEachProduct <= 2


--Identify duplicate rows in the table'Order Archive' and return a clean result without any Duplicates
select * 
from(
    select
    ROW_NUMBER() over(Partition by orderid order by CreationTime Desc) rn,
    *
    from Sales.OrdersArchive
)t where rn>1