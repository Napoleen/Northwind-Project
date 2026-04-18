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

/* 
#Shows Category revenue per year, ordered by year and then by revenue. 
*/

select C.CategoryName, year(o.OrderDate) as Year,
    format(sum(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)), 'C', 'en-US') as Revenue

from Categories C
    inner join Products P on C.CategoryID = P.CategoryID
    inner join [Order Details] OD on P.ProductID = OD.ProductID
    inner join Orders O on OD.OrderID = O.OrderID
group by C.CategoryName, YEAR(o.OrderDate)
order by year, (sum(OD.UnitPrice * OD.Quantity * (1 - OD.Discount))) DESC;


