SELECT [Order].[CustomerId], (SELECT COUNT([Order].[CustomerId])) AS OrderCount 
FROM [dbo].[Order] 
WHERE ([Order].[OrderDate] BETWEEN '2017-01-01' AND '2018-12-31')  
AND ([Order].[ShippedDate] IS NULL) 
GROUP BY [Order].[CustomerId] 
HAVING COUNT([Order].[CustomerId]) > 1 
