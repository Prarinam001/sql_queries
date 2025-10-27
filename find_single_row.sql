create table Employee.dbo.routes (
    source_city VARCHAR(50),
    destination_city VARCHAR(50)
);

insert into Employee.dbo.routes (source_city, destination_city) values
('Delhi', 'Hyderabad'),
('Hyderabad', 'Delhi'),
('Bangalore', 'Mumbai'),
('Mumbai', 'Bangalore'),
('Kolkata', 'Pune'),
('Pune', 'Kolkata');

SELECT * FROM EMPLOYEE.dbo.routes;

-- output should BE

-- source_city  destination_city
--    Delhi       Hyderabad
--    Bangalore   Mumbai
--    Kolkata     Pune


-- 1. using CASE WHEN
WITH CTE AS (
    SELECT *, 
    (CASE 
    WHEN source_city<destination_city then source_city else destination_city end) as new_source,
    (CASE 
    WHEN source_city<destination_city then destination_city else source_city end) as new_destination
    FROM EMPLOYEE.dbo.routes
    )
SELECT new_source as source_city, new_destination as destination_city from CTE GROUP BY new_source, new_destination;

-- 2. using SELF JOIN + CTE
WITH CTE AS(
SELECT * , ROW_NUMBER() OVER(ORDER BY source_city, destination_city) as rn
FROM Employee.dbo.routes
)
SELECT cte1.source_city, cte1.destination_city
FROM CTE as cte1
JOIN CTE as cte2 
ON cte1.source_city = cte2.destination_city
AND cte1.destination_city = cte2.source_city
AND cte1.rn<cte2.rn
ORDER BY cte1.source_city;
