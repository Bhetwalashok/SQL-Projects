/*Create a query with the following columns*/

--1. PurchaseOrderID, from Purchasing.PurchaseOrderDetail */
--ans


select Top(4)
a.PurchaseOrderID
from AdventureWorks2022.Purchasing.PurchaseOrderDetail a


--2. PurchaseOrderDetailID, from Purchasing.PurchaseOrderDetail */

Select
a.PurchaseOrderDetailID
from AdventureWorks2022.Purchasing.PurchaseOrderDetail a


--3. OrderQty, from Purchasing.PurchaseOrderDetail


select
a.OrderQty
from AdventureWorks2022.Purchasing.PurchaseOrderDetail a

--4. UnitPrice, from Purchasing.PurchaseOrderDetail


Select
a.UnitPrice
From AdventureWorks2022.Purchasing.PurchaseOrderDetail a


--5. LineTotal, from Purchasing.PurchaseOrderDetail


select
a.LineTotal
From AdventureWorks2022.Purchasing.PurchaseOrderDetail a


--6. OrderDate, from Purchasing.PurchaseOrderHeader


select
B.OrderDate
from AdventureWorks2022.Purchasing.PurchaseOrderHeader B


--7. A derived column, aliased as “OrderSizeCategory”, calculated via CASE logic as follows:
--o When OrderQty > 500, the logic should return “Large”
--o When OrderQty > 50 but <= 500, the logic should return “Medium”
--o Otherwise, the logic should return “Small”

Select
a.OrderQty,
[Order size category] =
case
when a.OrderQty > 500 then 'Large'
when a.OrderQty between 50 and 500 then 'Medium'
else 'Small'
end
from AdventureWorks2022.Purchasing.PurchaseOrderDetail a


--8. The “Name” field from Production.Product, aliased as “ProductName”


SElect
a.Name,
a.Name as "Product Name"
from AdventureWorks2022.Production.Product a

--9. The “Name” field from Production.ProductSubcategory, aliased as “Subcategory”; 
--if this value is
 --NULL, return the string “None” instead

Select
a.Name,
	 [ProductName] = a.name ,
	 [Subcategory] = isnull(a.Name, 'None')
from AdventureWorks2022.Production.ProductSubcategory a


*/

---Create a query with the following columns:

---11. BusinessEntityID, from Person.Person
Select
a.BusinessEntityID
from AdventureWorks2022.Person.Person a


---12. PersonType, from Person.Person
SElect
a.PersonType
from AdventureWorks2022.Person.Person a


/* 13. A derived column, aliased as “FullName”, that combines the first, last, and middle names from
Person.Person.
o There should be exactly one space between each of the names.
o If “MiddleName” is NULL and you try to “add” it to the other two names, the result will
be NULL, which isn’t what you want.
o You could use ISNULL to return an empty string if the middle name is NULL, but then
you’d end up with an extra space between first and last name – a space we would have
needed if we had a middle name to work with.
o So what we really need is to apply conditional, IF/THEN type logic; if middle name is
NULL, we just need a space between first name and last name. If not, then we need a
space, the middle name, and then another space. See if you can accomplish this with a
CASE statement.*/

--ANSWER


Select
a.FirstName,
a.LastName,
a.MiddleName,
[Full Name] =
case
when a.MiddleName is null then a.FirstName + ' ' + a.LastName
else a.FirstName +' ' + a.MiddleName + ' '+ a.LastName
end
from AdventureWorks2022.Person.Person a


-------next 


/*
14. The “AddressLine1” field from Person.Address; alias this as “Address”.
15. The “City” field from Person.Address
16. The “PostalCode” field from Person.Address
17. The “Name” field from Person.StateProvince; alias this as “State”.
18. The “Name” field from Person.CountryRegion; alias this as “Country”.
Only return rows where person type (from Person.Person) is “SP”, OR the postal code begins with a
“9” AND the postal code is exactly 5 characters long AND the country (i.e., “Name” from
Person.CountryRegion) is “United States”   */


SELECT 
    pa.AddressLine1 as Address,
    pa.City,
    pa.PostalCode,
    SP.Name as State,
    CR.Name as Country
FROM AdventureWorks2022.Person.Address AS pa
 
inner JOIN 
    Person.StateProvince as SP on pa.StateProvinceID = SP.StateProvinceID
inner JOIN 
    Person.CountryRegion as CR on SP.CountryRegionCode = CR.CountryRegionCode
inner JOIN 
    Person.Person as P on pa.AddressID = P.BusinessEntityID
WHERE 
    PersonType = 'SP'
    OR ( LEFT(pa.PostalCode, 1) = '9'AND LEN(pa.PostalCode) = 5 AND CR.Name = 'United States')
    




	----- Exercise 3   -----------------

/* Enhance your query from Exercise 3 as follows:
1. Join in the HumanResources.Employee table to Person.Person on BusinessEntityID. Note that
many people in the Person.Person table are not employees, and we don’t want to limit our
output to just employees, so choose your join type accordingly*/




Select *
from AdventureWorks2022.HumanResources.Employee HE
left join AdventureWorks2022.Person.Person PP
on pp.BusinessEntityID = HE.BusinessEntityID



/* 2. Add the “JobTitle” field from HumanResources.Employee to our output. If it is NULL (as it will be
for people in our Person.Person table who are not employees, return “None”*/



SElect
HE.JobTitle,
pp.FirstName,
pp.LastName,
pp.MiddleName,
[Job title] =
case
when HE.JobTitle = 'Null' then 'None'
else HE.JobTitle
end
from AdventureWorks2022.HumanResources.Employee HE
join AdventureWorks2022.Person.Person PP
on pp.BusinessEntityID = HE.BusinessEntityID




 /* 3. Add a derived column, aliased as “JobCategory”, that returns different categories based on the
value in the “JobTitle” column as follows:
o If the job title contains the words “Manager”, “President”, or “Executive”, return
“Management”. Applying wildcards with LIKE could be a helpful approach here.
o If the job title contains the word “Engineer”, return “Engineering”.
o If the job title contains the word “Production”, return “Production”.
o If the job title contains the word “Marketing”, return “Marketing”.
o If the job title is NULL, return “NA”.
o If the job title is one of the following exact strings (NOT patterns), return “Human
Resources”: “Recruiter”, “Benefits Specialist”, OR “Human Resources Administrative
Assistant”. You could use a series of ORs here, but the IN keyword could be a nice
shortcut.
o As a default case when none of the other conditions are true, return “Other”.  */



select
HE.JobTitle,
[HE.JobTitle as "JobCategory"] =
Case
when He.JobTitle Like '%Manager%' or he.JobTitle like '%President%'or he.JobTitle like '%Executive' then 'Management'
when HE.JobTitle like '%Engineer%' then 'Engineering'
when HE.JobTitle like '%Production' then 'Production'
when He.JobTitle Like '%Marketing' then 'Marketing'
when HE.JobTitle like '%Null%' then 'NA'
when HE.JobTitle IN('Recruiter','Benefits Specialist', 'Human Resources Administrative
Assistant') then 'Human
Resources'
else 'Other'
end
from AdventureWorks2022.HumanResources.Employee HE

\



