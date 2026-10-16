use SalesDB
/*
Date and time function
|
|                 |- Day()
|                 |- Month()
|                 |- Year()
|-Part Extraction-|- DatePart()
|                 |- DateName()
|                 |- DateTrunce()
|                 |- EoMonth()
|
|                     |- Formating()
|-Formating & Casting-|- Convert()
|                     |- Cast()
|
|-Calculation-|- DateAdd()
|             |- DateDiff()
|
|-Validation--- IsDate()
*/

--Part Extraction
--Day
select
o.OrderID,
o.CreationTime,
Day(o.CreationTime) as Day
from Sales.Orders as o

--month
select
o.OrderID,
o.CreationTime,
MONTH(o.CreationTime) as month
from Sales.Orders as o

--Year
select
o.OrderID,
o.CreationTime,
YEAR(o.CreationTime) as year
from Sales.Orders as o

--all in one
select
OrderID,
CreationTime,
Day(CreationTime) as Days,
MONTH(CreationTime) as month,
year(CreationTime) as year
from Sales.Orders

--DatePart
select
o.OrderID,
o.CreationTime,
DATEPART(Day, o.CreationTime) as date_dp,
DATEPART(Month, o.CreationTime) as month_dp,
DATEPART(YEAR, o.CreationTime) as year_df
from Sales.Orders as o

--we also use(hour, minutes, second, quarter, week)
select
o.OrderID,
o.CreationTime,
DATEPART(Day, o.CreationTime) as date_dp,
DATEPART(Month, o.CreationTime) as month_dp,
DATEPART(YEAR, o.CreationTime) as year_dp,
DATEPART(HOUR,o.CreationTime) as hours_dp,
DATEPART(MINUTE,o.CreationTime) as minute_dp,
DATEPART(SECOND,o.CreationTime) as second_dp,
DATEPART(QUARTER,o.CreationTime) as qurarter_dp, 
DATEPART(WEEK,o.CreationTime) as week_dp 
from Sales.Orders as o

--DateName
select
o.OrderID,
o.CreationTime,
DATENAME(Day,o.CreationTime) as string_Day,
DATENAME(MONTH,o.CreationTime) as string_Month,
DATENAME(YEAR,o.CreationTime) as string_year,
DATENAME(WEEKDAY,o.CreationTime) as string_weekday,
DATENAME(WEEK,o.CreationTime)as sting_week
from Sales.Orders as o

--DateTrunc
--it use to reset
select
o.OrderID,
o.CreationTime,
DATETRUNC(MONTH, o.CreationTime) as only_Date
from Sales.Orders as o

select
o.OrderID,
o.CreationTime,
DATETRUNC(HOUR, o.CreationTime) as only_Date
from Sales.Orders as o

select
o.OrderID,
o.CreationTime,
DATETRUNC(MINUTE, o.CreationTime) as only_Date
from Sales.Orders as o

select
DATETRUNC(MONTH,CreationTime) as creation,
count(*) as order_placed
from Sales.Orders
Group by DATETRUNC(MONTH, CreationTime)

--EoMonth(End of the Months)
select
OrderID,
CreationTime,
EOMONTH(CreationTime) as end_of_month
from Sales.Orders

select 
OrderID,
CreationTime,
EOMONTH(CreationTime) as end_of_month,
CAST(DATETRUNC(MONTH,CreationTime) as date ) as Date_start_of_month
from Sales.Orders

        --Date Time (Data agrigations)
--how many orders were placed each year
select
YEAR(OrderDate) as year,
count(*) as no_of_orders
from Sales.Orders
Group by year(OrderDate)

--how many orders were placed each month
select
MONTH(OrderDate) as month,
count(*) as no_of_orders
from Sales.Orders
group by MONTH(OrderDate)

select
DATENAME(Month,OrderDate),
count(*)
from Sales.Orders
Group by DateName(Month,OrderDate)

---Date and Time (Data filtering)
--show all orders that were placed during the month of feburary

select *
from Sales.Orders
where MONTH(OrderDate) = 2


--format and casting(formating(), converting(), cast()) (YYYY-MM-DD HH:mm:ss)
--format()
select
orderID,
CreationTime,
FORMAT(CreationTime, 'dd') as [IntDay],
FORMAT(CreationTime, 'ddd') as [Day in short],
FORMAT(CreationTime, 'dddd') as [Day],
FORMAT(CreationTime, 'MM-dd-yyyy') as US_format,
FORMAT(CreationTime, 'dd-MM-yyyy') as EU_format,
FORMAT(CreationTime, 'yyyy-MM-dd') as International_format
from Sales.Orders

--show creationTime using the following format: Day Wed jan Q1 2025 12:34:56pm

select 
OrderID,
CreationTime,
'Day ' + FORMAT(CreationTime,'ddd MMM')+
' Q '+DATENAME(QUARTER,CreationTime)+
' '+FORMAT(CreationTime,'yyyy hh:mm:ss tt') as custome_format
from Sales.Orders

--formating use case & Date aggregations
select
FORMAT(orderDate, 'MMM-yy') as OrderDate,
count(*)
from Sales.Orders
Group By FORMAT(OrderDate, 'MMM-yy')

--let's take it as a real scenario data can come from multiple source like csvfile, API, or Database 
--we'll collect in one central database and apply formating and operation and use it for report or presentation 



--convert()
select
CONVERT(int, '123') as string_to_int,
CONVERT(Date, '2005-11-26') as string_to_date,
o.CreationTime,
CONVERT(Date, o.CreationTime) as DateTime_to_date
from Sales.Orders as o

--using converting and formating
select
CreationTime as dateTime_to_date,
CONVERT(varchar, CreationTime, 34) as [EU std style:34],
CONVERT(varchar, CreationTime, 32) as [USA std style:32]
from Sales.Orders

--CAST()
select 
cast('123' as int) as [string to int],
cast(123 as varchar) as [int to string],
cast('2025-08-20' as date) as [String to Date],
cast('2025-08-20' as datetime2) as [string to datetime],
CreationTime,
cast(creationTime as date) as [DateTime to date]
from Sales.Orders

--calculation(Mathematical operation in Date & Time Function = DateAdd(), DateDiff())

--DateAdd()
select
OrderID,
OrderDate,
DATEADD(day,-10, OrderDate) as [10DaysBefore],
DATEADD(MONTH, 3, OrderDate) as [3MonthsLater],
DATEADD(year, 2, OrderDate) as [2YearsLater]
from Sales.Orders

--DateDiff()
--Find the different between two dates
select
OrderDate,
ShipDate,
DATEDIFF(day, OrderDate, ShipDate) as DayDiff,
DATEDIFF(MONTH, OrderDate, ShipDate) as MonthDiff,
DATEDIFF(YEAR, OrderDate, ShipDate) as YearDiff
from Sales.Orders

--find the average shipping duration days for each month
select
MONTH(orderDate) as OrderDateInMonth,
AVG(DATEDIFF(day, OrderDate, ShipDate)) as avgShip
from Sales.Orders
Group by MONTH(OrderDate)


--calculate the age of employees
--we are using sales.employees DB we don't have age in this DB but we can have Birthdate
--we use getDate() and DateDiff()
select
EmployeeID,
BirthDate,
DATEDIFF(YEAR, BirthDate, GETDATE()) as age
from Sales.Employees

--find the number of days between each order and previous order
--Time gap analysis
select
OrderID,
OrderDate as CurrentOrderDate,
LAG(OrderDate) over(order by OrderDate) as previous_order_date,
DateDiff(Day, LAG(orderDate) over(order by OrderDate), OrderDate) as No_of_Days
from Sales.Orders

--Data Validation(ISDATE())     only give true or false as a output
select
ISDATE('123') as datecheck1,
ISDATE('2025-08-20') as datecheck2,
ISDATE('20-08-2026') as datecheck3,
ISDATE('2026') as datecheck4,
ISDATE('08') as datecheck5
