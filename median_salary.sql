-- Find median of each department

CREATE TABLE EMPLOYEE.dbo.Department
(
    Department VARCHAR(10),
    Salary INT
)

INSERT INTO EMPLOYEE.dbo.Department
    (Department, Salary)
VALUES
    ('IT', 5000),
    ('IT', 7000),
    ('IT', 6500),
    ('HR', 4500),
    ('HR', 5500),
    ('FINANCE', 6000),
    ('FINANCE', 4000),
    ('FINANCE', 8000)

SELECT *
FROM EMPLOYEE.dbo.Department;

WITH
    CTE1
    AS
    (
        SELECT * ,
            ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Salary) rn,
            COUNT(Salary) OVER (PARTITION BY Department) count
        FROM EMPLOYEE.dbo.Department
    ),
    CTE2
    AS
    (
        SELECT *, CEILING(count / 2.0) middle,
            CASE 
    WHEN (count % 2.0) = 0 THEN CEILING(count / 2.0)+1 ELSE CEILING(count / 2.0) END next_to_middle
        FROM CTE1
    )

SELECT Department, CEILING(AVG(Salary))
FROM CTE2
WHERE rn = middle or rn = next_to_middle
GROUP BY Department