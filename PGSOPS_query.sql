CREATE DATABASE PGSOPS;

USE PGSOPS;

CREATE TABLE P_MC_WAREHOUSE_DATA(
    WAREHOUSE_ID INT,
    WAREHOUSE_NAME VARCHAR(50),
    SAMPLE_NUMBER VARCHAR(50),
    RESULT_NUMBER VARCHAR(50),
    PRODUCT_NAME VARCHAR(50),
    SUB_PRODUCT_NAME VARCHAR(50),
    NUMERIC_PARAMETER_VALUE FLOAT,
    LOWER_CONTROL_LIMIT FLOAT,
    UPPER_CONTROL_LIMIT FLOAT,
    REAGENT_LOT VARCHAR(50),
    REAGENT_LOT_STATUS VARCHAR(10)
);

INSERT INTO P_MC_WAREHOUSE_DATA
    (WAREHOUSE_ID, WAREHOUSE_NAME, SAMPLE_NUMBER, RESULT_NUMBER, PRODUCT_NAME, SUB_PRODUCT_NAME, NUMERIC_PARAMETER_VALUE, LOWER_CONTROL_LIMIT, UPPER_CONTROL_LIMIT, REAGENT_LOT, REAGENT_LOT_STATUS)
VALUES
    (1, 'Warehouse A', 'S001', 'R001', 'Product vbd_X', 'Sub-product Y', 5.5, 4.0, 6.0, 'LOT1', 'OK'),
    (2, 'Warehouse B', 'S002', 'R002', 'Product vbd_Z', 'Sub-product W', 66.0, 2.0, 20.0, 'LOT2', 'OK'),
    (3, 'Warehouse C', 'S003', 'R0803', 'Product X', 'Sub-product Y', 6.8, NULL, 7.0, 'LOT1', 'NOT OK'),
    (4, 'Warehouse D', 'S004', 'R004', 'Product Z', 'Sub-product W', 2.5, 1.0, NULL, 'LOT2', 'OK'),
    (5, 'Warehouse E', 'S005', 'R005', 'Product X', 'Sub-product Y', NULL, NULL, 70.0, 'LOT1', 'OK'),
    (6, 'Warehouse A1', 'S001', 'R1001', 'Product jnc_X', 'Sub-product Y', 5.5, 4.0, 6.0, 'LOT1', 'OK'),
    (7, 'Warehouse B1', 'S002', 'R002', 'Product mnb_Z1', 'Sub-product W', 66.0, 2.0, 55.0, 'LOT2', 'OK'),
    (8, 'Warehouse C1', 'S003', 'R2003', 'Product yhbd_X', 'Sub-product Y', 90.8, NULL, 88.0, 'LOT1', 'NOT OK'),
    (9, 'Warehouse D1', 'S004', 'R004', 'Product 1Z', 'Sub-product W', 2.5, 1.0, NULL, 'LOT2', 'OK'),
    (10, 'Warehouse E1', 'S005', 'R0505', 'Product X', 'Sub-product Y', NULL, NULL, 200.0, 'LOT1', 'OK'),
    (11, 'Warehouse D2', 'S002', 'R002', 'Product vbd_Z', 'Sub-product W', 36.0, 2.0, 25.0, 'LOT2', 'OK'),
    (12, 'Warehouse B3', 'S002', 'R002', 'Product vbd_Z', 'Sub-product W', 6.0, 2.0, 30.0, 'LOT2', 'OK'),
    (13, 'Warehouse B5', 'S002', 'R002', 'Product vbd_Z', 'Sub-product W', 16.0, 2.0, 20.0, 'LOT2', 'OK');

SELECT * FROM P_MC_WAREHOUSE_DATA;
-- TRUNCATE TABLE P_MC_WAREHOUSE_DATA;
SELECT name FROM sys.databases;


CREATE TABLE P_RW_REAGENT_LOT_DATA(
    REAGENT_LOT_ID INT,
    REAGENT_LOT VARCHAR(50),
    REAGENT_LOT_STATUS VARCHAR(10),
    REAGENT_PARAMETER_NAME VARCHAR(50),
    REAGENT_PARAMETER_VALUE FLOAT
);

INSERT INTO P_RW_REAGENT_LOT_DATA
    (REAGENT_LOT_ID, REAGENT_LOT, REAGENT_LOT_STATUS, REAGENT_PARAMETER_NAME, REAGENT_PARAMETER_VALUE) 
    VALUES
    (1, 'LOT1', 'OK', 'Parameter A', 5.0),
    (2, 'LOT2', 'OK', 'Parameter B', 10.0),
    (3, 'LOT3', 'NOT OK', 'Parameter C', 15.0),
    (4, 'LOT4', 'OK', 'Parameter A', 5.0),
    (5, 'LOT2', 'OK', 'Parameter B', 10.0),
    (6, 'LOT1', 'NOT OK', 'Parameter C', 15.0);

SELECT * FROM P_RW_REAGENT_LOT_DATA;

-- I have below two tables
-- CREATE TABLE P_MC_WAREHOUSE_DATA(
--     WAREHOUSE_ID INT,
--     WAREHOUSE_NAME VARCHAR(50),
--     SAMPLE_NUMBER VARCHAR(50),
--     RESULT_NUMBER VARCHAR(50),
--     PRODUCT_NAME VARCHAR(50),
--     SUB_PRODUCT_NAME VARCHAR(50),
--     NUMERIC_PARAMETER_VALUE FLOAT,
--     LOWER_CONTROL_LIMIT FLOAT,
--     UPPER_CONTROL_LIMIT FLOAT,
--     REAGENT_LOT VARCHAR(50),
--     REAGENT_LOT_STATUS VARCHAR(10)
-- );
-- CREATE TABLE P_RW_REAGENT_LOT_DATA(
--     REAGENT_LOT_ID INT,
--     REAGENT_LOT VARCHAR(50),
--     REAGENT_LOT_STATUS VARCHAR(10),
--     REAGENT_PARAMETER_NAME VARCHAR(50),
--     REAGENT_PARAMETER_VALUE FLOAT
-- );
-- for tis two tables write a query where 
-- product='pr1', sub_product='s-pr1', ragent_parameter_name = 'rage_nm1', numeric_parameter_value is not null, lower_control_limit and upper_control_limit not null

-- -- find the 1. max(upper_control_limit), min(lower_control_limit) 
-- 2. count number of total numeric_parameter_value where this filters fulfil
-- 3. the exceed count where numeric_parameter_value > upper_control_limit


WITH filtered AS (
    SELECT DISTINCT
        w.WAREHOUSE_ID,
        w.NUMERIC_PARAMETER_VALUE,
        w.LOWER_CONTROL_LIMIT,
        w.UPPER_CONTROL_LIMIT
    FROM P_MC_WAREHOUSE_DATA w
    JOIN P_RW_REAGENT_LOT_DATA r
        ON w.REAGENT_LOT = r.REAGENT_LOT
       AND w.REAGENT_LOT_STATUS = r.REAGENT_LOT_STATUS
    WHERE w.PRODUCT_NAME = 'Product vbd_Z'
      AND w.SUB_PRODUCT_NAME = 'Sub-product W'
      AND r.REAGENT_PARAMETER_NAME = 'Parameter B'
      AND w.NUMERIC_PARAMETER_VALUE IS NOT NULL
      AND w.LOWER_CONTROL_LIMIT IS NOT NULL
      AND w.UPPER_CONTROL_LIMIT IS NOT NULL
)
-- SELECT * FROM filtered;
SELECT
    MAX(UPPER_CONTROL_LIMIT) AS max_upper_control_limit,
    MIN(LOWER_CONTROL_LIMIT) AS min_lower_control_limit,
    COUNT(NUMERIC_PARAMETER_VALUE) AS total_numeric_values,
    SUM(CASE WHEN NUMERIC_PARAMETER_VALUE > UPPER_CONTROL_LIMIT THEN 1 ELSE 0 END) AS exceed_count
FROM filtered;
