--Exercise 1
SELECT
*
FROM Shippers;

--Exercise 2
SELECT
CategoryName, Description
FROM Categories;

--Exercise 3
SELECT
FirstName, LastName, HireDate
FROM Employees
WHERE Title = 'Sales Representative';

--Exercise 4
SELECT FirstName, LastName, HireDate 
FROM Employees 
WHERE Title = 'Sales Representative' AND Country = 'USA';

--Exercise 5
SELECT OrderId, OrderDate 
FROM Orders 
WHERE EmployeeId = 5;

--Exercise 6
SELECT SupplierId, ContactName, ContactTitle 
FROM Suppliers 
WHERE ContactTitle != 'Marketing Manager';

--Exercise 7
-- Use %<STRING>% to find columns with a string value in any position
SELECT ProductID, ProductName 
FROM Products 
WHERE ProductName LIKE '%queso%';

--Exercise 8
SELECT OrderID,CustomerID, ShipCountry
FROM Orders
WHERE ShipCountry in ('France', 'Belgium');

SELECT OrderID,CustomerID, ShipCountry
FROM Orders
WHERE ShipCountry = 'France' or ShipCountry = 'Belgium';

--Exercise 9
SELECT OrderID,CustomerID, ShipCountry 
FROM Orders 
WHERE ShipCountry in ('Brazil', 'Mexico', 'Argentina', 'Venezuela');

--Exercise 10
-- Sort order is ASC by default
SELECT FirstName, LastName, Title, BirthDate 
FROM Employees
ORDER BY BirthDate;

--Exercise 11
SELECT FirstName, LastName, Title, CONVERT(date, BirthDate) 
FROM Employees 
ORDER BY BirthDate;

--Exercise 12
SELECT FirstName, LastName, Title, CONCAT(FirstName, ' ', LastName) AS FullName 
FROM Employees;

--Exercise 13
SELECT
OrderId, ProductId, UnitPrice, Quantity, (UnitPrice * Quantity) AS TotalPrice 
FROM OrderDetails 
ORDER BY OrderId, ProductId;

--Exercise 14
SELECT COUNT(*) AS TotalCustomers
FROM Customers;

--Exercise 15
SELECT OrderDate as FirstOrder
FROM Orders
ORDER BY OrderDate OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;

SELECT MIN(OrderDate) AS FirstOrder
FROM Orders;

--Exercise 16
SELECT DISTINCT(Country) 
FROM Customers 
ORDER BY Country;

SELECT Country
FROM Customers
GROUP BY Country;

--Exercise 17
SELECT
ContactTitle, COUNT(ContactTitle) AS TotalContactTitle
FROM Customers
GROUP BY ContactTitle
ORDER BY TotalContactTitle DESC;

--Exercise 18
SELECT 
ProductID, ProductName, CompanyName 
FROM Products, Suppliers
WHERE Products.SupplierID = Suppliers.SupplierID;

SELECT 
ProductID, ProductName, CompanyName 
FROM Products 
INNER JOIN Suppliers 
ON Products.SupplierID = Suppliers.SupplierID;

--Exercise 19
SELECT OrderId, CONVERT(date, OrderDate) as OrderDate, CompanyName 
FROM Orders, Shippers 
WHERE Orders.ShipVia = Shippers.ShipperID AND OrderId < 10300;

--Exercise 20
SELECT CategoryName, COUNT(Products.ProductID) as TotalProducts 
FROM Products, Categories 
WHERE Products.CategoryID = Categories.CategoryID 
GROUP BY CategoryName 
ORDER BY TotalProducts DESC;

--Exercise 21
SELECT Country, City, COUNT(CustomerID) as TotalCustomers 
FROM Customers 
GROUP BY Country, City 
ORDER BY TotalCustomers DESC;

--Exercise 22
SELECT ProductId, ProductName, UnitsInStock, ReorderLevel 
FROM Products 
WHERE UnitsInStock < ReorderLevel 
ORDER BY ProductId;

--Exercise 23
SELECT
ProductId, ProductName, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued
FROM Products
WHERE UnitsInStock + UnitsOnOrder <= ReorderLevel AND Discontinued = 0;

--Exercise 24
SELECT
CustomerId, CompanyName, Region
FROM Customers
ORDER BY (CASE WHEN Region is NULL then 0 else 1 END) DESC, Region, CustomerID;

SELECT CustomerId, CompanyName, Region
FROM Customers
ORDER BY (CASE WHEN Region is NULL then 1 else 0 END), Region, CustomerID;

--Exercise 25
SELECT TOP 3 
ShipCountry, AverageFreight = AVG(Freight)
FROM Orders
GROUP BY ShipCountry
ORDER BY AverageFreight DESC;

--Exercise 26
SELECT TOP 3 
ShipCountry, AverageFreight = AVG(Freight)
FROM Orders
WHERE OrderDate >= '2015-01-01' AND OrderDate < '2016-01-01'
GROUP BY ShipCountry
ORDER BY AverageFreight DESC;

--Exercise 27

--Exercise 28
SELECT TOP 3
ShipCountry, AverageFreight = AVG(Freight)
FROM Orders
WHERE OrderDate > (SELECT DATEADD(MONTH, -12, (SELECT TOP 1 OrderDate From Orders Order By OrderID DESC)))
GROUP BY ShipCountry
ORDER BY AverageFreight DESC;

SELECT TOP 3
ShipCountry, AverageFreight = AVG(Freight)
FROM Orders
WHERE OrderDate > (SELECT DATEADD(YEAR, -1, (SELECT TOP 1 OrderDate From Orders Order By OrderID DESC)))
GROUP BY ShipCountry
ORDER BY AverageFreight DESC;

--Exercise 29
SELECT
Employees.EmployeeID, LastName, Orders.OrderID, ProductName, Quantity
FROM Employees
INNER JOIN Orders
ON Employees.EmployeeID = Orders.EmployeeID
INNER JOIN OrderDetails
ON Orders.OrderId = OrderDetails.OrderId
INNER JOIN Products
ON OrderDetails.ProductId = Products.ProductId;

--Exercise 30
SELECT
Customers.CustomerId AS Customers_CustomerID, Orders.CustomerID AS Orders_CustomerID
FROM Customers
LEFT JOIN Orders
ON Customers.CustomerId = Orders.CustomerId
WHERE Orders.CustomerId IS NULL;

--Exercise 31
SELECT Customers.CustomerID, Orders.CustomerID
FROM Customers
LEFT OUTER JOIN (SELECT * FROM Orders WHERE EmployeeId = 4) as Orders
ON Customers.CustomerID = Orders.CustomerID
WHERE OrderId IS NULL;

--Exercise 32
SELECT
Customers.CustomerId, Customers.CompanyName, Orders.OrderID, TotalOrderAmount=SUM(Quantity * UnitPrice)
FROM Orders
INNER JOIN OrderDetails
ON Orders.OrderId = OrderDetails.OrderID
INNER JOIN Customers
ON Orders.CustomerID = Customers.CustomerID
WHERE Orders.OrderDate >= '2016-01-01' AND Orders.OrderDate < '2017-01-01'
GROUP BY Customers.CustomerId, Customers.CompanyName, Orders.OrderID
HAVING SUM(Quantity * UnitPrice) >= 10000
ORDER BY TotalOrderAmount DESC;

--Exercise 33
SELECT
Customers.CustomerId, Customers.CompanyName, TotalOrderAmount=SUM(OrderDetails.Quantity * OrderDetails.UnitPrice)
FROM Orders
INNER JOIN OrderDetails
ON Orders.OrderId = OrderDetails.OrderID
INNER JOIN Customers
ON Orders.CustomerID = Customers.CustomerID
WHERE Orders.OrderDate >= '2016-01-01' AND Orders.OrderDate < '2017-01-01'
GROUP BY Customers.CustomerId, Customers.CompanyName
HAVING SUM(OrderDetails.Quantity * OrderDetails.UnitPrice) >= 15000
ORDER BY TotalOrderAmount DESC;

--Exercise 34
SELECT
Customers.CustomerId,
Customers.CompanyName,
TotalsWithoutDiscount=SUM(OrderDetails.Quantity * OrderDetails.UnitPrice),
TotalsWithDiscount=SUM(OrderDetails.Quantity * OrderDetails.UnitPrice * (1 - OrderDetails.Discount))
FROM Orders
INNER JOIN OrderDetails
ON Orders.OrderId = OrderDetails.OrderID
INNER JOIN Customers
ON Orders.CustomerID = Customers.CustomerID
WHERE Orders.OrderDate >= '2016-01-01' AND Orders.OrderDate < '2017-01-01'
GROUP BY Customers.CustomerId, Customers.CompanyName
HAVING SUM(OrderDetails.Quantity * OrderDetails.UnitPrice * (1 - OrderDetails.Discount)) >= 10000
ORDER BY TotalsWithDiscount DESC;

--Exercise 35
SELECT
EmployeeId, OrderId, OrderDate
FROM Orders
WHERE DATEDIFF(MONTH, OrderDate,DATEADD(DAY, 1, OrderDate)) > 0
ORDER BY EmployeeID;

--Exercise 36
SELECT TOP 10
Orders.OrderID, TotalOrderDetails=COUNT(OrderDetails.OrderID)
FROM Orders
INNER JOIN OrderDetails
ON Orders.OrderID = OrderDetails.OrderID
GROUP BY Orders.OrderID
ORDER BY TotalOrderDetails DESC;

--Exercise 37
DECLARE @X INT;
SET @X=CEILING((SELECT COUNT(*) FROM ORDERS)*0.02)

SELECT 
*
FROM ORDERS
ORDER BY NEWID()
OFFSET 0 ROWS 
FETCH NEXT @X ROWS ONLY;

SELECT TOP 2 percent
*
FROM ORDERS
ORDER BY NEWID();

--Exercise 38
SELECT
OrderID
FROM OrderDetails
WHERE Quantity >= 60
GROUP BY OrderID, Quantity
HAVING COUNT(OrderID) > 1;

--Exercise 39
;with PossibleDuplicates AS (
SELECT
OrderID
FROM OrderDetails
WHERE Quantity >= 60
GROUP BY OrderID, Quantity
HAVING COUNT(OrderID) > 1)

SELECT
DISTINCT PossibleDuplicates.OrderId, ProductID, UnitPrice, Quantity, Discount
FROM PossibleDuplicates
LEFT JOIN OrderDetails
ON PossibleDuplicates.OrderID = OrderDetails.OrderID
ORDER BY OrderId, Quantity;

--Exercise 40
SELECT
OrderDetails.OrderID, ProductID, UnitPrice, Quantity, Discount
FROM OrderDetails
INNER JOIN (
    SELECT
    DISTINCT OrderID
    FROM OrderDetails
    WHERE Quantity >= 60
    GROUP BY OrderID, Quantity
    HAVING COUNT(*) > 1
) PossibleDuplicates
ON PossibleDuplicates.OrderID = OrderDetails.OrderID
ORDER BY OrderID, ProductID;

--Exercise 41
SELECT
OrderID, OrderDate, RequiredDate, ShippedDate
FROM Orders
WHERE ShippedDate >= RequiredDate;

--Exercise 42
SELECT
Orders.EmployeeId, Employees.LastName, TotalLateOrders=COUNT(OrderID)
FROM Orders
INNER JOIN Employees
ON Orders.EmployeeID = Employees.EmployeeID
WHERE ShippedDate >= RequiredDate
GROUP BY Orders.EmployeeID, Employees.LastName
ORDER BY TotalLateOrders DESC;

--Exercise 43
SELECT
Orders.EmployeeId, Employees.LastName, AllOrders=COUNT(OrderID), LateOrders=SUM(CASE WHEN ShippedDate >= RequiredDate THEN 1 ELSE NULL END)
FROM Orders
INNER JOIN Employees
ON Orders.EmployeeID = Employees.EmployeeID
GROUP BY Orders.EmployeeID, Employees.LastName
HAVING SUM(CASE WHEN ShippedDate >= RequiredDate THEN 1 ELSE NULL END) IS NOT NULL
ORDER BY Orders.EmployeeID;

--Exercise 44
SELECT
Orders.EmployeeId, Employees.LastName, AllOrders=COUNT(OrderID), LateOrders=SUM(CASE WHEN ShippedDate >= RequiredDate THEN 1 ELSE NULL END)
FROM Orders
INNER JOIN Employees
ON Orders.EmployeeID = Employees.EmployeeID
GROUP BY Orders.EmployeeID, Employees.LastName
ORDER BY Orders.EmployeeID;

--Exercise 45
SELECT
Orders.EmployeeId, Employees.LastName, AllOrders=COUNT(OrderID), LateOrders=SUM(CASE WHEN ShippedDate >= RequiredDate THEN 1 ELSE 0 END)
FROM Orders
INNER JOIN Employees
ON Orders.EmployeeID = Employees.EmployeeID
GROUP BY Orders.EmployeeID, Employees.LastName
ORDER BY Orders.EmployeeID;

--Exercise 46
SELECT
Orders.EmployeeId, 
Employees.LastName, 
AllOrders=COUNT(OrderID), 
LateOrders=SUM(CASE WHEN ShippedDate >= RequiredDate THEN 1 ELSE 0 END), 
PercentLateOrders=SUM(CASE WHEN ShippedDate >= RequiredDate THEN 1 ELSE 0 END)/CONVERT(float, COUNT(OrderID))
FROM Orders
INNER JOIN Employees
ON Orders.EmployeeID = Employees.EmployeeID
GROUP BY Orders.EmployeeID, Employees.LastName
ORDER BY Orders.EmployeeID;

--Exercise 47
SELECT
Orders.EmployeeId, 
Employees.LastName, 
AllOrders=COUNT(OrderID), 
LateOrders=SUM(CASE WHEN ShippedDate >= RequiredDate THEN 1 ELSE 0 END), 
PercentLateOrders=ROUND(SUM(CASE WHEN ShippedDate >= RequiredDate THEN 1 ELSE 0 END)/CONVERT(float, COUNT(OrderID)), 2)
FROM Orders
INNER JOIN Employees
ON Orders.EmployeeID = Employees.EmployeeID
GROUP BY Orders.EmployeeID, Employees.LastName
ORDER BY Orders.EmployeeID;

--Exercise 48
;with CustomerTotals AS (
    SELECT
    Customers.CustomerId, Customers.CompanyName, TotalOrderAmount=SUM(Quantity * UnitPrice)
    FROM Customers
    INNER JOIN Orders
    ON Orders.CustomerID = Customers.CustomerID
    INNER JOIN OrderDetails
    ON Orders.OrderID = OrderDetails.OrderID
    WHERE OrderDate >= '2016-01-01' AND OrderDate < '2017-01-01'
    GROUP BY Customers.CustomerId, Customers.CompanyName
)

SELECT
CustomerId, TotalOrderAmount, CustomerGroup=(
    CASE 
        WHEN TotalOrderAmount BETWEEN 0 AND 1000 THEN 'Low'
        WHEN TotalOrderAmount BETWEEN 1001 AND 5000 THEN 'Medium'
        WHEN TotalOrderAmount BETWEEN 5001 AND 10000 THEN 'High'
        WHEN TotalOrderAmount > 10000 THEN 'Very High'
        ELSE NULL
    END
)
FROM CustomerTotals
ORDER BY CustomerId;

--Exercise 49
;with CustomerTotals AS (
    SELECT
    Customers.CustomerId, Customers.CompanyName, TotalOrderAmount=SUM(Quantity * UnitPrice)
    FROM Customers
    INNER JOIN Orders
    ON Orders.CustomerID = Customers.CustomerID
    INNER JOIN OrderDetails
    ON Orders.OrderID = OrderDetails.OrderID
    WHERE OrderDate >= '2016-01-01' AND OrderDate < '2017-01-01'
    GROUP BY Customers.CustomerId, Customers.CompanyName
)

SELECT
CustomerId, TotalOrderAmount, CustomerGroup=(
    CASE 
        WHEN TotalOrderAmount >= 0 AND TotalOrderAmount <= 1000 THEN 'Low'
        WHEN TotalOrderAmount >= 1000 AND TotalOrderAmount <= 5000 THEN 'Medium'
        WHEN TotalOrderAmount >= 5000 AND TotalOrderAmount <= 10000 THEN 'High'
        WHEN TotalOrderAmount >= 10000 THEN 'Very High'
    END
)
FROM CustomerTotals
ORDER BY CustomerId;

--Exercise 50
;with CustomerTotals AS (
    SELECT
    Customers.CustomerId, Customers.CompanyName, TotalOrderAmount=SUM(Quantity * UnitPrice)
    FROM Customers
    INNER JOIN Orders
    ON Orders.CustomerID = Customers.CustomerID
    INNER JOIN OrderDetails
    ON Orders.OrderID = OrderDetails.OrderID
    WHERE OrderDate >= '2016-01-01' AND OrderDate < '2017-01-01'
    GROUP BY Customers.CustomerId, Customers.CompanyName
), CustomerGroups AS (SELECT
CustomerId, TotalOrderAmount, CustomerGroup=(
    CASE 
        WHEN TotalOrderAmount >= 0 AND TotalOrderAmount <= 1000 THEN 'Low'
        WHEN TotalOrderAmount >= 1000 AND TotalOrderAmount <= 5000 THEN 'Medium'
        WHEN TotalOrderAmount >= 5000 AND TotalOrderAmount <= 10000 THEN 'High'
        WHEN TotalOrderAmount >= 10000 THEN 'Very High'
    END
)
FROM CustomerTotals)

SELECT 
CustomerGroup, COUNT(CustomerGroup) as 'Group Total', COUNT(CustomerGroup)/CONVERT(float, (SELECT COUNT(*) FROM CustomerGroups)) as 'Percentage In Group'
FROM CustomerGroups 
GROUP BY CustomerGroup
ORDER BY COUNT(CustomerGroup) DESC;

--Exercise 51
;with CustomerTotals AS (
    SELECT
    Customers.CustomerId, Customers.CompanyName, TotalOrderAmount=SUM(Quantity * UnitPrice)
    FROM Customers
    INNER JOIN Orders
    ON Orders.CustomerID = Customers.CustomerID
    INNER JOIN OrderDetails
    ON Orders.OrderID = OrderDetails.OrderID
    WHERE OrderDate >= '2016-01-01' AND OrderDate < '2017-01-01'
    GROUP BY Customers.CustomerId, Customers.CompanyName
)

SELECT
CustomerId, TotalOrderAmount, CustomerGroupName
FROM CustomerTotals
INNER JOIN CustomerGroupThresholds
ON TotalOrderAmount >= CustomerGroupThresholds.RangeBottom and TotalOrderAmount < CustomerGroupThresholds.RangeTop
ORDER BY CustomerId;

--Exercise 52
SELECT Country
FROM Suppliers
UNION
SELECT Country
FROM Customers;

--Exercise 53
SELECT 
SupplierCountries.Country, CustomerCountries.Country
FROM (SELECT DISTINCT Country FROM Suppliers) SupplierCountries
FULL JOIN (SELECT DISTINCT Country FROM Customers) CustomerCountries
ON SupplierCountries.Country = CustomerCountries.Country;

--Exercise 54
;with SupplierCountries AS (
    SELECT
    Country, COUNT(Country) as Total
    FROM Suppliers
    GROUP BY Country
), CustomerCountries AS (
    SELECT
    Country, COUNT(Country) as Total
    FROM Customers
    GROUP BY Country
)

SELECT
Country = ISNULL(SupplierCountries.Country,CustomerCountries.Country),
TotalSuppliers= ISNULL(SupplierCountries.Total, 0),
TotalCustomers= ISNULL(CustomerCountries.Total, 0)
FROM SupplierCountries
FULL JOIN CustomerCountries
ON CustomerCountries.Country = SupplierCountries.Country

--Exercise 55
;with OrdersByCountry AS (
    SELECT OrderId, ShipCountry, CustomerID, OrderDate, RANK() OVER(PARTITION BY ShipCountry ORDER BY OrderDate) AS Rank
    FROM Orders
    GROUP BY ShipCountry, OrderDate, OrderId, CustomerID
)

SELECT ShipCountry, CustomerID, OrderID, OrderDate=CONVERT(date, OrderDate) FROM OrdersByCountry WHERE Rank = 1;

;with OrdersByCountry AS (
    SELECT OrderId, ShipCountry, CustomerID, OrderDate, ROW_NUMBER() OVER(PARTITION BY ShipCountry ORDER BY ShipCountry, OrderDate) as OrderNumber
    FROM Orders
)

SELECT ShipCountry, CustomerID, OrderID, OrderDate=CONVERT(date, OrderDate) FROM OrdersByCountry WHERE OrderNumber = 1;

--Exercise 56
SELECT
InitialOrder.CustomerID, 
InitialOrderID = InitialOrder.OrderID,
InitialOrderDate = InitialOrder.OrderDate,
NextOrderID = NextOrder.OrderID,
NextOrderDate = NextOrder.OrderDate,
DaysBetween = DATEDIFF(DAY, InitialOrder.OrderDate, NextOrder.OrderDate)
FROM Orders InitialOrder
CROSS JOIN Orders NextOrder
WHERE InitialOrder.CustomerID = NextOrder.CustomerID 
AND NextOrder.OrderID > InitialOrder.OrderID
AND DATEDIFF(DAY, InitialOrder.OrderDate, NextOrder.OrderDate) <= 5
ORDER BY InitialOrder.CustomerID, InitialOrder.OrderID;

--Exercise 57
;with InitalAndNextOrders AS (
    SELECT 
    CustomerID, OrderId, OrderDate, LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) as NextOrderDate
    FROM
    Orders
)

SELECT 
CustomerID, OrderDate, NextOrderDate, DATEDIFF(DAY, OrderDate, NextOrderDate) AS DaysBetweenOrders
FROM InitalAndNextOrders 
WHERE DATEDIFF(DAY, OrderDate, NextOrderDate) <= 5
ORDER BY CustomerID, OrderId;
