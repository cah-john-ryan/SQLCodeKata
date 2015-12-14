/*
	Scenario 3:
	Steve is a warehouse supervisor with a staff of four to pick the orders. Before the beginning of each shift, Steve splits all of the orders for the day into four lists, one for each of his staff. 
	Tonight (2008-05-01), Bob called in sick. Write a query to split the orders into three equal lists.
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
    NTILE(3) OVER ( ORDER BY SalesOrderNumber ) staff,
    *
FROM
    Sales.SalesOrderHeader
WHERE
    OrderDate = '2008-05-01';


