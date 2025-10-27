drop table if exists orders;
CREATE TABLE Orders (
 Order_id int,
    Cust_id VARCHAR(10),
    Order_dt DATETIME,
    Order_amt DECIMAL(10,2)
);

INSERT INTO Orders 
VALUES
(1,'C1', '2025-01-01 09:15:00', 200.00),
(2,'C1', '2025-01-01 16:45:00', 150.00),
(3,'C2', '2025-01-01 10:20:00', 300.00),
(4,'C3', '2025-01-02 11:10:00', 250.00),
(5,'C1', '2025-01-02 13:00:00', 100.00),
(6,'C1', '2025-01-03 09:30:00', 180.00),
(7,'C2', '2025-01-03 15:50:00', 220.00);

select * from EMPLOYEE.dbo.Orders;

-- Write SQL query to find the new and repeat customer for each order Date
    -- New customer is one who has placed order for the First TIME
    -- Repeat customer is one who has already placed an order before
    -- output Order_dt | New_cust(count) | Repeat_cust(count)

    -- If a customer places multiple order in same day count them as 1

WITH CTE AS (
select distinct Cust_id, CAST(Order_dt as DATE) as order_date,
MIN(CAST(order_dt as DATE)) OVER (PARTITION BY Cust_id) as first_order_date
FROM EMPLOYEE.dbo.Orders
)
SELECT order_date,
    SUM(CASE 
        WHEN order_date = first_order_date then 1 else 0 end) as new_cust,
    SUM(CASE
            WHEN order_date>first_order_date then 1 else 0 end) as Repeat_cust
FROM CTE
GROUP BY order_date
ORDER BY order_date;


