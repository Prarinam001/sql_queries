CREATE TABLE EMPLOYEE.dbo.FLIGHT_DATA(
    cust_id INT,
    flight_id VARCHAR(10),
    origin VARCHAR(50),
    destination VARCHAR(50)
)

INSERT INTO EMPLOYEE.dbo.FLIGHT_DATA (cust_id, flight_id, origin, destination) VALUES 
    (101, 'AI301', 'Chennai', 'Bangalore'),
    (101, 'SG205', 'Bangalore', 'Goa'),
    (101, 'UK847', 'Goa', 'Pune'),
    (102, 'SJ612', 'Kolkata', 'Bhubaneswar'),
    (102, 'AI108', 'Bhubaneswar', 'Visakhapatnam'),
    (102, 'UK203', 'Visakhapatnam', 'Tirupati'),
    (103, 'SG450', 'Jaipur', 'Udaipur'),
    (103, 'AI789', 'Udaipur', 'Ahmedabad'),
    (104, 'UK167', 'Chandigarh', 'Amritsar'),
    (104, 'SJ893', 'Amritsar', 'Jammu'),
    (104, 'AI445', 'Jammu', 'Srinagar'),
    (105, 'SG721', 'Lucknow', 'Varanasi'),
    (105, 'UK356', 'Varanasi', 'Patna');

SELECT * FROM EMPLOYEE.dbo.FLIGHT_DATA;

-- Drop first and last leg of journey for each customer
-- Equivalent PySpark Code:
-- window_spec = Window.partitionBy(col("cust_id")).orderBy(col("cust_id"))
-- df3 = df_flight.withColumn("rn", row_number().over(window_spec))
-- df4 = df3.groupBy(col("cust_id")).agg(min(col("rn")).alias("start"), max(col("rn")).alias("end"))
-- df_answer = df3.join(df4, on=(df3.cust_id == df4.cust_id)).drop(df4.cust_id)
-- df_final = df_answer.groupBy('cust_id').agg(
--     max(when(col('rn') == col('start'), col('origin'))).alias("origin"),
--     max(when(col('rn') == col('end'), col('destination'))).alias("destination"))

WITH df3 AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY cust_id ORDER BY cust_id) AS rn
    FROM EMPLOYEE.dbo.FLIGHT_DATA
),
df4 AS (
    SELECT 
        cust_id,
        MIN(rn) AS start_rn,
        MAX(rn) AS end_rn
    FROM df3
    GROUP BY cust_id
)
SELECT 
    df3.cust_id,
    MAX(CASE WHEN df3.rn = df4.start_rn THEN df3.origin END) AS origin,
    MAX(CASE WHEN df3.rn = df4.end_rn THEN df3.destination END) AS destination
FROM df3
JOIN df4 ON df3.cust_id = df4.cust_id
GROUP BY df3.cust_id;

-- DROP TABLE EMPLOYEE.dbo.FLIGHT_DATA;


