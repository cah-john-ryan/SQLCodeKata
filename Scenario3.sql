/*
	Scenario 3:
	Steve is a warehouse supervisor with a staff of four to pick the orders. Before the beginning of each shift, Steve splits all of the orders for the day into four lists, one for each of his staff. 
	Tonight (2008-05-01), Bob called in sick. Write a query to split the orders into three equal lists.

	2nd run: breakout the orders evenly by the number of products being picked.
*/
USE Kata;
GO

SELECT
    COUNT(*)
FROM
    Sales.SalesOrderHeader
WHERE
    OrderDate = '2008-05-01';
 --271 expected

SELECT
    COUNT(d.SalesOrderDetailID)
FROM
    Sales.SalesOrderHeader h
INNER JOIN Sales.SalesOrderDetail d
    ON d.SalesOrderID = h.SalesOrderID
WHERE
    OrderDate = '2008-05-01';
--2477 line items.
-- ~800 for each of these employees needed

SELECT h.SalesOrderID,
    COUNT(d.SalesOrderDetailID) AS linecount
FROM
    Sales.SalesOrderHeader h
INNER JOIN Sales.SalesOrderDetail d
    ON d.SalesOrderID = h.SalesOrderID
WHERE
    OrderDate = '2008-05-01'
	GROUP BY h.SalesOrderID;

--WITH lines AS (
--	SELECT h.SalesOrderID,
--    COUNT(d.SalesOrderDetailID) AS linecount
--FROM
--    Sales.SalesOrderHeader h
--INNER JOIN Sales.SalesOrderDetail d
--    ON d.SalesOrderID = h.SalesOrderID
--WHERE
--    OrderDate = '2008-05-01'
--	GROUP BY h.SalesOrderID)
--SELECT NTILE(3) OVER(O;

--SELECT
--    NTILE(3) OVER ( ORDER BY SalesOrderNumber ) staff,
--    COUNT(*)
--FROM
--    Sales.SalesOrderHeader h
--INNER JOIN Sales.SalesOrderDetail d
--    ON d.SalesOrderID = h.SalesOrderID
--WHERE
--    OrderDate = '2008-05-01'
--GROUP BY
--    h.SalesOrderID;

WITH lines AS(
SELECT SalesOrderID
, COUNT(*) OVER(PARTITION BY SalesOrderID) linecount
FROM sales.SalesOrderDetail
)
SELECT NTILE(3) OVER (ORDER BY linecount) staff,
salesorderid, linecount
FROM lines;