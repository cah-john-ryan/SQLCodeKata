/*
	Scenario 4:
	The team has been sent an extract from the mainframe to perform price updates based on category. Using Update.txt, update the product pricing.

	The file format is:

	ProductCategoryId.ProductSubcategoryId|Margin
	-------------------------------------------------
	000001.000001|1.7950

	The list price should be Standard Cost * Margin
*/
USE Kata;
GO

-- Used the Import wizard to import the file to the dbo.Update table.

SELECT
    *
FROM
    dbo.[UPDATE];


--SELECT
--	product.ProductID,
--	product.ProductSubcategoryID,
--	product.ListPrice [OldListPrice],
--	[StandardCost] * upd.MARGIN [NewListPrice]
UPDATE
    product
SET
    product.ListPrice = [StandardCost] * upd.MARGIN
FROM
    [Production].[Product] product
INNER JOIN [dbo].[Update] upd
    ON product.ProductSubcategoryID = CAST(RIGHT(upd.subcat_id, 2) AS INT);