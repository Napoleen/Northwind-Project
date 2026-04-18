--Which sales reps are performing above/below average, and in which regions? 
--Looking at employee table, all employees have "sales" in their title, so we can assume all employees are sales reps, but we should make sure. 
--Looking at orders table, we can see all employes have made sales, but we can check for that in the query with is not null
--We use e.country instead of region, because the region field returns null for those in the UK*/


/* Initiail query

select e.EmployeeID, concat(e.FirstName,'', e.LastName) as EmployeeName, e.country,
sum(od.unitprice *od.Quantity) as TotalSales
from employees E 
join orders o on e.employeeID = o.employeeID
join [order details] od on o.orderid = od.orderid
group by e.employeeid, e.FirstName, e.LastName, e.country
order by totalsales desc;
*/

/* adding window function to compare avg sales per employee
Asking the question to see who are our top performers, and who are falling behind / may need support */

/*
with
    repsales
    as
    (
        select e.EmployeeID, concat(e.FirstName,' ', e.LastName) as EmployeeName, e.country,
            sum(od.unitprice *od.Quantity) as RepSales
        from employees E
            join orders o on e.employeeID = o.employeeID
            join [order details] od on o.orderid = od.orderid
        group by e.employeeid, e.FirstName, e.LastName, e.country
    )

select top 10
    EmployeeName, Country, Repsales,
    avg(repsales) over
(partition by country) as regionavg,
    repsales - (avg(repsales) over (partition by country)) as difffromavg,
    case when repsales > avg(repsales) over (partition by country) then 'Above Average' else 
'Below Average' end as performance
from repsales
order by difffromavg desc;
*/

/* 
KEY TAKEAWAYS:
Margaret is our top performer, with $250k in sales, which is ~$55k above the average for her region.
Laura Callahan is ~$62k below avg for her region, may be worth lookinng into why, and if there are any support we can provide to help her improve.

IMPORTANT TO NOTE: 
This analysis is based on total sales, irrespective of any time window.
*/

/* 
Adding a time component to see how sales rep performance has changed over time, and if there are any trends we can identify.
    (Or to see if sales performance from the previous query is simply a function of duration of employment)  
*/

with -- we can use CTEs to break down the query into more manageable parts, and to avoid repeating the same calculations multiple times
    repsales
    as
    (
        select e.EmployeeID,
            concat(e.FirstName,' ', e.LastName) as EmployeeName,
            e.country,
            sum(od.unitprice *od.Quantity) as RepSales,
            year(o.orderdate) as salesYear,
            MONTH(o.orderdate) as salesMonth
        from employees e
            join orders o on e.employeeID = o.employeeID
            join [order details] od on o.orderid = od.orderid
        group by e.employeeid, e.FirstName, e.LastName, e.country, year(o.orderdate), MONTH(o.orderdate)
    ),
    with_avg -- so we dont have to repeat the window function multiple times
    as
    (
        select *, 
            avg(repsales) over (
        partition by country, salesyear, salesmonth
        ) as regionavg
        from repsales
    )
select
    employeeName,
    country,
    salesYear,
    salesMonth,
    repsales,
    regionavg,
    repsales - regionavg as difffromavg,
    case when repsales > regionavg then 'Above Average' 
    else 'Below Average' 
    end as performance
from with_avg
order by difffromavg desc;



/* KEY TAKEAWAYS:
From this we can verify that Laura is consistently performing above avg for her region, which suggests that the previous query did not tell the whole story 

IMPORTANT NOTE: 

When adding a "where" clause, we need to be careful about how it interacts with the window function.
when looking at an individauls performance in a smaller time window, the query will compare their performance to the average of that smaller time window, which may not be a fair comparison if the time window is too small.
*/