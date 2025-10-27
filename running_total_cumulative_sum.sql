CREATE TABLE Employee.dbo.Sales_report (
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    Category VARCHAR(50),
    Revenue DECIMAL(10,2)
);

INSERT INTO Employee.dbo.Sales_report (OrderID, OrderDate, Category, Revenue) VALUES
(1, '2024-03-01', 'Electronics', 500.00),
(2, '2024-03-02', 'Clothing', 700.00),
(3, '2024-03-03', 'Electronics', 750.00),
(4, '2024-03-04', 'Clothing', 650.00),
(5, '2024-03-05', 'Electronics', 700.00),
(6, '2024-03-06', 'Clothing', 1300.00),
(7, '2024-03-07', 'Electronics', 750.00);

SELECT * FROM Employee.dbo.Sales_report;

-- Each Day, Running toal is the sum of all previous sale + today's sale

SELECT *, sum(CAST(Revenue as numeric)) OVER (ORDER BY OrderDate) as running_total
FROM Employee.dbo.Sales_report;