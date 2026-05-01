-- Create programTable
CREATE TABLE programTable
(
    pro_id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    channel_name NVARCHAR(100) NOT NULL,
    date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL
);

-- Create userTable
CREATE TABLE userTable
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    channel_name NVARCHAR(100) NOT NULL,
    user_login_time DATETIME NOT NULL,
    logout_time DATETIME,
    watching_start_time TIME NOT NULL,
    watching_end_time TIME NOT NULL
);

-- Insert sample data into programTable
INSERT INTO programTable
    (name, channel_name, date, start_time, end_time)
VALUES
    ('Morning News', 'News Channel', '2026-01-31', '08:00', '09:00'),
    ('Sports Highlights', 'Sports TV', '2026-01-31', '10:00', '11:30'),
    ('Comedy Show', 'Entertainment Plus', '2026-01-31', '14:00', '15:00'),
    ('Documentary Series', 'Discovery', '2026-01-31', '16:00', '17:00'),
    ('Evening Movie', 'Movie Max', '2026-01-31', '19:00', '21:30'),
    ('Late Night Talk Show', 'Comedy Central', '2026-01-31', '22:00', '23:30'),
    ('Music Festival', 'Music TV', '2026-02-01', '11:00', '13:00'),
    ('Weather Update', 'News Channel', '2026-02-01', '06:00', '06:30');

-- Insert sample data into userTable
INSERT INTO userTable
    (name, channel_name, user_login_time, logout_time, watching_start_time, watching_end_time)
VALUES
    ('John Smith', 'News Channel', '2026-01-31 08:00:00', '2026-01-31 10:30:00', '08:15', '10:00'),
    ('Sarah Johnson', 'Sports TV', '2026-01-31 09:30:00', '2026-01-31 23:00:00', '10:00', '11:30'),
    ('Michael Brown', 'Entertainment Plus', '2026-01-31 14:15:00', '2026-01-31 17:45:00', '14:30', '16:00'),
    ('Emily Davis', 'Movie Max', '2026-01-31 19:00:00', '2026-02-01 00:30:00', '19:00', '21:30'),
    ('Robert Wilson', 'Comedy Central', '2026-01-31 22:00:00', '2026-02-01 02:00:00', '22:15', '23:45'),
    ('Jessica Martinez', 'News Channel', '2026-02-01 06:00:00', '2026-02-01 14:30:00', '06:30', '13:00'),
    ('David Lee', 'Music TV', '2026-02-01 10:00:00', '2026-02-01 18:00:00', '11:00', '13:30'),
    ('Amanda Taylor', 'Discovery', '2026-02-01 11:30:00', '2026-02-01 15:00:00', '11:45', '13:00'),
    ('Kevin Harris', 'News Channel', '2026-02-01 09:00:00', '2026-02-01 09:15:00', '09:00', '09:10'),
    ('Lisa Anderson', 'Sports TV', '2026-02-01 12:00:00', '2026-02-01 12:30:00', '12:00', '12:20'),
    ('James Thompson', 'Entertainment Plus', '2026-02-01 14:00:00', '2026-02-01 14:45:00', '14:00', '14:35'),
    ('Patricia White', 'Movie Max', '2026-02-01 16:00:00', '2026-02-01 18:00:00', '16:00', '17:30');


select *
from programTable;

select *
from userTable;


-- Query to find 15-minute QH (Quarter Hour) level data for each user
SELECT
    Id,
    name,
    channel_name,
    watching_start_time,
    watching_end_time,
    DATEDIFF(MINUTE, CAST(watching_start_time AS DATETIME), CAST(watching_end_time AS DATETIME)) AS total_watching_minutes,
    CEILING(CAST(DATEDIFF(MINUTE, CAST(watching_start_time AS DATETIME), CAST(watching_end_time AS DATETIME)) AS FLOAT) / 15) AS quarter_hour_blocks,
    CASE 
        WHEN DATEDIFF(MINUTE, CAST(watching_start_time AS DATETIME), CAST(watching_end_time AS DATETIME)) <= 15 THEN '0-15 min'
        WHEN DATEDIFF(MINUTE, CAST(watching_start_time AS DATETIME), CAST(watching_end_time AS DATETIME)) <= 30 THEN '15-30 min'
        WHEN DATEDIFF(MINUTE, CAST(watching_start_time AS DATETIME), CAST(watching_end_time AS DATETIME)) <= 45 THEN '30-45 min'
        ELSE '45+ min'
    END AS QH_category
FROM userTable
ORDER BY Id, quarter_hour_blocks DESC;







WITH
    UserRanges
    AS
    (
        SELECT
            Id,
            name,
            channel_name,
            CAST(CONVERT(varchar(10), CAST(user_login_time AS date), 23) + ' ' + CONVERT(varchar(8), watching_start_time) AS datetime) AS ws_dt,

            CAST(CONVERT(varchar(10), CAST(user_login_time AS date), 23) + ' ' + CONVERT(varchar(8), watching_end_time) AS datetime) AS we_dt
        FROM userTable
    ),
    Normalized
    AS
    (
        SELECT
            Id, name, channel_name, ws_dt,
            CASE WHEN we_dt <= ws_dt THEN DATEADD(day,1,we_dt) ELSE we_dt END AS we_dt
        FROM UserRanges
    ),
    cte
    AS
    (
                    SELECT Id, name, channel_name, ws_dt AS interval_start, we_dt, 1 AS block_num
            FROM Normalized
        UNION ALL
            SELECT Id, name, channel_name, DATEADD(minute,15,interval_start), we_dt, block_num+1
            FROM cte
            WHERE DATEADD(minute,15,interval_start) < we_dt
    )
SELECT
    Id,
    name,
    channel_name,
    interval_start AS qh_start,
    CASE WHEN DATEADD(minute,15,interval_start) <= we_dt THEN DATEADD(minute,15,interval_start) ELSE we_dt END AS qh_end,
    DATEDIFF(minute, interval_start, CASE WHEN DATEADD(minute,15,interval_start) <= we_dt THEN DATEADD(minute,15,interval_start) ELSE we_dt END) AS minutes_in_block,
    block_num
FROM cte
ORDER BY Id, interval_start
OPTION
(MAXRECURSION
0);





WITH UserRanges AS (
    SELECT
        Id,
        name,
        channel_name,
        DATEADD(
            SECOND,
            DATEDIFF(SECOND, 0, watching_start_time),
            CAST(user_login_time AS datetime)   -- ✅ use datetime, not date
        ) AS ws_dt,
        DATEADD(
            SECOND,
            DATEDIFF(SECOND, 0, watching_end_time),
            CAST(user_login_time AS datetime)   -- ✅ use datetime, not date
        ) AS we_dt
    FROM userTable
),
Normalized AS (
    SELECT
        Id,
        name,
        channel_name,
        ws_dt,
        CASE WHEN we_dt <= ws_dt THEN DATEADD(DAY, 1, we_dt) ELSE we_dt END AS we_dt
    FROM UserRanges
),
Numbers AS (
    SELECT TOP (96) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS n
    FROM sys.objects -- gives us a quick sequence of numbers
)
SELECT
    u.Id,
    u.name,
    u.channel_name,
    DATEADD(MINUTE, 15*n.n, u.ws_dt) AS qh_start,
    CASE 
        WHEN DATEADD(MINUTE, 15*(n.n+1), u.ws_dt) <= u.we_dt 
        THEN DATEADD(MINUTE, 15*(n.n+1), u.ws_dt) 
        ELSE u.we_dt 
    END AS qh_end,
    DATEDIFF(
        MINUTE,
        DATEADD(MINUTE, 15*n.n, u.ws_dt),
        CASE 
            WHEN DATEADD(MINUTE, 15*(n.n+1), u.ws_dt) <= u.we_dt 
            THEN DATEADD(MINUTE, 15*(n.n+1), u.ws_dt) 
            ELSE u.we_dt 
        END
    ) AS minutes_in_block,
    n.n+1 AS block_num
FROM Normalized u
JOIN Numbers n
    ON DATEADD(MINUTE, 15*n.n, u.ws_dt) < u.we_dt
ORDER BY u.Id, qh_start;