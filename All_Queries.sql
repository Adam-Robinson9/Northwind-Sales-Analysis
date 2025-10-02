/* 1. Customer Value */
SELECT 
    Customers.CompanyName,
    strftime('%Y-%m', Orders.OrderDate) AS YearMonth,
    ROUND(SUM(OrderDetails.UnitPrice * OrderDetails.Quantity * (1 - OrderDetails.Discount)), 2) AS MonthlyRevenue,
    COUNT(DISTINCT Orders.OrderID) AS MonthlyOrders
FROM Orders
JOIN "Order Details" AS OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
GROUP BY Customers.CompanyName, YearMonth
ORDER BY YearMonth, MonthlyRevenue DESC;

/* 2. Employee Sales */
SELECT
    Employees.FirstName || ' ' || Employees.LastName AS Employee,
    COUNT(DISTINCT Orders.OrderID) AS OrdersHandled,
    ROUND(SUM(OrderDetails.UnitPrice * OrderDetails.Quantity * (1 - OrderDetails.Discount)), 2) AS Revenue
FROM Orders
JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID
JOIN "Order Details" AS OrderDetails ON Orders.OrderID = OrderDetails.OrderID
GROUP BY Employee
ORDER BY Revenue DESC;

/* 3. Low Stock Products */
SELECT
    Products.ProductName,
    Products.UnitsInStock,
    Products.UnitsOnOrder,
    Products.ReorderLevel
FROM Products
WHERE Products.UnitsInStock <= Products.ReorderLevel
ORDER BY Products.UnitsInStock ASC;

/* 4. Product Inventory */
SELECT
    Products.ProductName,
    Products.UnitsInStock,
    Products.UnitsOnOrder,
    Products.ReorderLevel
FROM Products
ORDER BY Products.UnitsInStock ASC;

/* 5. Product Revenue by Year */
SELECT
    Products.ProductName,
    strftime('%Y', Orders.OrderDate) AS Year,
    ROUND(SUM(OrderDetails.UnitPrice * OrderDetails.Quantity * (1 - OrderDetails.Discount)), 2) AS Revenue
FROM "Order Details" AS OrderDetails
JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
JOIN Products ON OrderDetails.ProductID = Products.ProductID
WHERE Orders.OrderDate IS NOT NULL
GROUP BY Products.ProductName, Year
ORDER BY Products.ProductName DESC, Year;

/* 6. Sales by Supplier */
SELECT 
    strftime('%Y-%m', Orders.OrderDate) AS YearMonth,
    Suppliers.CompanyName AS Supplier,
    ROUND(SUM(OrderDetails.UnitPrice * OrderDetails.Quantity * (1 - OrderDetails.Discount)), 2) AS Revenue,
    COUNT(DISTINCT Orders.OrderID) AS NumberOfSales
FROM Orders
JOIN "Order Details" AS OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON OrderDetails.ProductID = Products.ProductID
JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
GROUP BY Supplier, YearMonth
ORDER BY YearMonth, Supplier;

/* 7. Sales by Category */
SELECT 
    strftime('%Y-%m', Orders.OrderDate) AS YearMonth,
    Categories.CategoryName AS Category,
    ROUND(SUM(OrderDetails.UnitPrice * OrderDetails.Quantity * (1 - OrderDetails.Discount)), 2) AS Revenue,
    COUNT(DISTINCT Orders.OrderID) AS NumberOfSales
FROM Orders
JOIN "Order Details" AS OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON OrderDetails.ProductID = Products.ProductID
JOIN Categories ON Products.CategoryID = Categories.CategoryID
GROUP BY Category, YearMonth
ORDER BY YearMonth, Category;

/* 8. Sales by Country */
SELECT 
    strftime('%Y-%m', Orders.OrderDate) AS YearMonth,
    Orders.ShipCountry AS Country,
    ROUND(SUM(OrderDetails.UnitPrice * OrderDetails.Quantity * (1 - OrderDetails.Discount)), 2) AS Revenue,
    COUNT(DISTINCT Orders.OrderID) AS NumberOfSales
FROM Orders
JOIN "Order Details" AS OrderDetails ON Orders.OrderID = OrderDetails.OrderID
GROUP BY Country, YearMonth
ORDER BY YearMonth, Country;