CREATE TABLE Employee.dbo.Sales_duplicate
(
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    Category VARCHAR(50),
    Revenue DECIMAL(10,2)
);
INSERT INTO Employee.dbo.Sales_duplicate
    (OrderID, OrderDate, Category, Revenue)
VALUES
    (1, '2024-03-01', 'Electronics', 500.00),
    (2, '2024-03-02', 'Clothing', 700.00),
    (3, '2024-03-03', 'Electronics', 300.00),
    (4, '2024-03-03', 'Clothing', 450.00),
    (5, '2024-03-04', 'Electronics', 650.00),
    (6, '2024-03-05', 'Clothing', 200.00),
    (7, '2024-03-05', 'Electronics', 300.00),
    (8, '2024-03-05', 'Electronics', 200.00),
    (9, '2024-03-06', 'Clothing', 800.00),
    (10, '2024-03-06', 'Electronics', 500.00),
    (11, '2024-03-07', 'Clothing', 750.00);

SELECT *
FROM Employee.dbo.Sales_duplicate;

-- Q1: Find running Total per transaction

-- Here duplicate will appear so, we have to handle that
-- way1
SELECT *, sum(Revenue) OVER (ORDER BY OrderDate) as running_total
FROM EMPLOYEE.dbo.Sales_duplicate;

-- handle Duplicate
-- way2
WITH
    CTE
    AS
    (
        SELECT OrderDate, sum(Revenue) as revenue
        FROM EMPLOYEE.dbo.Sales_duplicate
        GROUP BY OrderDate
    )
SELECT *, sum(revenue) OVER (ORDER BY OrderDate) as running_total
FROM CTE;

-- Q2: Running total per Day, Category Wise

WITH
    day_category_CTE
    AS
    
    (
        SELECT OrderDate, Category, sum(revenue) as total_revenue
        FROM EMPLOYEE.dbo.Sales_duplicate
        GROUP BY OrderDate, Category
    )
SELECT OrderDate, Category,
    sum(total_revenue) OVER(PARTITION BY Category ORDER BY OrderDate)
FROM day_category_CTE;