/*
	Scenario 1:
	There was an error in the order entry system that caused duplicate order lines to get entered into the database. Remove the duplicate order lines.
	BONUS: Modify the database so that this error cannot happen again.
*/
USE Kata;
GO


-- To check on the situation.
SELECT
    rowguid,
    COUNT(*)
FROM
    sales.SalesOrderDetail
GROUP BY
    rowguid
HAVING
    COUNT(*) > 1

SELECT
    *
FROM
    sales.SalesOrderDetail
WHERE
    rowguid = '76F3EE0C-D79A-400F-88C5-67B84C3B5880';

-- Now that we have identified the issue, the below should remove 1000 records.
WITH    dupes
          AS ( SELECT
                rowguid,
                ROW_NUMBER() OVER ( PARTITION BY rowguid ORDER BY Sales.SalesOrderDetail.SalesOrderDetailID ) dupe_order
               FROM
                sales.SalesOrderDetail)
    DELETE
        dupes
    WHERE
        dupe_order > 1;
GO

-- To Prevent this moving forward
ALTER TABLE sales.SalesOrderDetail
ADD CONSTRAINT AK_SalesOrderDetail_Rowguid UNIQUE (ROWGUID);

