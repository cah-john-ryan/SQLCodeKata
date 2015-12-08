/*
	Scenario 3:
	Steve is a warehouse supervisor with a staff of four to pick the orders. Before the beginning of each shift, Steve splits all of the orders for the day into four lists, one for each of his staff. 
	Tonight (2008-05-01), Bob called in sick. Write a query to split the orders into three equal lists.
*/
USE Kata;
GO

SELECT
    MIN(SalesOrderID) AS Starting_Value,
    MAX(SalesOrderID) AS Ending_Value,
    COUNT(*) AS Total_Records,
    grp_nbr AS Group_Nbr,
    SUM(OrderQty)
FROM
    ( SELECT
        Sales.SalesOrderHeader.SalesOrderID,
        sales.SalesOrderDetail.OrderQty,
        NTILE(3) OVER ( ORDER BY Sales.SalesOrderDetail.SalesOrderDetailID ) grp_nbr
      FROM
        [Sales].[SalesOrderHeader]
      LEFT OUTER JOIN [Sales].[SalesOrderDetail]
        ON SalesOrderDetail.SalesOrderID = Sales.SalesOrderHeader.SalesOrderID
      WHERE
        OrderDate = '20080501' ) AS IV
GROUP BY
    grp_nbr;




SELECT
    sd.SalesOrderID,
    SUM(OrderQty) AS QUANTITY,
	NTILE(3) OVER (ORDER BY sd.OrderQty) qgrp_nbr
FROM
    Sales.SalesOrderDetail sd
INNER JOIN Sales.SalesOrderHeader sh
    ON sh.SalesOrderID = sd.SalesOrderID
WHERE
    sh.OrderDate = '20080501'
GROUP BY
    sd.SalesOrderID,
	sd.OrderQty
ORDER BY
    QUANTITY