-- -- Create a stored procedure with input and output parameters for snowflake
-- CREATE OR REPLACE PROCEDURE demo_proc(
--     IN input_value INT,          -- Input parameter
--     OUT output_message STRING    -- Output parameter
-- )
-- RETURNS STRING
-- LANGUAGE SQL
-- AS
-- $$
-- DECLARE
--     counter INT DEFAULT 0;
--     sum_val INT DEFAULT 0;
--     result STRING;
-- BEGIN
--     -- IF condition
--     IF input_value < 0 THEN
--         LET result = 'Negative input not allowed';
--         LET output_message = result;
--         RETURN result;
--     ELSEIF input_value = 0 THEN
--         LET result = 'Input is zero';
--         LET output_message = result;
--         RETURN result;
--     ELSE
--         LET result = 'Valid positive input';
--     END IF;

--     -- WHILE loop
--     WHILE counter < input_value DO
--         LET sum_val = sum_val + counter;
--         LET counter = counter + 1;
--     END WHILE;

--     -- FOR loop
--     FOR i IN 1..input_value DO
--         LET sum_val = sum_val + i;
--     END FOR;

--     -- Final message
--     LET result = 'Sum calculated: ' || sum_val;
--     LET output_message = result;
--     RETURN result;

-- EXCEPTION
--     WHEN OTHER THEN
--         LET result = 'An error occurred: ' || ERROR_MESSAGE();
--         LET output_message = result;
--         RETURN result;
-- END;
-- $$;


-- CALL demo_proc(5, 22);



-- from pyspark.sql import functions as F

-- df_transformed = df \
--     .withColumn("amount_with_tax", F.col("amount") * 1.18) \
--     .withColumn("region_upper", F.upper(F.col("region"))) \
--     .withColumn("is_high_value", F.when(F.col("amount") > 5000, 1).otherwise(0)) \
--     .withColumn("category_flag", F.when(F.col("category") == "Electronics", "E").otherwise("O"))


-- CREATE OR REPLACE PROCEDURE transform_orders(
--     IN min_amount NUMBER,
--     IN region_filter STRING,
--     IN category_filter STRING
-- )
-- RETURNS TABLE (
--     order_id INT,
--     amount NUMBER,
--     region STRING,
--     category STRING,
--     amount_with_tax NUMBER,
--     region_upper STRING,
--     is_high_value INT,
--     category_flag STRING
-- )
-- LANGUAGE SQL
-- AS
-- $$
-- BEGIN
--     RETURN TABLE(
--         SELECT 
--             order_id,
--             amount,
--             region,
--             category,
--             -- Equivalent of withColumn("amount_with_tax", F.col("amount") * 1.18)
--             amount * 1.18 AS amount_with_tax,
--             -- Equivalent of withColumn("region_upper", F.upper(F.col("region")))
--             UPPER(region) AS region_upper,
--             -- Equivalent of withColumn("is_high_value", F.when(F.col("amount") > 5000, 1).otherwise(0))
--             CASE WHEN amount > 5000 THEN 1 ELSE 0 END AS is_high_value,
--             -- Equivalent of withColumn("category_flag", F.when(F.col("category") == "Electronics", "E").otherwise("O"))
--             CASE WHEN category = 'Electronics' THEN 'E' ELSE 'O' END AS category_flag
--         FROM orders
--         WHERE amount >= min_amount
--           AND region = region_filter
--           AND category = category_filter
--     );
-- END;
-- $$;



CREATE PROCEDURE demo_proc
    @input_value INT,
    @output_message NVARCHAR(200) OUTPUT
AS
BEGIN
    DECLARE @counter INT = 0;
    DECLARE @sum_val INT = 0;
    DECLARE @result NVARCHAR(200);

    -- IF condition
    IF @input_value < 0
        SET @result = 'Negative input not allowed';
    ELSE IF @input_value = 0
        SET @result = 'Input is zero';
    ELSE
        SET @result = 'Valid positive input';

    -- WHILE loop
    WHILE @counter < @input_value
    BEGIN
        SET @sum_val = @sum_val + @counter;
        SET @counter = @counter + 1;
    END

    -- FOR loop (simulate with WHILE)
    SET @counter = 1;
    WHILE @counter <= @input_value
    BEGIN
        SET @sum_val = @sum_val + @counter;
        SET @counter = @counter + 1;
    END

    SET @result = 'Sum calculated: ' + CAST(@sum_val AS NVARCHAR(20));
    SET @output_message = @result;
END;

DECLARE @msg NVARCHAR(200);
EXEC demo_proc 5, @msg OUTPUT;
PRINT @msg;