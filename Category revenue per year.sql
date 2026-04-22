/* Which product categories generate the most revenue, and is that share growing or shrinking over time? 
 # Tables used: Categories, order details, products, orders */

-- Format total revenue as currency, accounting for quantity and discounts
select C.CategoryName, year(o.OrderDate) as Year,
    format(sum(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)), 'C', 'en-US') as Revenue
-- Join categories with products, order details, and orders to connect all data
from Categories C
    inner join Products P on C.CategoryID = P.CategoryID
    inner join [Order Details] OD on P.ProductID = OD.ProductID
    inner join Orders O on OD.OrderID = O.OrderID
    -- Group results by category name and year to aggregate revenue by category per year
group by C.CategoryName, YEAR(o.OrderDate)
order by year, (sum(OD.UnitPrice * OD.Quantity * (1 - OD.Discount))) DESC;
