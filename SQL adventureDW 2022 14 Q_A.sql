  RAWDATA --AdventureWorksDW2022 --//
/*
1 . What is the total sales?
Q2. What is the total profit?
Q3. What is the total cost amount?
Q4. What is the sales per year?
Q5. What is the average sales per customers?
Q6. What is the number of products in each category?
Q7. Top 10 Customers with the highest purchase
Q8. Top 10 Customers with the highest order
Q9. Top 10 Employees with the highest sale
Q10. Top 10 most sale products
Q11. What is the total customer?
Q12. What is the total transaction?
Q13. Distribution of order is simply to see how customers are making orders.
Q14. Ranking customers by sales
*/


------------------------                 QUESTIONS and ANSWERS              --------------------------





1. --What is the total sales? --

/*To get the total sales, I add the sales amount using the SUM( ) function and ROUND( ) 
function. The SUM( ) function adds up the sales amount in the Sales table and the ROUND( ) 
function rounds the decimal place to two, so total sales is $29358677.22 */

SELECT 
ROUND(SUM(a.SalesAmount), 2) AS [Total Sales] 
FROM AdventureWorksDW2022.dbo.FactInternetSales a 





2.--What is the total profit? --


--The total profit is calculated by subtracting the sum of productcost from the sales amount. The 
--total profit is $12080883.65


SELECT
ROUND((SUM(a.Salesamount) - SUM(a.totalproductcost)), 2) as [Total Profit] 
FROM AdventureWorksDW2022.dbo.FactInternetSales a 






3.--What is the total cost amount?--

--The cost amount is calculated by summing up the ProductStandardCost column in the sales 
--table using SUM( ) and ROUND( ) function. The total cost price is $17277793.58. 


SELECT 
ROUND(SUM(a.ProductStandardCost),2) [a.Cost Price] 
FROM AdventureWorksDW2022.dbo.FactInternetSales a 





4. --What is the sales per year?--
-- Sales per year is the total sales for each year. This is calculated by first joining the Date table 
-- to the Sales table then selecting the calendaryear from the Date table and summing the 
-- salesamount in the sales table then using the GROUP BY( ) function to group the Sales into 
-- the respective years. 


SELECT
CalendarYear AS Year,
ROUND(SUM(SalesAmount), 2) AS [Total Sales] 
FROM AdventureWorksDW2022.dbo.FactInternetSales  f 
JOIN DimDate d ON d.DateKey = f.OrderDateKey 
GROUP BY CalendarYear 
ORDER BY [Total Sales] DESC 





5. ---- What is the average sales per customers?--


-- Average sales per customer is the average of the total purchase for each customers. Here use 
-- CONCAT( ). 
-- The CONCAT( ) function joins the last and first name of each customers to form customer 
-- name. The INNER JOIN, joins the customer table to the sales table using the Customerkey 
-- column as the joining column between the two table. The inner join returns matching rows 
-- between the two tables. The AVG( ) function find the average of sales and the GROUP BY ( ) 
-- group the average sales by each customers, ORDER BY ( ) orders the customer names in 
-- ascending order(Alphabetically) 


SELECT 
CONCAT(firstname,' ', LastName) AS [Customer Name], 
round(AVG(salesAmount),1) as AverageSales 
FROM dimcustomer c 
INNER JOIN FactInternetSales s 
ON c.CustomerKey = s.CustomerKey 
GROUP BY CONCAT(firstname,' ', LastName) 
ORDER BY [Customer Name] 
 



 6. -- What is the number of products in each category?--
 
-- Here ind the total products in each category. 
-- The product , category and subcategory details are stored in different tables. The product table 
-- has the subcategorykey column but does not have the categorykey column. The categorykey 
-- column is present in the subcategory table. To join the category table to the product table you 
-- need the categorykey. For this use a subquery to get the Product name and categorykey from 
-- the product and subcategory tables, then joined the result to the category table. Do  a count of 
-- the productnames then group by categoryname. 



SELECT Englishproductcategoryname [Product Category],
COUNT(EnglishProductName) AS [Number of Products in Category] 
FROM AdventureWorksDW2022.dbo.DimProductCategory c 
INNER JOIN 
(SELECT EnglishProductName, productcategorykey 
FROM DimProduct p 
INNER JOIN DimProductSubcategory ps 
ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey 
GROUP BY EnglishProductName, ProductCategoryKey) ps 
ON c.ProductCategoryKey = ps.ProductCategoryKey 
GROUP BY  Englishproductcategoryname 



7. --Top 10 Customers with the highest purchase

-- Here look for the top 10 customers with the highest purchase. First selecte TOP 10 and joined 
-- the customers last and first names together, then find the total sales. Do  a group by and 
-- ordered the result in descending order (highest to lowest)


SELECT TOP 10 firstname + ' ' + lastname AS [Customer Name], 
ROUND(SUM(SalesAmount), 2) as [Total Sales] 
FROM DimCustomer d 
JOIN FactInternetSales f ON f.CustomerKey = d.CustomerKey 
GROUP BY firstname + ' ' + lastname 
ORDER BY [Total Sales] DESC 


8. ----Top 10 Customers with the highest order

-- Getting to know how much orders the customers make is important. 
-- Select  TOP 10, joined the first and last names of customers together then do a SUM of the 
-- orderquantity and grouped by the customer names. Sort by Orders in descending order. 


SELECT TOP 10 CONCAT(firstname, ' ',  lastname) as [Customer Name], 
SUM(orderquantity) as Orders 
FROM FactInternetSales f 
JOIN DimCustomer c ON c.CustomerKey = f.CustomerKey 
GROUP BY CONCAT(firstname, ' ', lastname) 
ORDER BY Orders DESC 




9. --- Top 10 Employees with the highest sale-----

-- Getting to know the Employees performance is important to every Organization. 
-- Join  the sales, employee and territory tables together. For each employees  show the country 
-- in which they make their sales.


SELECT TOP 10 FirstName + ' ' + LastName as [Empolyee Name],  
SalesTerritoryCountry AS [Sales Country], 
ROUND(SUM(salesamount), 2) as [Total Sales] 
FROM FactInternetSales AS f 
JOIN DimSalesTerritory AS t  
ON f.SalesTerritoryKey = t.SalesTerritoryKey 
JOIN DimEmployee AS e  
ON e.SalesTerritoryKey = t.SalesTerritoryKey 
GROUP BY SalesTerritoryCountry, FirstName + ' ' + LastName 
ORDER BY [Total Sales] DESC 





10. --Top 10 most sale products--

-- The goal of every organization is to make profit, to make profit the organization needs to 
-- know the products customers are buying.selecte TOP 10, product name, product category, 
-- product subcategory and sum of sales amount. All these are stored in different tables so, join 
-- the tables together, grouped by the product name, product category and product subcategory. 
-- Lastly order by sales in descending order to arrange from the highest sales to the lowest sales. 


SELECT TOP 10 EnglishProductName AS Product, EnglishProductCategoryName AS Category, 
ps.EnglishProductSubcategoryName AS [Product Subcategory],  
ROUND(SUM(SalesAmount), 2) AS Sales 
from FactInternetSales AS f 
INNER JOIN DimProduct AS p ON f.ProductKey =p.ProductKey  
INNER JOIN DimProductSubcategory AS ps ON ps.ProductSubcategoryKey = 
p.ProductSubcategoryKey 
INNER JOIN DimProductCategory pc ON pc.ProductCategoryKey = ps.ProductCategoryKey 
GROUP BY EnglishProductName, EnglishProductCategoryName, EnglishProductSubcategoryName 
ORDER BY  Sales DESC 





11. --What is the total customer?


-- The total customers is gotten by counting the customerkey because it is unique for every 
-- ncustomers. The DISTINCT( ) function makes sure there is no duplicate in the customerkey 
-- when counting


SELECT DISTINCT(COUNT(CustomerKey))  [Total Customers] 
FROM DimCustomer




12. ---What is the total transaction?

-- This is gotten by simply counting the quantities ordered 


SELECT COUNT(ORDERQUANTITY) AS [Total Ordered Qantity] 
FROM FactInternetSales 




13.--- Distribution of order is simply to see how customers are making orders.---

-- For this a wrote a subquery. The inner query gives the count of orders each customers makes. 
-- Write an outer query to select the total orders from the subquery, count of all rows in the 
-- customer table. The total orders is gotten from the subquery while the count of rows is coming 
-- from the customer table so join  the two tables together and group by the total orders. Most of 
-- the customers only orders twice.


SELECT Total_orders,
COUNT(*) AS [ Number of customer] 
FROM (SELECT c.customerkey, COUNT(salesordernumber) AS  total_orders 
FROM FactInternetSales f 
JOIN DimCustomer c  ON c.CustomerKey = f.CustomerKey 
GROUP BY c.customerkey) a 
GROUP BY total_orders 
ORDER BY [ Number of customer] DESC 


14.  ----. Ranking customers by sales  ----

-- The CASE function is a powerful function in SQL, it works like the (IF statement in other 
-- programming languages). Here use it to rank the customers according to their sales. Customers 
-- with sales greater than 10000 are ranked Diamond, customers with sales between 5000 and 
-- 9999 are ranked Gold, customers with sales between 1000 and 4999 are ranked Silver, any 
-- customer with sales less than 1000 are ranked Bronze. This is useful when the company wants 
-- to award membership card or give discount to the top buying customers. 



SELECT 
CONCAT(firstname, ' ',  lastname) as [Customer Name], 
ROUND(SUM(SALESAMOUNT), 2) AS [Total Sales], 
CASE WHEN SUM(SALESAMOUNT) > 10000 THEN 'Diamond' 
WHEN SUM(SALESAMOUNT) BETWEEN 5000 AND 9999 THEN 'Gold' 
WHEN SUM(SALESAMOUNT) BETWEEN 1000 AND 4999 THEN 'Silver' 
ELSE 'Bronze' 
END AS Rank 
FROM FactInternetSales f 
JOIN DimCustomer c ON c.CustomerKey = f.CustomerKey 
GROUP BY CONCAT(firstname, ' ',  lastname) 
ORDER BY [Total Sales] DESC 




