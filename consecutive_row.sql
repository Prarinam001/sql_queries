-- Write a query to produce the start and end date for each consecutive run of the same event
-- Consecutive means the same event occurs in sequential rows ordered by date
-- If a run contains only one row , set start date = end_date

create table Employee.dbo.events (
    event VARCHAR(50),
    event_dt DATE
);

insert into events (event, event_dt) VALUES
('fail', '2020-01-04'),
('success', '2020-01-01'),
('success', '2020-01-03'),
('success', '2020-01-06'),
('fail', '2020-01-05'),
('success', '2020-01-02');

SELECT * FROM events;

SELECT event, event_dt ,
ROW_NUMBER() OVER(ORDER BY event_dt) as rn
FROM events;

SELECT event, event_dt ,
ROW_NUMBER() OVER(PARTITION BY event ORDER BY event_dt) as rn
FROM events;

-- ==================================== ACTUAL QUERY ===========================================
WITH CTE AS(
    SELECT event, event_dt ,
    (ROW_NUMBER() OVER(ORDER BY event_dt)-
    ROW_NUMBER() OVER(PARTITION BY event ORDER BY event_dt)) as event_wise_rn
    FROM events
)
SELECT event, MIN(event_dt) as start_date, MAX(event_dt) as end_date
FROM CTE
GROUP BY event, event_wise_rn
ORDER BY start_date;
