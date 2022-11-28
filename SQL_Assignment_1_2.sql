DECLARE @TblName varchar(500)
DECLARE @BackupQuery varchar(2000)
DECLARE @UpdateQuery varchar(2000)
SET @TblName = 'Product_' +(CONVERT(VARCHAR(8),GETDATE(),112))
SET @BackupQuery = 'SELECT * INTO ' + @TblName + ' FROM [dbo].[Product] WHERE [Product].[ModelYear] != 2016'
SET @UpdateQuery = 'UPDATE ' + @TblName + ' SET ListPrice = (CASE WHEN ProductName LIKE ''%Heller%'' OR ProductName LIKE ''%Sun Bicycles%'' 
											THEN ListPrice + (ListPrice*20/100) 
											ELSE ListPrice + (ListPrice*10/100)
											END)'
EXEC(@BackupQuery)
EXEC(@UpdateQuery)