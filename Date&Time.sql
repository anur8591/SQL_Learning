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
