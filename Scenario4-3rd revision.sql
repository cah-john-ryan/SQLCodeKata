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

IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'UpdateProductListPricesWithMarginData')
                    AND type IN ( N'P', N'PC' ) ) 
	DROP PROCEDURE dbo.UpdateProductListPricesWithMarginData;
GO

CREATE PROCEDURE dbo.UpdateProductListPricesWithMarginData 
	@FileLocation VARCHAR(100)
AS
BEGIN
	--SET NOCOUNT ON;
	DECLARE @BulkExecSQL VARCHAR(200);

	IF OBJECT_ID('tempdb..#BulkLoadTemp') IS NOT NULL
		DROP TABLE #BulkLoadTemp;

		CREATE TABLE #BulkLoadTemp
			(
			  [SUBCAT_ID] [VARCHAR](50) NULL,
			  [MARGIN] [VARCHAR](50) NULL
			)
		ON  [PRIMARY];

	SET @BulkExecSQL = 'BULK INSERT #BulkLoadTemp FROM ''' + @FileLocation + ''' WITH ( FIELDTERMINATOR =''|'', ROWTERMINATOR =''\n'' );'
	EXECUTE(@BulkExecSQL);

	UPDATE
		product
	SET
		product.ListPrice = [StandardCost] * upd.MARGIN
	FROM
		[Production].[Product] product
	INNER JOIN #BulkLoadTemp upd
		ON product.ProductSubcategoryID = CAST(RIGHT(upd.subcat_id,LEN(upd.subcat_id) - CHARINDEX('.', upd.subcat_id)) AS INT);
END
GO

EXECUTE dbo.UpdateProductListPricesWithMarginData 'C:\Projects\SQLCodeKata\Update.txt';