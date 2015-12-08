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

-- Proc Begin
--TODO: DECLARE @FileLocation VARCHAR(100);
--SET @FileLocation = ''


IF NOT EXISTS ( SELECT
                    *
                FROM
                    INFORMATION_SCHEMA.TABLES
                WHERE
                    TABLE_SCHEMA = 'dbo' AND
                    TABLE_NAME = 'Update' )
    CREATE TABLE [dbo].[Update]
        (
          [SUBCAT_ID] [VARCHAR](50) NULL,
          [MARGIN] [VARCHAR](50) NULL
        )
    ON  [PRIMARY];

TRUNCATE TABLE dbo.[UPDATE];

BULK INSERT dbo.[Update]
   FROM 'C:\Projects\SQLCodeKata\Update.txt'
   WITH 
      (
         FIELDTERMINATOR ='|',
         ROWTERMINATOR ='\n'
      );

UPDATE
    product
SET
    product.ListPrice = [StandardCost] * upd.MARGIN
FROM
    [Production].[Product] product
INNER JOIN [dbo].[Update] upd
    ON product.ProductSubcategoryID = CAST(RIGHT(upd.subcat_id, 2) AS INT);