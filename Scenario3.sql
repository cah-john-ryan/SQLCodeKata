/*
	Scenario 3:
	Steve is a warehouse supervisor with a staff of four to pick the orders. Before the beginning of each shift, Steve splits all of the orders for the day into four lists, one for each of his staff. 
	Tonight (2008-05-01), Bob called in sick. Write a query to split the orders into three equal lists.
*/
USE Kata;
GO


--create distinct rows
WITH    OrderHeaders
          AS ( SELECT
                ROW_NUMBER() OVER ( ORDER BY soh.SalesOrderID ) AS [The Row],
                soh.SalesOrderID
               FROM
                sales.SalesOrderHeader soh
               WHERE
                soh.OrderDate = '2008-05-01')
    SELECT
        NTILE(3) OVER ( ORDER BY headers.SalesOrderID ) AS [Staff],
        headers.SalesOrderID,
        COUNT(orders.SalesOrderDetailID) AS TotalLinesPerOrder
    FROM
        OrderHeaders headers
    INNER JOIN sales.SalesOrderDetail orders
        ON headers.SalesOrderID = orders.SalesOrderID
    GROUP BY
        headers.SalesOrderID
    ORDER BY
        COUNT(orders.SalesOrderDetailID) DESC;



SELECT
    NTILE(3) OVER ( ORDER BY headers.SalesOrderID ) AS [Staff],
    headers.SalesOrderID,
    COUNT(orders.SalesOrderDetailID) AS TotalLinesPerOrder
FROM
    sales.SalesOrderHeader headers
INNER JOIN sales.SalesOrderDetail orders
    ON headers.SalesOrderID = orders.SalesOrderID
WHERE
    headers.OrderDate = '2008-05-01'
GROUP BY
    headers.SalesOrderID
ORDER BY
    COUNT(orders.SalesOrderDetailID) DESC;

-- I drove this home, not Avery - JR
WITH    OrderInfo
          AS ( SELECT
                ROW_NUMBER() OVER ( ORDER BY COUNT(orders.SalesOrderDetailID) DESC ) AS [TheRow],
                headers.SalesOrderID,
                COUNT(orders.SalesOrderDetailID) AS TotalLinesPerOrder
               FROM
                sales.SalesOrderHeader headers
               INNER JOIN sales.SalesOrderDetail orders
                ON headers.SalesOrderID = orders.SalesOrderID
               WHERE
                headers.OrderDate = '2008-05-01'
               GROUP BY
                headers.SalesOrderID)
    SELECT
        --TheRow,
		(TheRow % 3) + 1 [Result],
        SalesOrderID,
        TotalLinesPerOrder
    FROM
        OrderInfo oi
    ORDER BY
        (TheRow % 3) + 1,
		TotalLinesPerOrder

    --ORDER BY
    --    COUNT(orders.SalesOrderDetailID) DESC;