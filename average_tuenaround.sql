CREATE TABLE drivers (
driver_id INT,
driver_name VARCHAR(50)
);

-- drop table drivers;

CREATE TABLE rides (
ride_id integer, 
driver_id integer, 
start_time DATETIME2, 
end_time DATETIME2 
);

INSERT INTO drivers (driver_id, driver_name) VALUES (401, 'Rajesh'), (402, 'Neha');

INSERT INTO rides (ride_id, driver_id, start_time, end_time)
VALUES
  (501, 401, '2025-01-01 10:00:00', '2025-01-01 10:30:00'),
  (502, 401, '2025-01-01 11:00:00', '2025-01-01 11:25:00'),
  (503, 401, '2025-01-01 12:00:00', '2025-01-01 12:30:00'),
  (504, 402, '2025-01-01 09:00:00', '2025-01-01 09:45:00'),
  (505, 402, '2025-01-01 10:30:00', '2025-01-01 11:00:00');

SELECT * FROM drivers;

SELECT * FROM rides;


-- GET the Average Turn Around time

WITH rides_gaps AS (
SELECT driver_id, start_time, 
LAG(end_time) OVER (PARTITION BY driver_id ORDER BY start_time) as prev_end
FROM rides
)

SELECT d.driver_id, d.driver_name, ROUND(AVG(DATEDIFF(MINUTE, prev_end, start_time)), 2) as avg_gap_minutes
FROM rides_gaps rg
JOIN drivers d
ON d.driver_id = rg.driver_id
GROUP BY d.driver_id, d.driver_name
ORDER BY avg_gap_minutes ASC;


-- Here we have already DATETIME2 data type that's why CAST not needed

SELECT ride_id, driver_id, 
MONTH(start_time) as month,
YEAR(start_time) as year
FROM rides;
