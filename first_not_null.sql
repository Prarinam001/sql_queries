CREATE TABLE EMPLOYEE.dbo.City
(
    city1 VARCHAR(10),
    city2 VARCHAR(10),
    city3 VARCHAR(10)
)

INSERT INTO EMPLOYEE.dbo.City
    (city1, city2, city3)
VALUES
    ('Goa', '', 'AP'),
    ('', 'AP', NULL),
    (NULL, '', 'bglr')

SELECT * FROM EMPLOYEE.dbo.City;

SELECT 
    COALESCE(
        CASE WHEN city1 = '' THEN NULL ELSE city1 END,
        CASE WHEN city2 = '' THEN NULL ELSE city2 END,
        CASE WHEN city3 = '' THEN NULL ELSE city3 END
    ) AS 'FirstNotNull'
FROM EMPLOYEE.dbo.City;