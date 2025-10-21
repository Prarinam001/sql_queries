CREATE TABLE purchase(
    cust_id INT,
    category VARCHAR(20)
)
-- DROP TABLE purchase;

INSERT INTO purchase (cust_id, category) VALUES 
(1, 'Electronics'),
(1, 'Clothing'),
(1, 'Books'),
(2, 'Electronics'),
(2, 'Clothing'),
(3, 'Electronics'),
(3, 'Clothing'),
(3, 'Books'),
(4, 'Books');

SELECT * FROM purchase;

-- Find customers who made purchases in every category available.
select cust_id, COUNT(distinct category) as cnt
FROM purchase
GROUP BY cust_id
HAVING COUNT(distinct category) = (SELECT COUNT(distinct category) from purchase);
