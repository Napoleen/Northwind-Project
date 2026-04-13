/* Top customers by total sales */
select  * FROM (
    SELECT 
        c.CustomerID,
        c.CompanyName,
        SUM(od.UnitPrice * od.Quantity) AS TotalSales,
        COUNT(DISTINCT(od.OrderID)) AS OrderCount,
        AVG(od.UnitPrice * od.Quantity) AS AverageOrderValue
        
    FROM 
        Customers c 
    JOIN 
        Orders o ON c.CustomerID = o.CustomerID
    JOIN 
        [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY 
        c.CustomerID, c.CompanyName
) AS CustomerSales 
 order by TotalSales desc;