/* Which product categories generate the most revenue, and is that share growing or shrinking over time? 
 # Tables used: Categories, order details, products, orders */

/*
#First query to find the total revenue by category, then we will add a time component to see how it changes over time.

select C.CategoryName,
    format(sum(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)), 'C', 'en-US') as Revenue
from Categories C
    inner join Products P on C.CategoryID = P.CategoryID
    inner join [Order Details] OD on P.ProductID = OD.ProductID
group by C.CategoryName
order by (sum(OD.UnitPrice * OD.Quantity * (1 - OD.Discount))) DESC;

*/


select C.CategoryName, year(o.OrderDate) as Year,
    format(sum(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)), 'C', 'en-US') as Revenue

from Categories C
    inner join Products P on C.CategoryID = P.CategoryID
    inner join [Order Details] OD on P.ProductID = OD.ProductID
    inner join Orders O on OD.OrderID = O.OrderID
group by C.CategoryName, YEAR(o.OrderDate)
order by year, (sum(OD.UnitPrice * OD.Quantity * (1 - OD.Discount))) DESC;


/*
SELECT
    YEAR(o.OrderDate) AS OrderYear,
    c.CustomerID,
    c.CompanyName,
    SUM(od.UnitPrice * od.Quantity) AS TotalSales,
    COUNT(od.OrderID) AS OrderCount,
    AVG(od.UnitPrice * od.Quantity) AS AverageOrderValue
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY
    YEAR(o.OrderDate),
    c.CustomerID,
    c.CompanyName
ORDER BY
    OrderYear,
    TotalSales DESC;
