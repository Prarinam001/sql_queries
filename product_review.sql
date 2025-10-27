CREATE TABLE review_table (
id INT, 
product_id VARCHAR(10), 
submit_date VARCHAR(20), 
stars integer
)

SELECT * FROM EMPLOYEE.dbo.review_table;

INSERT INTO review_table (id, product_id, submit_date, stars) VALUES 
    (1, 'P1', '2024-01-05', 4),
    (2, 'P1', '2024-01-20', 5),
    (3, 'P1', '2024-02-10', 3),
    (4, 'P2', '2024-01-07', 2),
    (5, 'P2', '2024-01-22', 3),
    (6, 'P2', '2024-02-05', 5)


-- Calculate average rating per product per month from a 
-- reviews table and show product_id|month|avg_rating|.

SELECT product_id, 
    MONTH(CAST(submit_date AS DATE)) as month, 
    ROUND(AVG(CAST(stars AS FLOAT)), 2) as avg_rating
FROM EMPLOYEE.dbo.review_table
GROUP BY 
    product_id, 
    MONTH(CAST(submit_date AS DATE))
ORDER BY 
    product_id, 
    MONTH(CAST(submit_date AS DATE));


-- If you need to keep each review row but still display the monthly average, use this instead:

SELECT product_id,
    submit_date,
    MONTH(CAST(submit_date AS DATE)) as month,
    stars,
    AVG(CAST(stars AS FLOAT))
    OVER 
    (PARTITION BY product_id, MONTH(CAST(submit_date AS DATE))) as avg_rating
FROM EMPLOYEE.dbo.review_table
ORDER BY 
    product_id, 
    MONTH(CAST(submit_date AS DATE));
