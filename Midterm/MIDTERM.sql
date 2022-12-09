/* PROBLEM 1: Write a script that would return the id and name of the store that does NOT have any Order record (1 pt). */
SELECT [_store].[StoreId], [_store].[StoreName] 
FROM [dbo].[Store] _store LEFT JOIN [dbo].[Order] _order
ON [_order].[StoreId] = [_store].[StoreId]
WHERE [_order].[OrderId] IS NULL

/* PROBLEM 2:  Write a script with the following criteria (4 pts):
	a. Query all Products from Baldwin Bikes store with the model year of 2017 to 2018
	b. Query should return the following fields: Product Id, Product Name, Brand Name, Category Name and Quantity
	c. Result set should be sorted from the highest quantity, Product Name, Brand Name and CategoryName */
SELECT [_product].[ProductId], [_product].[ProductName], [_brand].[BrandName], [_category].[CategoryName], [_stock].[Quantity]
FROM [dbo].[Product] _product INNER JOIN [dbo].[Brand] _brand
ON [_brand].[BrandId] = [_product].[BrandId] INNER JOIN [dbo].[Category] _category
ON [_category].[CategoryId] = [_product].[CategoryId] INNER JOIN [dbo].[Stock] _stock
ON [_product].[ProductId] = [_stock].[ProductId]
WHERE [_stock].[StoreId] IN (SELECT [StoreId] FROM [dbo].[Store] WHERE [StoreName]='Baldwin Bikes')
AND ([ModelYear] = 2017 OR [ModelYear] = 2018)
ORDER BY [_stock].[Quantity] DESC, [ProductName], [BrandName], [CategoryName]

/* PROBLEM 3:  Write a script with the following criteria (3 pts):
	a. Return the total number of orders per year and store name
	b. Query should return the following fields: Store Name, Order Year and the Number of Orders of that year
	c. Result set should be sorted by Store Name and most recent order year */
SELECT [_store].[StoreName], YEAR([_order].[OrderDate]) as OrderYear, count([_order].[OrderDate]) as OrderCount
from [dbo].[Order] _order INNER JOIN [dbo].[Store] _store
ON [_store].[StoreId] = [_order].[StoreId]
GROUP BY [_store].[StoreName], YEAR([_order].[OrderDate])
ORDER BY [_store].[StoreName], YEAR([_order].[OrderDate]) DESC

/* PROBLEM 4:  Write a script with the following criteria (4 pts):
	a. Using a CTE and Window function, select the top 5 most expensive products per brand
	b. Data should be sorted by the most expensive product and product name */
WITH MyCTE AS 
(
	SELECT ROW_NUMBER() OVER( PARTITION BY [_brand].[BrandName] ORDER BY [_product].[ListPrice] DESC, [_product].[ProductName]) AS PriceOrder, 
	[_product].[ProductId], 
	[_product].[ProductName], 
	[_brand].[BrandName], 
	[_product].[ListPrice]
	FROM [dbo].[Product] _product INNER JOIN [dbo].[Brand] _brand
	ON [_brand].[BrandId] = [_product].[BrandId]
)
SELECT [MyCTE].[BrandName], [MyCTE].[ProductId], [MyCTE].[ProductName], [MyCTE].[ListPrice]
FROM MyCTE
WHERE [MyCTE].[PriceOrder] <= 5

/* PROBLEM 5:  Using the script from #3, use a cursor to print the records following the format below (3 pts): */
DECLARE @Cursor CURSOR
DECLARE @VarStoreName varchar(512)
DECLARE @VarOrderYear varchar(512)
DECLARE @VarOrderCount varchar(512)
SET @Cursor = CURSOR STATIC FOR SELECT [_store].[StoreName], YEAR([_order].[OrderDate]) as OrderYear, count([_order].[OrderDate]) as OrderCount
	from [dbo].[Order] _order INNER JOIN [dbo].[Store] _store
	ON [_store].[StoreId] = [_order].[StoreId]
	GROUP BY [_store].[StoreName], YEAR([_order].[OrderDate])
	ORDER BY [_store].[StoreName], YEAR([_order].[OrderDate]) DESC

OPEN @Cursor
WHILE 1 = 1
BEGIN
	FETCH @Cursor INTO @VarStoreName, @VarOrderYear, @VarOrderCount
	IF @@fetch_status <> 0
        BREAK
		PRINT @VarStoreName + ' ' + @VarOrderYear + ' ' + @VarOrderCount
END
CLOSE @Cursor
DEALLOCATE @Cursor

/* PROBLEM 6:  Create a script with one loop is nested within another to output the multiplication tables for the numbers
one to ten */
DECLARE @x INT;
SET @x = 1;
WHILE(@x <= 10)
	BEGIN
		DECLARE @y INT;
		SET @y = 1;
		WHILE(@y <= 10)
			BEGIN
				PRINT CAST(@x as varchar(2)) + ' * ' + CAST(@y as varchar(2)) + ' = ' + CAST((@x*@y) as varchar(3))
				SET @y  = @y + 1;
			END;
			
		SET @x  = @x + 1;
    END;